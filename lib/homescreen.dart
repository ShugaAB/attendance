import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyattendance/calenderscreen.dart';
import 'package:companyattendance/profilescreen.dart';
import 'package:companyattendance/todayscreen.dart';
import 'package:companyattendance/user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  String id = '';

  Color primary = Color(0xffeef444c);

  int currentIndex = 1;

  List<IconData> navigationIcons = [
    FontAwesomeIcons.calendarAlt,
    FontAwesomeIcons.check,
    FontAwesomeIcons.user,
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getId();
  }

  void getId() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('Employee')
        .where('id', isEqualTo: User.employeeId)
        .get();

    setState(() {
      User.id = snap.docs[0].id;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: IndexedStack(index: currentIndex, children: [
         new CalendarScreen(),
          new TodayScren(),
         new ProfileScreen(),
        ]),
        bottomNavigationBar: Container(
            height: 70,
            margin: EdgeInsets.only(
              left: 12,
              right: 12,
              bottom: 24,
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(40)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 18,
                    offset: Offset(2, 2),
                  )
                ]),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(40)),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0;
                          i < navigationIcons.length;
                          i++) ...<Expanded>{
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            setState(() {
                              currentIndex = 1;
                            });
                          },
                          child: Container(
                            height: screenHeight,
                            width: screenWidth,
                            color: Colors.white,
                            child: Center(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      navigationIcons[i],
                                      color: 1 == currentIndex
                                          ? primary
                                          : Colors.black54,
                                      size: 1 == currentIndex ? 30 : 26,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 6),
                                      height: 3,
                                      width: 22,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(40)),
                                        color: primary,
                                      ),
                                    ),
                                    SizedBox(),
                                  ]),
                            ),
                          ),
                        ))
                      }
                    ]))));
  }
}
