import 'package:base_ecommerce/utils/show_snackBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VendorProductDetailScreen extends StatefulWidget {
  final dynamic productData;

  const VendorProductDetailScreen({super.key, this.productData});

  @override
  State<VendorProductDetailScreen> createState() =>
      _VendorProductDetailScreenState();
}

class _VendorProductDetailScreenState extends State<VendorProductDetailScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _brandNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productDescriptionController =
      TextEditingController();
  final TextEditingController _categoryNameController = TextEditingController();
  bool? _isApproved;

  @override
  void initState() {
    setState(() {
      _productNameController.text = widget.productData['productName'];
      _brandNameController.text = widget.productData['brandName'];
      _quantityController.text = widget.productData['quantity'].toString();
      _productPriceController.text =
          widget.productData['productPrice'].toStringAsFixed(2);
      _productDescriptionController.text = widget.productData['description'];
      _categoryNameController.text = widget.productData['category'];
      _isApproved = widget.productData['approved'];

      // Initialize productPrice and productQuantity with values from productData
      productPrice = widget.productData['productPrice'];
      productQuantity = widget.productData['quantity'];
    });
    super.initState();
  }

  double? productPrice;
  int? productQuantity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade900,
        elevation: 0,
        foregroundColor: Colors.white,
        title: Text(widget.productData['productName']),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            TextFormField(
              controller: _productNameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _brandNameController,
              decoration: InputDecoration(labelText: 'Brand Name'),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              onChanged: (value) {
                productQuantity = int.parse(value);
              },
              controller: _quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              onChanged: (value){
                productPrice = double.parse(value);
              },
              controller: _productPriceController,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              maxLength: 800,
              maxLines: 3,
              controller: _productDescriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              enabled: false,
              controller: _categoryNameController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Publish:',
                  style: TextStyle(fontSize: 16),
                ),
                Switch(
                  value: _isApproved ?? false,
                  onChanged: (value) {
                    setState(() {
                      _isApproved = value;
                    });
                  },
                ),
              ],
            ),
          ]),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(12.0),
        child: InkWell(
          onTap: () async {
            if(productPrice != null && productQuantity!=null){
              await _firestore
                .collection('products')
                .doc(widget.productData['productId'])
                .update({
              'productName': _productNameController.text,
              'brandName': _brandNameController.text,
              'quantity': productQuantity,
              'productPrice': productPrice,
              'description': _productDescriptionController.text,
              'category': _categoryNameController.text,
              'approved': _isApproved,
            }).whenComplete((){
              Navigator.pop(context);
            });
            } else {
              showSnack(context, 'Update Quantity And Price');
            }
          },
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.yellow.shade900,
              borderRadius: BorderRadius.circular(
                10,
              ),
            ),
            child: Center(
              child: Text(
                "UPDATE PRODUCT",
                style: TextStyle(
                  fontSize: 18,
                  letterSpacing: 6,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
