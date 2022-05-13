import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyattendance/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';

class TodayScren extends StatefulWidget {
  const TodayScren({Key? key}) : super(key: key);

  @override
  State<TodayScren> createState() => _TodayScrenState();
}

class _TodayScrenState extends State<TodayScren> {
  double screenHeight = 0;
  double screenWidth = 0;

  String checkIn = '--/--';
  String checkOut = '--/--';

  Color primary = Color(0xffeef444c);

  @override
  void initState() {
    super.initState();
    _getRecord();
  }

  void _getRecord() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('Employee')
          .where('id', isEqualTo: User.employeeId)
          .get();

      DocumentSnapshot snap2 = await FirebaseFirestore.instance
          .collection('Employee')
          .doc(snap.docs[0].id)
          .collection('Record')
          .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
          .get();

      setState(() {
        checkIn = snap2['checkIn'];
        checkOut = snap2['checkOut'];
      });
    } catch (e) {
      setState(() {
        checkIn = '--/--';
        checkOut = '--/--';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 32),
                  child: Text('Welcome',
                      style: TextStyle(
                          color: Colors.black54, fontSize: screenWidth / 20)),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 32),
                  child: Text('Employee' + User.employeeId,
                      style: TextStyle(
                          fontSize: screenWidth / 18,
                          fontWeight: FontWeight.bold)),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 32),
                  child: Text("Today's Status",
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: screenWidth / 18,
                          fontWeight: FontWeight.bold)),
                ),
                Container(
                    margin: EdgeInsets.only(top: 12, bottom: 32),
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(2, 2),
                        )
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Check In',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: screenWidth / 20)),
                                Text(checkIn,
                                    style: TextStyle(
                                        fontSize: screenWidth / 18,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          )),
                          Expanded(
                              child: Container(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                Text('Check Out',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: screenWidth / 20)),
                                Text(checkOut,
                                    style: TextStyle(
                                        fontSize: screenWidth / 18,
                                        fontWeight: FontWeight.bold)),
                              ])))
                        ])),
                Container(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                        text: TextSpan(
                            text: DateTime.now().day.toString(),
                            style: TextStyle(
                              color: primary,
                              fontSize: screenWidth / 18,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                          TextSpan(
                              text: DateFormat(' MMMM YYYY')
                                  .format(DateTime.now()),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: screenWidth / 20))
                        ]))),
                StreamBuilder(
                    stream: Stream.periodic(Duration(seconds: 1)),
                    builder: (context, snapshot) {
                      return Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              DateFormat('hh:mm:ss a').format(DateTime.now()),
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: screenWidth / 20)));
                    }),
                checkOut == '--/--'
                    ? Container(
                        margin: EdgeInsets.only(top: 24),
                        child: Builder(builder: (context) {
                          final GlobalKey<SlideActionState> key = GlobalKey();

                          return SlideAction(
                              text: checkIn == '--/--'
                                  ? 'Slide to Check In'
                                  : "Slide to Check Out",
                              textStyle: TextStyle(
                                  color: Colors.black54,
                                  fontSize: screenWidth / 20),
                              outerColor: Colors.white,
                              innerColor: primary,
                              key: key,
                              onSubmit: () async {
                                QuerySnapshot snap = await FirebaseFirestore
                                    .instance
                                    .collection('Employee')
                                    .where('id', isEqualTo: User.employeeId)
                                    .get();

                                DocumentSnapshot snap2 = await FirebaseFirestore
                                    .instance
                                    .collection('Employee')
                                    .doc(snap.docs[0].id)
                                    .collection('Record')
                                    .doc(DateFormat('dd MMMM yyyy')
                                        .format(DateTime.now()))
                                    .get();

                                try {
                                  String checkIn = snap2['checkIn'];

                                  setState(() {
                                    checkOut = DateFormat('hh:mm')
                                        .format(DateTime.now());
                                  });

                                  await FirebaseFirestore.instance
                                      .collection('Employee')
                                      .doc(snap.docs[0].id)
                                      .collection('Record')
                                      .doc(DateFormat('dd MMMM yyyy')
                                          .format(DateTime.now()))
                                      .update({
                                        'date' :Timestamp.now(),
                                    'checkIn': checkIn,
                                    'checkOut': DateFormat('hh:mm')
                                        .format(DateTime.now()),
                                  });

                                  
                                } catch (e) {
                                  setState(() {
                                    checkIn = DateFormat('hh:mm')
                                        .format(DateTime.now());
                                  });
                                  await FirebaseFirestore.instance
                                      .collection('Employee')
                                      .doc(snap.docs[0].id)
                                      .collection('Record')
                                      .doc(DateFormat('dd MMMM yyyy')
                                          .format(DateTime.now()))
                                      .set({
                                        'date' :Timestamp.now(),                                    'checkIn': DateFormat('hh:mm')
                                        .format(DateTime.now()),
                                    'checkOut': '--/--',
                                  });
                                }

                                key.currentState!.reset();
                              });
                        }),
                      )
                    : Container(
                        margin: EdgeInsets.only(top: 32),
                        child: Text(
                          'You have completed this day!',
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: screenWidth / 20),
                        ))
              ],
            )));
  }
}
