import 'package:cloud_firestore/cloud_firestore.dart';

class Cow {
  final String name;
  final String number;
  final cowNames;
  final DocumentReference reference;

  Cow.fromMap(Map map, {this.reference})
      : assert(map['name'] != null),
        assert(map['number'] != null),
        assert(map['cowNames'] != null),
        name = map['name'],
        number = map['number'],
        cowNames = map['cowNames'];

  Cow.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
