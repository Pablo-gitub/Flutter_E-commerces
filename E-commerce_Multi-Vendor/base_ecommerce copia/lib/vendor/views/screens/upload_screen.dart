import 'package:base_ecommerce/provider/product_provider.dart';
import 'package:base_ecommerce/vendor/views/screens/main_vendor_screen.dart';
import 'package:base_ecommerce/vendor/views/screens/upload_tap_screens/attributes_tab_screen.dart';
import 'package:base_ecommerce/vendor/views/screens/upload_tap_screens/general_screen.dart';
import 'package:base_ecommerce/vendor/views/screens/upload_tap_screens/images_tab_screen.dart';
import 'package:base_ecommerce/vendor/views/screens/upload_tap_screens/shipping_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class UploadScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final ProductProvider _productProvider =
        Provider.of<ProductProvider>(context);
    return DefaultTabController(
      length: 4,
      child: Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.yellow.shade900,
            elevation: 0,
            bottom: TabBar(tabs: [
              Tab(
                child: Text('General'),
              ),
              Tab(
                child: Text('Shipping'),
              ),
              Tab(
                child: Text('Attributes'),
              ),
              Tab(
                child: Text('Images'),
              ),
            ]),
          ),
          body: TabBarView(
            children: [
              GeneralScreen(),
              ShippingScreen(),
              AttributesTabScreen(),
              ImagesTabScreen(),
            ],
          ),
          bottomSheet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow.shade900,
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  EasyLoading.show(status: 'Please wait...');

                  final productId = Uuid().v4();

                  try {
                    // Carica i dati su Firestore
                    await _firestore.collection('products').doc(productId).set({
                      'productId': productId,
                      'productName':
                          _productProvider.productData['productName'],
                      'productPrice':
                          _productProvider.productData['productPrice'],
                      'quantity': _productProvider.productData['quantity'],
                      'category': _productProvider.productData['category'],
                      'description':
                          _productProvider.productData['description'],
                      'imageUrlList':
                          _productProvider.productData['imageUrlList'],
                      'scheduleDate':
                          _productProvider.productData['scheduleDate'],
                      'chargeShipping':
                          _productProvider.productData['chargeShipping'],
                      'shippingCharge':
                          _productProvider.productData['shippingCharge'],
                      'brandName': _productProvider.productData['brandName'],
                      'sizeList': _productProvider.productData['sizeList'],
                      'vendorId': FirebaseAuth.instance.currentUser!.uid,
                      'approved': false,
                    });

                    // Operazione Firestore completata con successo
                    EasyLoading.dismiss(); // Chiudi il caricamento
                  } catch (e) {
                    EasyLoading
                        .dismiss(); // Assicurati di chiudere il caricamento
                    EasyLoading.showError('Upload failed. Please try again.');
                    print('Errore durante l\'upload: $e'); // Stampa per debug
                    return; // Esci dalla funzione se c'è un errore
                  }

                  // Se tutto è andato a buon fine, resetta il form e naviga alla schermata principale
                  _formKey.currentState!.reset(); // Reset del form
                  _productProvider.clearData(); // Pulisce i dati del provider
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return MainVendorScreen();
                  }));
                }
              },
              child: Text('save'),
            ),
          ),
        ),
      ),
    );
  }
}
