import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:store_app_web/views/side_bar_screens/widgets/banner_list_widget.dart';

class UploadBannerScreen extends StatefulWidget {
  static const String id = '\banner-screen';
  const UploadBannerScreen({super.key});

  @override
  State<UploadBannerScreen> createState() => _UploadBannerScreenState();
}

class _UploadBannerScreenState extends State<UploadBannerScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  dynamic _image;
  String? fileName;

  pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        _image = result.files.first.bytes;
        fileName = result.files.first.name;
      });
    }
  }

  _uploadImageToStorage(dynamic image) async {
    Reference ref = _firebaseStorage.ref().child('banners').child(fileName!);
    UploadTask uploadTask = ref.putData(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadToFirestore() async {
    if (_image != null) {
      EasyLoading.show();
      String imageUrl = await _uploadImageToStorage(_image);
      await _firestore.collection('banners').doc(fileName).set({
        'image': imageUrl,
      }).whenComplete(() {
        EasyLoading.dismiss();
        setState(() {
          _image = null;
          fileName = null;
        });
      });
    } else {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.topLeft,
              child: const Text(
                'Banners',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
          ),
          Row(
            children: [
              Column(
                children: [
                  Container(
                    height: 140,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade500,
                      border: Border.all(color: Colors.grey.shade800),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: _image != null
                          ? Image.memory(_image)
                          : const Text(
                              'Upload Image',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        pickImage();
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.pressed)) {
                            return Colors.red;
                          } else if (states.contains(WidgetState.hovered)) {
                            return Colors.green;
                          } else if (states.contains(WidgetState.disabled)) {
                            return Colors.grey;
                          }
                          return Colors.blue; // Default color
                        }),
                        foregroundColor: WidgetStateProperty.all<Color>(
                          Colors.white,
                        ),
                      ),
                      child: const Text(
                        'Upload image',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 30,
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    Colors.white,
                  ),
                  side: WidgetStateProperty.all(
                    BorderSide(
                      color: Colors.blue.shade900,
                    ),
                  ),
                ),
                onPressed: () {
                  uploadToFirestore();
                },
                child: const Text(
                  'Save',
                ),
              ),
            ],
          ),
          const BannerListWidget(),
        ],
      ),
    );
  }
}
