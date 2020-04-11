import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memowtask08findfunction/cow.dart';
import 'add_screen.dart';

Firestore database = Firestore.instance;
var querySnapshot;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '検索画面',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '検索画面'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String inputValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                decoration: InputDecoration(hintText: '名前か耳標番号で検索'),
                onChanged: (value) {
                  setState(() {
                    inputValue = value;
                  });
                },
              ),
            ),
            Expanded(
              child: _buildBody(context, inputValue),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AddScreen();
              },
            ),
          );
        },
      ),
    );
  }
}

Widget _buildBody(BuildContext context, String inputValue) {
  return StreamBuilder(
    stream: database
        .collection('cows')
        .where("cowNames", arrayContains: inputValue)
        .snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();
//      if (snapshot.data.length == 0) print('aaa');
      try {
        snapshot.data.documents[0]['null'];
      } catch (e) {
        if (inputValue == '') {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.search,
                size: 200.0,
                color: Colors.grey,
              ),
              Text(
                '検索窓に入力してください。',
                style: TextStyle(fontSize: 20.0),
              ),
            ],
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.search,
                size: 200.0,
                color: Colors.grey,
              ),
              Text(
                '「$inputValue」に該当する結果はありません。',
                style: TextStyle(fontSize: 20.0),
              ),
            ],
          );
        }

        return Text('null');
      }

      return _buildList(context, snapshot.data.documents);
    },
  );
}

Widget _buildList(BuildContext context, List snapshot) {
  return ListView(
    padding: EdgeInsets.only(top: 20.0),
    children: snapshot
        .map(
          (data) => _buildListItem(context, data),
        )
        .toList(),
  );
}

Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  final cow = Cow.fromSnapshot(data);

  return Card(
    child: ListTile(
      onTap: () {},
      title: Text(
        cow.name.toString(),
      ),
      subtitle: Text(
        cow.number.toString(),
      ),
    ),
  );
}

Future getQuerySnap(name) async {
  querySnapshot = await database
      .collection('cows')
      .where("cowNames", arrayContains: name)
      .getDocuments();
}
