import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart'; // Aggiunto per generare un postId unico

class UploadPostScreen extends StatefulWidget {
  const UploadPostScreen({super.key});

  @override
  State<UploadPostScreen> createState() => _UploadPostScreenState();
}

class _UploadPostScreenState extends State<UploadPostScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _image; // Corretto il tipo della variabile per gestire il File
  final picker = ImagePicker();
  final TextEditingController _descriptionController = TextEditingController();
  late String description;
  String? fileName;
  String? postId;

  @override
  void initState() {
    super.initState();
    postId = const Uuid().v4(); // Genera un postId unico
  }

  // Metodo per scegliere un'immagine dalla galleria
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        fileName = pickedFile.name; // Usa il nome dell'immagine
      }
    });
  }

  // Funzione per caricare l'immagine su Firebase Storage e ottenere l'URL
  Future<String> _uploadImageToStorage(File image) async {
    Reference ref =
        FirebaseStorage.instance.ref().child('posts_images').child(fileName!);
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  // Funzione per caricare i dati su Firestore
  Future<void> _uploadToFirestore(String imageUrl, String fullName) async {
    final user = _auth.currentUser;
    final String buyerId = user!.uid;

    await _firestore.collection('posts').doc(postId).set({
      'buyerId': buyerId,
      'postId': postId,
      'timeStamp': FieldValue.serverTimestamp(),
      'description': _descriptionController.text,
      'fullName': fullName,
      'postImage': imageUrl,
    }).whenComplete(() {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post uploaded successfully')),
      );
      Navigator.of(context).pop(); // Pop della pagina dopo il completamento
    }).catchError((e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    });
  }

  // Funzione per recuperare il fullName dell'utente
  Future<String> _getFullName() async {
    final user = _auth.currentUser;
    final doc = await _firestore.collection('buyers').doc(user!.uid).get();
    return doc.data()?['fullName'] ?? ''; // Restituisce il fullName dell'utente
  }

  // Funzione per gestire l'intero upload (immagine + dati)
  Future<void> _handlePostUpload() async {
    if (_formKey.currentState!.validate() && _image != null) {
      EasyLoading.show(status: 'Uploading...');
      try {
        // Carica l'immagine e ottieni l'URL
        String imageUrl = await _uploadImageToStorage(_image!);

        // Recupera il fullName e carica i dati del post su Firestore
        String fullName = await _getFullName();
        await _uploadToFirestore(imageUrl, fullName);
      } catch (e) {
        EasyLoading.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and pick an image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('New Post'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[300],
                child: _image != null
                    ? Image.file(_image!, fit: BoxFit.cover)
                    : const Icon(Icons.add_a_photo, size: 50),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                onChanged: (value) {
                  description = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  } else {
                    return null;
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Write a description...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: _handlePostUpload,
          child: Container(
            width: 200,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text(
                'Publish',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
