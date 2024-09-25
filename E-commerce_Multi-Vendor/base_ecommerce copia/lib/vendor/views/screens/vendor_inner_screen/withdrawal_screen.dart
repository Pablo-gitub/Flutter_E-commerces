import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class WithdrawalScreen extends StatefulWidget {
  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  late String amount;

  late String name;

  late String mobile;

  late String bankName;

  late String bankAccountName;

  late String bankAccountNumber;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade900,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Withdraw',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 6,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Amount Must Not Be Empty';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    amount = value;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Amount'),
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Name Must Not Be Empty';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    name = value;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Mobile Must Not Be Empty';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    mobile = value;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Mobile'),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Bank Name Must Not Be Empty';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    bankName = value;
                  },
                  keyboardType: TextInputType.text,
                  decoration:
                      InputDecoration(labelText: 'Bank Name, etc Access Bank'),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Bank Account Name Must Not Be Empty';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    bankAccountName = value;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: 'Bank Account Name, testshop srl'),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Account Number Must Not Be Empty';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    bankAccountNumber = value;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Bank Account Number'),
                ),
                TextButton(
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      // store date in cloud firestore
                      await _firestore
                          .collection('withdrowals')
                          .doc(Uuid().v4())
                          .set({
                        'Amount': amount,
                        'Name': name,
                        'Mobile': mobile,
                        'BankName': bankName,
                        'BankAccountName': bankAccountName,
                        'BankAccountNumber': bankAccountNumber,
                      });
                      print('cool');
                    } else {
                      print('False');
                    }
                  },
                  child: Text(
                    'Get Cash',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
