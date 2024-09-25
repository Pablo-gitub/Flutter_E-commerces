import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ProductsScreen extends StatefulWidget {
  static const String id = 'products-screen';

  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _sizeController = TextEditingController();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final List<String> _categoryList = [];

  //we will be uploading this values stored in this variables to the cloud firestore
  final List<String> _sizeList = [];
  String? selectedCategory;
  late String? productName;
  late num? productPrice;
  late num? discount;
  late num? quantity;
  late String? description;

  //field controller
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isEntered = false;
  final List<Uint8List> _images = [];
  final List<String> _imagesUrls = [];

  chooseImage() async {
    final pickedImages = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );
    if (pickedImages == null) {
      print('Null image picked');
    } else {
      setState(() {
        for (var file in pickedImages.files) {
          _images.add(file.bytes!);
        }
      });
    }
  }

  _getCategories() {
    return _firestore.collection('categories').get().then(
      (QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          setState(
            () {
              _categoryList.add(doc['categoryName']);
            },
          );
        }
      },
    );
  }

  @override
  void initState() {
    _getCategories();
    super.initState();
  }

  //upload product image to storage
  uploadImageToStorage() async {
    for (var img in _images) {
      Reference ref = _firebaseStorage
          .ref()
          .child('productImages')
          .child(const Uuid().v4());
      await ref.putData(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          setState(() {
            _imagesUrls.add(value);
          });
        });
      });
    }
  }

  //function to upload product to cloud
  uploadData() async {
    setState(() {
      _isLoading = true;
    });
    await uploadImageToStorage();
    if (_imagesUrls.isNotEmpty) {
      final productId = const Uuid().v4();
      await _firestore.collection('products').doc(productId).set({
        'productId': productId,
        'productName': productName,
        'productPrice': productPrice,
        'productSize': _sizeList,
        'category': selectedCategory,
        'description': description,
        'discount': discount,
        'quantity': quantity,
        'productImage': _imagesUrls,
      }).whenComplete(() {
        setState(() {
          print('resetting form');
          _isLoading = false;

          // Clear the TextEditingControllers
          _productNameController.clear();
          _productPriceController.clear();
          _discountController.clear();
          _quantityController.clear();
          _descriptionController.clear();

          // Reset the fields
          productName = null;
          productPrice = null;
          selectedCategory = null;
          description = null;
          discount = null;
          quantity = null;
          _imagesUrls.clear();
          _images.clear();
          _sizeList.clear();

          // Reset the form
          _formKey.currentState!.reset();
          print('form has been resetted');
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Product Information',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                onChanged: (value) {
                  productName = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter field';
                  } else {
                    return null;
                  }
                },
                controller: _productNameController,
                decoration: InputDecoration(
                  labelText: 'Enter Product Name',
                  fillColor: Colors.grey[200],
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      onChanged: (value) {
                        productPrice = double.parse(value);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter field';
                        } else {
                          return null;
                        }
                      },
                      controller: _productPriceController,
                      decoration: InputDecoration(
                        labelText: 'Enter Price',
                        fillColor: Colors.grey[200],
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Flexible(
                    child: buildDropDownField(),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                onChanged: (value) {
                  discount = double.parse(value);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter field';
                  } else {
                    return null;
                  }
                },
                controller: _discountController,
                decoration: InputDecoration(
                  labelText: 'Discount Price',
                  fillColor: Colors.grey[200],
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                onChanged: (value) {
                  quantity = int.parse(value);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter field';
                  } else {
                    return null;
                  }
                },
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  fillColor: Colors.grey[200],
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                onChanged: (value) {
                  description = value;
                },
                maxLength: 800,
                maxLines: 4,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter field';
                  } else {
                    return null;
                  }
                },
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Enter Description',
                  fillColor: Colors.grey[200],
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Flexible(
                    child: SizedBox(
                      width: 200,
                      child: TextFormField(
                        controller: _sizeController,
                        onChanged: (value) {
                          setState(() {
                            _isEntered = true;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Add Size',
                          fillColor: Colors.grey[200],
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  _isEntered
                      ? Flexible(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _sizeList.add(_sizeController.text);
                                _sizeController.clear();
                              });
                            },
                            child: const Text('Add'),
                          ),
                        )
                      : const Text(''),
                ],
              ),
              _sizeList.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 50,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _sizeList.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    _sizeList.removeAt(index);
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade800,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        _sizeList[index],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    )
                  : const Text(''),
              const SizedBox(
                height: 15,
              ),
              GridView.builder(
                itemCount: _images.length + 1,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  return index == 0
                      ? Center(
                          child: IconButton(
                              onPressed: () {
                                chooseImage();
                              },
                              icon: const Icon(Icons.add)),
                        )
                      : Image.memory(_images[index - 1]);
                },
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    uploadData();
                    print('Uploaded');
                  } else {
                    //please fill in all field
                    print('bad status');
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Center(
                          child: Text(
                            'Upload Product',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDropDownField() {
    return DropdownButtonFormField(
        decoration: InputDecoration(
          labelText: 'Enter Category',
          fillColor: Colors.grey[200],
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        items: _categoryList.map((value) {
          return DropdownMenuItem(value: value, child: Text(value));
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              selectedCategory = value;
            });
          }
        });
  }
}
