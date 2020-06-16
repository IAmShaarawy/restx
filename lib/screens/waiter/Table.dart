import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restx/screens/Constants.dart';
import 'package:restx/screens/Loading.dart';
import 'package:restx/screens/guest/UserFeedback.dart';
import 'package:restx/screens/waiter/WaiterFeedback.dart';

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
          onStateChange(ss.data.data["state"], ss.data.data["feedback"]);
          return !ss.hasData
              ? Loading()
              : Scaffold(
                  appBar: AppBar(
                    title: Text("Table # $number"),
                  ),
                  body: GridView.count(
                    crossAxisCount: 2,
                    children: groupPlates((ss.data.data["plates"] as List))
                        .entries
                        .map((p) {
                      return Card(
                        child: StreamBuilder<DocumentSnapshot>(
                            stream: Firestore.instance
                                .collection("menu")
                                .document(p.key)
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
                                          Expanded(
                                            child: Image.network(
                                              ss1.data.data["img"],
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(ss1.data.data["name"],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .title),
                                          Text("#${p.value}#",
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
                        : () => onFAPClick(ss.data.data["state"],
                            ss.data.documentID, ss.data.data["feedback"]),
                    elevation:
                        decideFABAbility(ss.data.data["state"]) ? null : 0,
                    label: Text(getFAPLabel(ss.data.data["state"])),
                    icon: Icon(
                      getFAPIcon(ss.data.data["state"]),
                    ),
                    backgroundColor: getFAPColor(ss.data.data["state"]),
                  ),
                );
        });
  }

  void onStateChange(String orderState, Map data) {}

  bool decideFABAbility(String orderState) {
    return orderState == UNDER_PICK ||
        orderState == WAITING_CONFIRM ||
        orderState == UNDER_PREPARATION ||
        orderState == WAITING_CHECK_OUT ||
        orderState == CHECKED_OUT ||
        orderState == ARCHIVED;
  }

  void onFAPClick(String orderState, String orderId, Map data) async {
    var orderRef = Firestore.instance.collection("orders").document(orderId);
    if (orderState == UNDER_PICK) {
      var user = await FirebaseAuth.instance.currentUser();
      await orderRef
          .setData({"state": WAITING_CONFIRM, "waiter": user.uid}, merge: true);
    }

    if (orderState == WAITING_CONFIRM) {
      await orderRef.setData({"state": UNDER_PREPARATION}, merge: true);
    }

    if (orderState == UNDER_PREPARATION) {
      await orderRef.setData({"state": SERVED}, merge: true);
    }

    if (orderState == WAITING_CHECK_OUT) {
      await orderRef.setData({"state": CHECKED_OUT}, merge: true);
    }

    if (orderState == CHECKED_OUT) {
      await orderRef.setData({"state": ARCHIVED}, merge: true);
    }

    if (orderState == ARCHIVED) {
      showDialog(
        context: context,
        builder: (context) => Dialog(child: WaiterFeedback(data)),
      );
    }
  }

  String getFAPLabel(String orderState) {
    if (orderState == UNDER_SELECTION) return "Wating Clint";

    if (orderState == UNDER_PICK) return "Pick Now";

    if (orderState == WAITING_CONFIRM) return "Confirm";

    if (orderState == UNDER_PREPARATION) return "Serve";

    if (orderState == SERVED) return "Waiting Checkout";

    if (orderState == WAITING_CHECK_OUT) return "Checkout Clint";

    if (orderState == CHECKED_OUT) return "Happy Client";

    return "Feedback";
  }

  IconData getFAPIcon(String orderState) {
    if (orderState == UNDER_SELECTION) return Icons.access_time;

    if (orderState == UNDER_PICK) return Icons.airplanemode_active;

    if (orderState == WAITING_CONFIRM) return Icons.check;

    if (orderState == UNDER_PREPARATION) return Icons.send;

    if (orderState == SERVED) return Icons.access_time;
    if (orderState == WAITING_CHECK_OUT) return Icons.attach_money;
    if (orderState == CHECKED_OUT) return Icons.local_florist;
    return Icons.archive;
  }

  Color getFAPColor(String orderState) {
    if (orderState == UNDER_SELECTION) return Colors.amberAccent;

    if (orderState == UNDER_PICK) return Colors.blueAccent;

    if (orderState == WAITING_CONFIRM) return Colors.teal;

    if (orderState == UNDER_PREPARATION) return Colors.redAccent;

    if (orderState == SERVED) return Colors.amberAccent;

    if (orderState == WAITING_CHECK_OUT) return Colors.black87;

    if (orderState == CHECKED_OUT) return Colors.greenAccent;

    return Colors.blueGrey;
  }

  Map<String, int> groupPlates(List plates) {
    Map<String, int> groupedPlates = {};
    plates.sort((e1, e2) {
      return e1.compareTo(e2);
    });
    plates.forEach((e) {
      groupedPlates.update(e, (v) {
        return v + 1;
      }, ifAbsent: () {
        return 1;
      });
    });
    return groupedPlates;
  }
}
