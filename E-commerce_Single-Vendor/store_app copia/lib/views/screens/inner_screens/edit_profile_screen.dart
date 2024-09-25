import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city_picker_2/country_state_city_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EditProfileScreen extends StatefulWidget {
  final dynamic userData;

  const EditProfileScreen({super.key, this.userData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _roadController = TextEditingController();
  final TextEditingController _postCodeController = TextEditingController();
  final TextEditingController _postNumberController = TextEditingController();
  final TextEditingController _insideController = TextEditingController();
  late String countryValue;
  late String stateValue;
  late String cityValue;
  File? _image;

  @override
  void initState() {
    setState(() {
      _fullNameController.text = widget.userData['fullName'] ?? '';
      _emailController.text = widget.userData['email'] ?? '';
      _phoneController.text = widget.userData['phoneNumber'] ?? '';
      _postNumberController.text = widget.userData['postNumber'] ?? '';
      _postCodeController.text = widget.userData['postCode'] ?? '';
      _roadController.text = widget.userData['road'] ?? '';
      //_insideController = widget.userData['inside'] ?? '';
      countryValue = widget.userData['country'] ?? '';
      stateValue = widget.userData['state'] ?? '';
      cityValue = widget.userData['city'] ?? '';
    });
    super.initState();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No image selected.')),
        );
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      String fileName = '${FirebaseAuth.instance.currentUser!.uid}_profile_image.png';

      firebase_storage.Reference storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profile_images/$fileName');

      firebase_storage.UploadTask uploadTask = storageRef.putFile(image);

      await uploadTask;

      String downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            letterSpacing: 6,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.blue,
                      backgroundImage:
                          _image != null ? FileImage(_image!) : null,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: IconButton(
                        onPressed: _pickImage,
                        icon: const Icon(CupertinoIcons.photo),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Full Name',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Email',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Phone',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SelectState(
                    spacing: 15,
                    dropdownColor: Colors.black,
                    onCountryChanged: (value) {
                      setState(() {
                        countryValue = value;
                      });
                    },
                    onStateChanged: (value) {
                      setState(() {
                        stateValue = value;
                      });
                    },
                    onCityChanged: (value) {
                      setState(() {
                        cityValue = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _postCodeController,
                    decoration: const InputDecoration(
                      labelText: 'Post-Code',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 2.0, horizontal: 8.0),
                  child: TextFormField(
                    controller: _roadController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Road',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _postNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Post-Number',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _insideController,
                    decoration: const InputDecoration(
                      labelText: 'Inside',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(13.0),
        child: InkWell(
          onTap: () async {
            EasyLoading.show(status: 'UPDATING');
            try {
              String? imageUrl;
              if (_image != null) {
                imageUrl = await _uploadImage(_image!);
              }

              await _firestore
                  .collection('buyers')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .update({
                'fullName': _fullNameController.text,
                'email': _emailController.text,
                'phoneNumber': _phoneController.text,
                'country': countryValue,
                'state': stateValue,
                'city': cityValue,
                'road': _roadController.text,
                'postCode': _postCodeController.text,
                'postNumber': _postNumberController.text,
                'inside': _insideController.text,
                'profileImage' : imageUrl,
              }).whenComplete(() {
                EasyLoading.dismiss();
                Navigator.pop(context);
              });
            } catch (e) {
              //Navigator.of(context).pop(); // Chiudi il dialogo se c'è un errore
              // Mostra un messaggio di errore
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Errore nell\'aggiornamento: $e')),
              );
            }
          },
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
                child: Text(
              'UPDATE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                letterSpacing: 6,
              ),
            )),
          ),
        ),
      ),
    );
  }
}
