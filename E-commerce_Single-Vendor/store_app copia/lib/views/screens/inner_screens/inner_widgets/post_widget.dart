import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  final String postImage;
  final String fullName;
  final String description;
  final String profileImage;

  const PostWidget({
    Key? key,
    required this.postImage,
    required this.fullName,
    required this.description, 
    required this.profileImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Immagine del post
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              postImage,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 350,
            ),
          ),
          const SizedBox(height: 10),

          // Nome completo dell'utente
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blue,
                  backgroundImage: profileImage.isNotEmpty
                      ? NetworkImage(profileImage)
                      : const AssetImage('assets/icons/profile.png')
                          as ImageProvider,
                ),
                const SizedBox(width: 8),
                Text(
                  fullName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    CupertinoIcons.chat_bubble_2,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    CupertinoIcons.paperplane,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),

          // Descrizione del post
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
