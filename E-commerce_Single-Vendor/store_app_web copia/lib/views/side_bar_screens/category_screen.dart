import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:store_app_web/views/side_bar_screens/widgets/category_list_widget.dart';

class CategoryScreen extends StatefulWidget {
  static const String id = 'categor-screen';
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  dynamic _image;
  String? fileName;
  late String categoryName;
  final TextEditingController _categoryNameController = TextEditingController();


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
    Reference ref = _firebaseStorage.ref().child('categories').child(fileName!);
    UploadTask uploadTask = ref.putData(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadToFirestore() async {
    if (_formKey.currentState!.validate()) {
      if (_image != null) {
        EasyLoading.show();
        String imageUrl = await _uploadImageToStorage(_image);
        await _firestore.collection('categories').doc(fileName).set({
          'categoryName': categoryName,
          'categoryImage': imageUrl,
        }).whenComplete(() {
          EasyLoading.dismiss();
          setState(() {
            _image = null;
            fileName = null;
            categoryName = "";
            _categoryNameController.clear();
          });
        });
      } else {
        EasyLoading.dismiss();
      }
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
                'Categories',
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
              SizedBox(
                width: 200,
                child: TextFormField(
                  controller: _categoryNameController,
                  onChanged: (value) {
                    categoryName = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Category Name';
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Category Name',
                  ),
                ),
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
          const CategoryListWidget(),
        ],
      ),
    );
  }
}
