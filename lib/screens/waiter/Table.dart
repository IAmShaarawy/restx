import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restx/screens/Constants.dart';
import 'package:restx/screens/Loading.dart';

class Table extends StatefulWidget {
  @override
  _TableState createState() => _TableState();
}

class _TableState extends State<Table> {
  @override
  Widget build(BuildContext context) {
    String tableId = (ModalRoute.of(context).settings.arguments as Map)["id"];
    int number =
        (ModalRoute.of(context).settings.arguments as Map)["table_number"];
    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('orders')
            .document(tableId)
            .snapshots(),
        builder: (context, ss) {
          return !ss.hasData
              ? Loading()
              : Scaffold(
                  appBar: AppBar(
                    title: Text("Table # $number"),
                  ),
                  body: GridView.count(
                    crossAxisCount: 2,
                    children: (ss.data.data["plates"] as List).map((p) {
                      return Card(
                        child: StreamBuilder<DocumentSnapshot>(
                            stream: Firestore.instance
                                .collection("menu")
                                .document(p.toString())
                                .snapshots(),
                            builder: (context, ss1) {
                              return !ss1.hasData
                                  ? Loading()
                                  : Container(
                                      padding: EdgeInsets.all(4.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image.network(
                                            ss1.data.data["img"],
                                            width: 150,
                                          ),
                                          Text(ss1.data.data["name"],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .title),
                                        ],
                                      ),
                                    );
                            }),
                      );
                    }).toList(),
                  ),
                  floatingActionButton: FloatingActionButton.extended(
                    onPressed: !decideFABAbility(ss.data.data["state"])
                        ? null
                        : () => onFAPClick(
                            ss.data.data["state"], ss.data.documentID),
                    elevation: decideFABAbility(
                        ss.data.data["state"])
                        ? null
                        : 0,
                    label: Text(getFAPLabel(ss.data.data["state"])),
                    icon: Icon(
                      getFAPIcon(ss.data.data["state"]),
                    ),
                    backgroundColor: getFAPColor(ss.data.data["state"]),
                  ),
                );
        });
  }

  bool decideFABAbility(String orderState) {
    return orderState == UNDER_PICK ||
        orderState == UNDER_PREPARATION ||
        orderState == WAITING_CHECK_OUT;
  }

  void onFAPClick(String orderState, String orderId) async {
    var orderRef = Firestore.instance.collection("orders").document(orderId);
    if (orderState == UNDER_SELECTION) {
      await orderRef.setData({"state": UNDER_PICK}, merge: true);
    }

    if (orderState == SERVED) {}
  }

  String getFAPLabel(String orderState) {
    if (orderState == UNDER_SELECTION) return "Wating Clint";

    if (orderState == UNDER_PICK) return "Pick Now";

    if (orderState == UNDER_PREPARATION) return "Serve";

    if (orderState == SERVED) return "Waiting Checkout";

    if (orderState == WAITING_CHECK_OUT) return "Checkout Clint";

    return "Happy Client";
  }

  IconData getFAPIcon(String orderState) {
    if (orderState == UNDER_SELECTION) return Icons.access_time;

    if (orderState == UNDER_PICK) return Icons.airplanemode_active;

    if (orderState == UNDER_PREPARATION) return Icons.send;

    if (orderState == SERVED) return Icons.access_time;
    if (orderState == WAITING_CHECK_OUT) return Icons.attach_money;

    return Icons.local_florist;
  }

  Color getFAPColor(String orderState) {
    if (orderState == UNDER_SELECTION) return Colors.amberAccent;

    if (orderState == UNDER_PICK) return Colors.blueAccent;

    if (orderState == UNDER_PREPARATION) return Colors.redAccent;

    if (orderState == SERVED) return Colors.amberAccent;

    if (orderState == WAITING_CHECK_OUT) return Colors.black87;

    return Colors.greenAccent;
  }
}
