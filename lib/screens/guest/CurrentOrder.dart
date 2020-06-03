import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restx/screens/Constants.dart';
import 'package:restx/screens/Loading.dart';

class CurrentOrder extends StatefulWidget {
  @override
  _CurrentOrderState createState() => _CurrentOrderState();
}

class _CurrentOrderState extends State<CurrentOrder> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
        // find current user
        stream: FirebaseAuth.instance.currentUser().asStream(),
        builder: (context, userSS) {
          return !userSS.hasData
              ? Loading()
              : StreamBuilder<QuerySnapshot>(
                  // find current table
                  stream: Firestore.instance
                      .collection('tables')
                      .where("current_user", isEqualTo: userSS.data.uid)
                      .limit(1)
                      .snapshots(),
                  builder: (context, tableSS) {
                    return !tableSS.hasData ||
                            tableSS.data.documents.length == 0
                        ? Loading()
                        : StreamBuilder<DocumentSnapshot>(
                            // find current order
                            stream: Firestore.instance
                                .collection('orders')
                                .document(tableSS
                                    .data.documents.first.data["order_id"])
                                .snapshots(),
                            builder: (context, orderSS) {
                              return !orderSS.hasData
                                  ? Loading()
                                  : Scaffold(
                                      appBar: AppBar(
                                        title: Text(
                                            "Table #${tableSS.data.documents.first.data["number"]}"),
                                        actions: <Widget>[
                                          IconButton(
                                            icon: Icon(
                                              Icons.swap_calls,
                                              color: Colors.white,
                                            ),
                                            tooltip: "Table",
                                            onPressed: _onChangeTable,
                                          ),
                                        ],
                                      ),
                                      body: GridView.count(
                                        crossAxisCount: 2,
                                        children: groupPlates((orderSS
                                                .data.data["plates"] as List))
                                            .entries
                                            .map((p) {
                                          onOrderStateChange(
                                              orderSS.data.data["state"]);
                                          return Card(
                                            child:
                                                StreamBuilder<DocumentSnapshot>(
                                                    stream: Firestore.instance
                                                        .collection("menu")
                                                        .document(
                                                            p.key.toString())
                                                        .snapshots(),
                                                    builder: (context, ss1) {
                                                      return !ss1.hasData
                                                          ? Loading()
                                                          : Container(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: <
                                                                    Widget>[
                                                                  Expanded(
                                                                    child: Image
                                                                        .network(
                                                                      ss1.data.data[
                                                                          "img"],
                                                                      fit: BoxFit
                                                                          .fitWidth,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 8,
                                                                  ),
                                                                  Text(
                                                                      "${ss1.data.data["name"]}",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .title),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: <
                                                                        Widget>[
                                                                      IconButton(
                                                                        icon:
                                                                            Icon(
                                                                          Icons
                                                                              .indeterminate_check_box,
                                                                          color:
                                                                              Colors.redAccent,
                                                                          size:
                                                                              36,
                                                                        ),
                                                                        onPressed: !decidePlusAndMinusAbility(orderSS.data.data["state"])
                                                                            ? null
                                                                            : () => changePlateCount(
                                                                                orderSS.data.documentID,
                                                                                p.key,
                                                                                false),
                                                                      ),
                                                                      Text(
                                                                        "#${p.value}",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.blueAccent),
                                                                      ),
                                                                      IconButton(
                                                                        icon:
                                                                            Icon(
                                                                          Icons
                                                                              .add_box,
                                                                          color:
                                                                              Colors.greenAccent,
                                                                          size:
                                                                              36,
                                                                        ),
                                                                        onPressed: !decidePlusAndMinusAbility(orderSS.data.data["state"])
                                                                            ? null
                                                                            : () => changePlateCount(
                                                                                orderSS.data.documentID,
                                                                                p.key,
                                                                                true),
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                    }),
                                          );
                                        }).toList(),
                                      ),
                                      floatingActionButton:
                                          FloatingActionButton.extended(
                                        onPressed: !decideFABAbility(
                                                orderSS.data.data["state"])
                                            ? null
                                            : () => onFAPClick(
                                                orderSS.data.data["state"],
                                                orderSS.data.documentID),
                                        elevation: decideFABAbility(
                                                orderSS.data.data["state"])
                                            ? null
                                            : 0,
                                        label: Text(getFAPLabel(
                                            orderSS.data.data["state"])),
                                        icon: Icon(getFAPIcon(
                                            orderSS.data.data["state"])),
                                        backgroundColor: getFAPColor(
                                            orderSS.data.data["state"]),
                                      ),
                                    );
                            });
                  });
        });
  }

  bool decidePlusAndMinusAbility(String orderState) {
    return orderState == UNDER_SELECTION;
  }

  bool decideFABAbility(String orderState) {
    return orderState == UNDER_SELECTION ||
        orderState == SERVED ||
        orderState == CHECKED_OUT;
  }

  void onFAPClick(String orderState, String orderId) async {
    var orderRef = Firestore.instance.collection("orders").document(orderId);
    if (orderState == UNDER_SELECTION) {
      await orderRef.setData({"state": UNDER_PICK}, merge: true);
    }

    if (orderState == SERVED) {
      await orderRef.setData({"state": WAITING_CHECK_OUT}, merge: true);
    }

    if (orderState == CHECKED_OUT) {
      await orderRef.setData({"state": ARCHIVED}, merge: true);
    }
  }

  String getFAPLabel(String orderState) {
    if (orderState == UNDER_SELECTION) return "Prepare";

    if (orderState == UNDER_PICK) return "Waiting Waiter";

    if (orderState == UNDER_PREPARATION) return "Cooking";

    if (orderState == SERVED || orderState == WAITING_CHECK_OUT)
      return "Checkout";

    if (orderState == CHECKED_OUT) return "Thank you";

    return "Archived";
  }

  IconData getFAPIcon(String orderState) {
    if (orderState == UNDER_SELECTION) return Icons.send;

    if (orderState == UNDER_PICK) return Icons.access_time;

    if (orderState == UNDER_PREPARATION) return Icons.access_time;

    if (orderState == SERVED) return Icons.attach_money;
    if (orderState == WAITING_CHECK_OUT) return Icons.access_time;

    if (orderState == CHECKED_OUT) return Icons.local_florist;
    return Icons.archive;
  }

  Color getFAPColor(String orderState) {
    if (orderState == UNDER_SELECTION) return Colors.blue;

    if (orderState == UNDER_PICK) return Colors.amberAccent;

    if (orderState == UNDER_PREPARATION) return Colors.amberAccent;

    if (orderState == SERVED || orderState == WAITING_CHECK_OUT)
      return Colors.black87;

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

  changePlateCount(String orderId, String plateId, bool increase) async {
    var orderRef = Firestore.instance.collection("orders").document(orderId);
    List plates = (await orderRef.get()).data["plates"];
    if (increase) {
      plates.add(plateId);
    } else {
      plates.remove(plateId);
    }
    await orderRef.setData({"plates": plates}, merge: true);
  }

  void _onChangeTable() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 200,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )),
              child: _buildChangeTableBottomSheet(),
            ),
          );
        },
        useRootNavigator: true);
  }

  Widget _buildChangeTableBottomSheet() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              splashColor: Colors.teal,
              iconSize: 100,
              icon: Icon(
                Icons.swap_calls,
                color: Colors.teal,
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, ROUTE_QR);
              },
            ),
            Text(
              "Change Table",
              style: TextStyle(color: Colors.teal),
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              splashColor: Colors.redAccent,
              iconSize: 100,
              icon: Icon(
                Icons.power_settings_new,
                color: Colors.redAccent,
              ),
              onPressed: () async {
                await clearTable();
                await Navigator.pushNamedAndRemoveUntil(
                    context, ROUTE_QR, ModalRoute.withName("/"));
              },
            ),
            Text(
              "Leave Table",
              style: TextStyle(color: Colors.redAccent),
            )
          ],
        ),
      ],
    );
  }

  clearTable() async {
    var userId = (await FirebaseAuth.instance.currentUser()).uid;
    var tablesRef = Firestore.instance.collection("tables");
    var tableId = (await tablesRef
            .where("current_user", isEqualTo: userId)
            .limit(1)
            .getDocuments())
        .documents[0]
        .documentID;
    await tablesRef
        .document(tableId)
        .setData({"current_user": null, "order_id": null}, merge: true);
  }

  onOrderStateChange(String state) async {
    if (state == ARCHIVED) {
      await clearTable();
      await Navigator.pushNamedAndRemoveUntil(
          context, ROUTE_QR, ModalRoute.withName("/"));
    }
  }
}
