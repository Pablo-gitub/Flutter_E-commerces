import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatDetailScreen extends StatefulWidget {
  final String receiverId;
  final String receiverFullName;
  final dynamic receiverImage;
  final String? chatId;

  const ChatDetailScreen({
    Key? key,
    required this.receiverId,
    required this.receiverFullName,
    required this.receiverImage,
    this.chatId,
  }) : super(key: key);

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? chatId;

  @override
  void initState() {
    super.initState();
    chatId = widget.chatId ??
        ([_auth.currentUser!.uid, widget.receiverId]..sort()).join('_');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _markMessagesAsViewed();
    });
  }

  void _sendMessage() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final message = _messageController.text.trim();
      if (message.isNotEmpty) {
        final chatCollection = _firestore.collection('chats');
        DocumentReference chatDoc = chatCollection.doc(chatId);

        final chatSnapshot = await chatDoc.get();

        if (!chatSnapshot.exists) {
          await chatDoc.set({
            'participants': [_auth.currentUser!.uid, widget.receiverId],
            'lastMessage': message,
            'lastMessageTimestamp': FieldValue.serverTimestamp(),
            'chatId': chatId,
          });
        } else {
          await chatDoc.update({
            'lastMessage': message,
            'lastMessageTimestamp': FieldValue.serverTimestamp(),
          });
        }

        await chatDoc.collection('messages').add({
          'text': message,
          'senderId': currentUser.uid,
          'timestamp': FieldValue.serverTimestamp(),
          'viewedBy': [],
          'viewedTimestamp': {},
          'annex': null,
        });

        _messageController.clear();
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  /// Funzione per segnare i messaggi come visualizzati
  void _markMessagesAsViewed() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null && chatId != null) {
      final chatDoc = _firestore.collection('chats').doc(chatId);

      try {
        // Recupera tutti i messaggi non visualizzati dall'utente corrente
        final messages = await chatDoc.collection('messages').get();

        for (var message in messages.docs) {
          final data = message.data();
          List<dynamic> viewedBy = data['viewedBy'] ?? [];

          // Controlla se il messaggio è già stato visualizzato dall'utente corrente
          if (!viewedBy.contains(currentUser.uid)) {
            // Aggiorna il campo 'viewedBy'
            await chatDoc.collection('messages').doc(message.id).update({
              'viewedBy': FieldValue.arrayUnion([currentUser.uid]),
            });

            // Aggiorna il campo 'viewedTimestamp' con un campo specifico
            await chatDoc.collection('messages').doc(message.id).update({
              'viewedTimestamp.${currentUser.uid}':
                  FieldValue.serverTimestamp(),
            });
          }
        }
      } catch (e) {
        print('Errore durante il tentativo di aggiornare i messaggi: $e');
      }
    }
  }

  /// Funzione per segnare come visualizzati i nuovi messaggi in tempo reale
  void _markNewMessagesAsViewed(List<QueryDocumentSnapshot> messages) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final chatDoc = _firestore.collection('chats').doc(chatId);

      try {
        for (var message in messages) {
          final data = message.data() as Map<String, dynamic>;
          List<dynamic> viewedBy = data['viewedBy'] ?? [];

          if (!viewedBy.contains(currentUser.uid)) {
            // Aggiorna il campo 'viewedBy'
            await chatDoc.collection('messages').doc(message.id).update({
              'viewedBy': FieldValue.arrayUnion([currentUser.uid]),
            });

            // Aggiorna il campo 'viewedTimestamp'
            await chatDoc.collection('messages').doc(message.id).update({
              'viewedTimestamp.${currentUser.uid}': FieldValue.serverTimestamp(),
            });
          }
        }
      } catch (e) {
        print('Errore durante l\'aggiornamento dello stato di visualizzazione: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.receiverImage),
            ),
            const SizedBox(width: 10),
            Text(widget.receiverFullName),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats')
                  .doc(chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  print(
                      'Errore durante il caricamento dei messaggi: ${snapshot.error}');
                  return const Center(
                      child:
                          Text('Errore durante il caricamento dei messaggi'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Nessun messaggio ancora'));
                }

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom(); // Scrolla alla fine dei messaggi
                });

                // Aggiorna lo stato di visualizzazione dei nuovi messaggi
                _markNewMessagesAsViewed(snapshot.data!.docs);

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];
                    final data = doc.data() as Map<String, dynamic>;

                    final text = data['text'] ?? '';
                    final senderId = data['senderId'] ?? '';
                    final isCurrentUser = senderId == _auth.currentUser!.uid;

                    return Align(
                      alignment: isCurrentUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: isCurrentUser
                              ? Colors.blueAccent
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          text,
                          style: TextStyle(
                            color: isCurrentUser ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Scrivi un messaggio',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
