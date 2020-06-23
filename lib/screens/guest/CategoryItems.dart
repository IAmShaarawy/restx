import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CategoryItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;


    return Scaffold(
      appBar: AppBar(
        title: Text(args["cat_name"]),
      ),
      body: formMenu(args["cat_id"]),
    );
  }

  Widget formMenu(String catId) => StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('menu')
          .where("cat", isEqualTo: catId)
          .snapshots(),
      builder: (context, snapshot) {
        return !snapshot.hasData || snapshot.data.documents.length == 0
            ? Center(
                child: Text("Doesn't have plates"),
              )
            : ListView(
                children: snapshot.data.documents.map((document) {
                print(document['name']);
                print(document['price']);
                return Card(
                  child: StreamBuilder<QuerySnapshot>(
                      stream:
                          document.reference.collection('items').snapshots(),
                      builder: (context, snapshot) {
                        return ListTile(
                          onTap: () async {
                            await updateOrderWithPlates(document.documentID);
                          },
                          title: Text(document['name']),
                          subtitle: Text("${document['price']} L.E"),
                          leading: SizedBox(
                              height: 100,
                              width: 100,
                              child: Image.network(document['img'])),
                        );
                      }),
                );
              }).toList());
      });
}

updateOrderWithPlates(String plateId) async {
  var orderId = await currentTableOrderId();
  var orderRef = Firestore.instance.collection("orders").document(orderId);
  var plates = (await orderRef.get()).data["plates"];
  plates.add(plateId);
  print(plates);
  await orderRef.setData({"plates": plates}, merge: true);
}

Future<String> currentTableOrderId() async {
  var userId = (await FirebaseAuth.instance.currentUser()).uid;
  var tablesRef = Firestore.instance.collection("tables");
  var table = (await tablesRef
          .where("current_user", isEqualTo: userId)
          .limit(1)
          .getDocuments())
      .documents[0];

  return table.data["order_id"];
}
