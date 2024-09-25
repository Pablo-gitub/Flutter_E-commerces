import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store_app/views/screens/inner_screens/inner_widgets/post_widget.dart';
import 'package:store_app/views/screens/inner_screens/upload_post_screen.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  Future<String> getBuyerProfileImage(String buyerId) async {
    try {
      // Ottieni il documento del buyer corrispondente
      DocumentSnapshot buyerSnapshot =
          await FirebaseFirestore.instance.collection('buyers').doc(buyerId).get();
      
      if (buyerSnapshot.exists) {
        return buyerSnapshot['profileImage'] ?? ''; // Restituisci l'immagine del profilo
      } else {
        return ''; // Restituisci stringa vuota se non trovata
      }
    } catch (e) {
      print('Errore nel recuperare l\'immagine del profilo: $e');
      return ''; // Restituisci stringa vuota in caso di errore
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('timeStamp', descending: true) // Ordina dal più recente al più vecchio
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Uploading error'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No post available'));
          }
          
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var post = snapshot.data!.docs[index];
              String buyerId = post['buyerId']; // Ottieni buyerId dal post

              // Usa FutureBuilder per ottenere l'immagine del profilo del buyer
              return FutureBuilder(
                future: getBuyerProfileImage(buyerId), // Ottieni l'immagine del profilo
                builder: (context, AsyncSnapshot<String> profileSnapshot) {
                  if (profileSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (profileSnapshot.hasError) {
                    return const Center(child: Text('Error loading profile image'));
                  }

                  String profileImage = profileSnapshot.data ?? ''; // Ottieni l'immagine del profilo

                  return PostWidget(
                    postImage: post['postImage'],
                    fullName: post['fullName'],
                    description: post['description'],
                    profileImage: profileImage, // Passa l'immagine del profilo
                  );
                },
              );
            },
          );
        },
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(4.0),
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const UploadPostScreen();
            }));
          },
          child: Container(
            width: 50, // Larghezza del bottone
            height: 50, // Altezza del bottone
            decoration: const BoxDecoration(
              color: Colors.blue, // Colore di sfondo del bottone
              shape: BoxShape.circle, // Rende il bottone rotondo
            ),
            child: const Icon(
              CupertinoIcons.add,
              size: 30, // Dimensione dell'icona
              color: Colors.white, // Colore dell'icona
            ),
          ),
        ),
      ),
    );
  }
}
