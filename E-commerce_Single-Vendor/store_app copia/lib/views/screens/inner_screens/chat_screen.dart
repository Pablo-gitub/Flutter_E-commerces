import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:store_app/views/screens/inner_screens/chat_detail_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _buyers = [];
  List<DocumentSnapshot> _filteredBuyers = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _fetchBuyers();
    _searchController.addListener(_updateSearchState);
  }

  Future<void> _fetchBuyers() async {
    try {
      final buyers = await _firestore.collection('buyers').get();
      setState(() {
        _buyers = buyers.docs;
        _filteredBuyers = buyers.docs;
      });
    } catch (e) {
      print("Error fetching buyers: $e");
    }
  }

  void _filterBuyers(String query) {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final filtered = _buyers.where((buyer) {
        final fullName = buyer['fullName']?.toLowerCase() ?? '';
        final buyerId = buyer.id;
        return fullName.contains(query.toLowerCase()) &&
            buyerId != currentUser.uid; // Esclude il buyer corrente
      }).toList();

      setState(() {
        _filteredBuyers = filtered;
      });
    }
  }

  void _updateSearchState() {
    setState(() {
      _isSearching = _searchController.text.isNotEmpty;
      if (_isSearching) {
        _filterBuyers(_searchController.text);
      }
    });
  }

  Stream<QuerySnapshot> _getOngoingChats() {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      return _firestore
          .collection('chats')
          .where('participants', arrayContains: currentUser.uid)
          .orderBy('lastMessageTimestamp', descending: true)
          .snapshots();
    }
    return const Stream.empty();
  }

  Future<int> _getUnreadMessagesCount(String chatId) async {
  final currentUser = _auth.currentUser;
  if (currentUser != null) {
    try {
      final messagesSnapshot = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .get();

      // Conta i messaggi che non sono stati letti dall'utente corrente
      int unreadCount = 0;
      for (var doc in messagesSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final viewedBy = List<String>.from(data['viewedBy'] ?? []);
        if (!viewedBy.contains(currentUser.uid)) {
          unreadCount++;
        }
      }
      return unreadCount;
    } catch (e) {
      print('Errore durante il conteggio dei messaggi non letti: $e');
      return 0;
    }
  }
  return 0;
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for buyers...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ),
      ),
      body: _isSearching
          ? ListView(
              children: _filteredBuyers.map((buyer) {
                final fullName = buyer['fullName'];
                final profileImage = buyer['profileImage'];
                final buyerId = buyer.id;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        profileImage != null && profileImage.isNotEmpty
                            ? NetworkImage(profileImage)
                            : const AssetImage('assets/icons/profile.png')
                                as ImageProvider,
                  ),
                  title: Text(fullName),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatDetailScreen(
                          receiverId: buyerId,
                          receiverFullName: fullName,
                          receiverImage: profileImage,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: _getOngoingChats(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                      child: Text('Error loading chats: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No active chats',
                      style: TextStyle(fontSize: 24),
                    ),
                  );
                }

                return ListView(
                  children: snapshot.data!.docs.map((chatDoc) {
                    final chatData = chatDoc.data() as Map<String, dynamic>;
                    final participants =
                        chatData['participants'] as List<dynamic>;
                    final otherParticipantId = participants.firstWhere(
                      (id) => id != _auth.currentUser!.uid,
                    );

                    return FutureBuilder<DocumentSnapshot>(
                      future: _firestore
                          .collection('buyers')
                          .doc(otherParticipantId)
                          .get(),
                      builder: (context, buyerSnapshot) {
                        if (buyerSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(); // Show an empty container while loading
                        }
                        if (buyerSnapshot.hasError) {
                          return Center(
                              child: Text(
                                  'Error loading buyer: ${buyerSnapshot.error}'));
                        }
                        if (!buyerSnapshot.hasData ||
                            !buyerSnapshot.data!.exists) {
                          return const SizedBox(); // Show an empty container if no data
                        }

                        final buyerData =
                            buyerSnapshot.data!.data() as Map<String, dynamic>;
                        final fullName = buyerData['fullName'] ?? 'Unknown';
                        final profileImage = buyerData['profileImage'] ?? '';

                        return FutureBuilder<int>(
                          future: _getUnreadMessagesCount(chatDoc.id),
                          builder: (context, unreadSnapshot) {
                            final unreadCount = unreadSnapshot.data ?? 0;

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: profileImage.isNotEmpty
                                    ? NetworkImage(profileImage)
                                    : const AssetImage(
                                            'assets/icons/profile.png')
                                        as ImageProvider,
                              ),
                              title: Text(fullName),
                              subtitle: Text(
                                  chatData['lastMessage'] ?? 'No messages yet'),
                              trailing: unreadCount > 0
                                  ? CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 12,
                                      child: Text(
                                        unreadCount.toString(),
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    )
                                  : null,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatDetailScreen(
                                      receiverId:
                                          otherParticipantId, // Keep this for displaying the receiver
                                      receiverFullName: fullName,
                                      receiverImage: profileImage,
                                      chatId: chatDoc
                                          .id, // Pass the existing chatId
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),
    );
  }
}
