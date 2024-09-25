import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:store_app/controllers/header_controller.dart';
import 'package:store_app/views/screens/inner_screens/chat_detail_screen.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({super.key});

  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  final HeaderController _controller = HeaderController();
  int unreadMessageCount = 0;
  List<Map<String, dynamic>> unreadMessages = [];

  @override
  void initState() {
    super.initState();
    _getTotalUnreadMessagesCount();
  }

  Future<void> _getTotalUnreadMessagesCount() async {
    final result = await _controller.getUnreadMessages();
    setState(() {
      unreadMessageCount = result['totalUnreadCount'] ?? 0;
      unreadMessages = result['unreadMessages'] ?? [];
    });
  }

  void _navigateToChatDetailScreen(String senderId, String chatId) async {
    if (senderId.isEmpty) return;

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        final buyerSnapshot = await FirebaseFirestore.instance
            .collection('buyers')
            .doc(senderId)
            .get();

        if (buyerSnapshot.exists) {
          final buyerData = buyerSnapshot.data();
          final fullName = buyerData?['fullName'] ?? 'Unknown';
          final profileImage = buyerData?['profileImage'] ?? '';

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatDetailScreen(
                receiverId: senderId,
                receiverFullName: fullName,
                receiverImage: profileImage,
                chatId: chatId, // Pass chatId here
              ),
            ),
          );
        }
      } catch (e) {
        print('Error fetching buyer details: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          // Background image
          ExcludeSemantics(
            child: Image.asset(
              'assets/icons/searchBanner.jpeg',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),

          // Row contenent
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // TextField with icons
                SizedBox(
                  width:
                      MediaQuery.of(context).size.width * 0.65, //60% of screen
                  height: 50,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: translate('Enter Text'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF7F7F7F),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      prefixIcon: Semantics(
                        label: translate('Enter Text'),
                        child: Image.asset('assets/icons/searc1.png'),
                      ),
                      suffixIcon: Semantics(
                          label: "Camera",
                          child: Image.asset('assets/icons/cam.png')),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      focusColor: Colors.black,
                    ),
                  ),
                ),

                // Icona campanella
                Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () {
                      // Implementa la funzionalità dell'icona campanella qui
                    },
                    child: Ink(
                      width: 31,
                      height: 31,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/icons/bell.png'),
                        ),
                      ),
                    ),
                  ),
                ),

                // Icona messaggio con menu a tendina
                Stack(
                  children: [
                    PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.message,
                        color: Colors.white,
                      ),
                      onSelected: (String senderId) {
                        final selectedMessage = unreadMessages.firstWhere(
                          (message) => message['sender'] == senderId,
                          orElse: () => {},
                        );
                        final chatId = selectedMessage['chatId'] ?? '';

                        _navigateToChatDetailScreen(senderId, chatId);
                      },
                      itemBuilder: (BuildContext context) {
                        return unreadMessages.map((message) {
                          final timestamp = message['timestamp'];
                          return PopupMenuItem<String>(
                            value: message['sender'],
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    message['senderImage'] != null &&
                                            message['senderImage'].isNotEmpty
                                        ? NetworkImage(message['senderImage'])
                                        : const AssetImage(
                                                'assets/icons/profile.png')
                                            as ImageProvider,
                              ),
                              title: Text(message['senderName']),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message['text'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList();
                      },
                    ),
                    if (unreadMessageCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: Text(
                            unreadMessageCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
