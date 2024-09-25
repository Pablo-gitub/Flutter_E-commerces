import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderListWidget extends StatelessWidget {
  const OrderListWidget({super.key});

  Widget orderDisplayData(Widget widget, int? flex) {
    return Expanded(
      flex: flex!,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.grey,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _ordersStream =
        FirebaseFirestore.instance.collection('orders').snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _ordersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LinearProgressIndicator();
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.size,
          itemBuilder: (context, index) {
            final orderData = snapshot.data!.docs[index];
            return Row(
              children: [
                orderDisplayData(
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.network(
                      orderData['productImage'],
                    ),
                  ),
                  1,
                ),
                orderDisplayData(
                  Text(
                    orderData['fullName'],
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  1,
                ),
                orderDisplayData(
                  Text(
                    '${orderData['country']} ${orderData['state']} ${orderData['city']} ${orderData['postCode']} ${orderData['road']} ${orderData['postNumber']} ${orderData['inside']}',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  2,
                ),
                orderDisplayData(
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3C55EF),
                    ),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('orders')
                          .doc(orderData['orderId'])
                          .update({
                        'delivered': true,
                        'processing': false,
                        'deliveredCount': FieldValue.increment(1),
                      });
                    },
                    child: orderData['delivered'] == true
                        ? const Text(
                            'Delivered',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Delive it',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                  ),
                  2,
                ),
                orderDisplayData(
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () async {
                      if (orderData['processing']) {
                        await FirebaseFirestore.instance
                            .collection('orders')
                            .doc(orderData['orderId'])
                            .update({
                          'processing': false,
                          'delivered': false,
                        });
                      } else {
                        await FirebaseFirestore.instance
                            .collection('orders')
                            .doc(orderData['orderId'])
                            .update({
                          'processing': true,
                          'delivered': false,
                        });
                      }
                    },
                    child: orderData['processing'] == false &&
                            orderData['delivered'] == true
                        ? const Text(
                            'Processed',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        : orderData['processing'] == true &&
                                orderData['delivered'] == false
                            ? const Text(
                                'Processing',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'To Process',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                  ),
                  2,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
