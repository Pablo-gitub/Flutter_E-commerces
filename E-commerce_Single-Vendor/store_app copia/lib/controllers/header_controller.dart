import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HeaderController {
  Future<Map<String, dynamic>> getUnreadMessages() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        final chatQuery = await FirebaseFirestore.instance
            .collection('chats')
            .where('participants', arrayContains: currentUser.uid)
            .get();

        int totalUnreadCount = 0;
        List<Map<String, dynamic>> tempUnreadMessages = [];

        for (var chatDoc in chatQuery.docs) {
          final chatId = chatDoc.id;
          final messagesSnapshot = await FirebaseFirestore.instance
              .collection('chats')
              .doc(chatId)
              .collection('messages')
              .get();

          for (var messageDoc in messagesSnapshot.docs) {
            final messageData = messageDoc.data();
            final viewedBy = List<String>.from(messageData['viewedBy'] ?? []);

            if (!viewedBy.contains(currentUser.uid)) {
              totalUnreadCount++;

              final buyerSnapshot = await FirebaseFirestore.instance
                  .collection('buyers')
                  .doc(messageData['senderId'])
                  .get();

              if (buyerSnapshot.exists) {
                final buyerData = buyerSnapshot.data();
                final fullName = buyerData?['fullName'] ?? 'Unknown';
                final profileImage = buyerData?['profileImage'] ?? '';

                tempUnreadMessages.add({
                  'sender': messageData['senderId'],
                  'text': messageData['text'],
                  'timestamp': messageData['timestamp'].toDate(),
                  'senderName': fullName,
                  'senderImage': profileImage,
                  'chatId': chatId,
                });
              }
            }
          }
        }

        tempUnreadMessages
            .sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

        return {
          'totalUnreadCount': totalUnreadCount,
          'unreadMessages': tempUnreadMessages,
        };
      } catch (e) {
        print('Error fetching unread messages count: $e');
        return {};
      }
    }
    return {};
  }
}
