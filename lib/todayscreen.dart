import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';

class TodayScren extends StatefulWidget {
  const TodayScren({Key? key}) : super(key: key);

  @override
  State<TodayScren> createState() => _TodayScrenState();
}

class _TodayScrenState extends State<TodayScren> {
  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = Color(0xffeef444c);

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(children: [
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
                child: Text('Employee',
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
                              Text('09:30',
                                  style: TextStyle(
                                      fontSize: screenWidth / 18,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )),
                        Expanded(
                            child: Container(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                              Text('Check In',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: screenWidth / 20)),
                              Text('15:30',
                                  style: TextStyle(
                                      fontSize: screenWidth / 18,
                                      fontWeight: FontWeight.bold)),
                            ])))
                      ])),
              Container(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                      text: TextSpan(
                          text: '11',
                          style: TextStyle(
                            color: primary,
                            fontSize: screenWidth / 18,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                        TextSpan(
                            text: 'Jan 2022',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: screenWidth / 20))
                      ]))),
              Container(
                  alignment: Alignment.centerLeft,
                  child: Text('12:00:01',
                      style: TextStyle(
                          color: Colors.black54, fontSize: screenWidth / 20))),
              
              Container(
                margin: EdgeInsets.only(top: 24),
                child: Builder(builder: (context) {
                  final GlobalKey<SlideActionState>
                  key = GlobalKey();

                  return SlideAction(
                    text: 'Slide to Check out',
                     textStyle: TextStyle(
                      color: Colors.black54, fontSize: screenWidth / 20),

                      outerColor: Colors.white,
                      innerColor: primary,
                      key: key,
                      onSubmit: () {
                        key.currentState!.reset();

                      }
                    );
                }),
              )
            ]
            )
            )
            );
  }
}
