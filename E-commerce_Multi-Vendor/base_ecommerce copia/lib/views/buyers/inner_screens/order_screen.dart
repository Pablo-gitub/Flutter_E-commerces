import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BuyerOrderScreen extends StatelessWidget {
  String formatedDate(date) {
    final outPutDateFormate = DateFormat('dd/MM/yyyy');
    final outPutDate = outPutDateFormate.format(date);
    return outPutDate;
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _ordersStream = FirebaseFirestore.instance
        .collection('orders')
        .where('buyerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade900,
        elevation: 0,
        title: Text(
          'My Orders',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 5,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _ordersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.yellow.shade900),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 14,
                        child: document['accepted'] == true
                            ? Icon(Icons.delivery_dining)
                            : Icon(Icons.access_time),
                      ),
                      title: document['accepted'] == true
                          ? Text(
                              'Accepted',
                              style: TextStyle(
                                color: Colors.yellow.shade900,
                              ),
                            )
                          : Text(
                              'Not Accepted',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                      trailing: Text(
                        'Ammount' +
                            " € " +
                            document['productPrice'].toStringAsFixed(2),
                        style: TextStyle(fontSize: 17, color: Colors.blue),
                      ),
                      subtitle: Text(
                        formatedDate(document['orderDate'].toDate()),
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ExpansionTile(
                      title: Text(
                        'Order Details',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.yellow.shade900,
                        ),
                      ),
                      subtitle: Text('View Order Details'),
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            child: Image.network(
                              document['productImage'][0],
                            ),
                          ),
                          title: Text(
                            document['productName'],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    ('Quantity'),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    document['productQuantity'].toString(),
                                  ),
                                ],
                              ),
                              document['accepted'] == true
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text('Schedule Delivery Date'),
                                        Text(formatedDate(
                                            document['scheduleDate'].toDate()))
                                      ],
                                    )
                                  : Text('data'),
                              ListTile(
                                title: Text(
                                  'Buyer Detail',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(document['buyerFullName']),
                                    Text(document['buyerEmail']),
                                    Text(document['buyerAddress']),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
            }).toList(),
          );
        },
      ),
    );
  }
}
