import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Firestore firestore = Firestore.instance;

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  String name;
  String number;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('牛を追加'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: '牛の名前'),
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: '耳標番号（4ケタ）'),
              onChanged: (value) {
                setState(() {
                  number = value;
                });
              },
            ),
            SizedBox(
              height: 50.0,
            ),
            FlatButton(
              color: Colors.green,
              textColor: Colors.white,
              child: Text(
                '登録',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                List<String> cowNames = [name, number];

                await firestore.collection('cows').add({
                  'name': '$name',
                  'number': '$number',
                  'cowNames': cowNames,
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
