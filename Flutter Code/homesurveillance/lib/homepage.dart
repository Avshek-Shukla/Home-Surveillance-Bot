import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homesurveillance/botfeeds.dart';
import 'package:lottie/lottie.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_mjpeg/flutter_mjpeg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool flashStatus = false;
  bool isCamConnected = false;
  double speed = 0;
  String camID = "http://192.168.1.5";
  String connectionStatus = "Not Connected";
  TextEditingController camIDController = TextEditingController();
  late StreamSubscription subscription = Connectivity()
      .onConnectivityChanged
      .listen((ConnectivityResult result) async {
    await checkCamera();
    setState(() {
      connectivityResult = result;
    });
  });

  ConnectivityResult connectivityResult = ConnectivityResult.none;
  @override
  void initState() {
    checkConnectivity();
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Future checkConnectivity() async {
    connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {});
    if (connectivityResult != ConnectivityResult.none) {
      await checkCamera();
    }
  }

  Future checkCamera() async {
    setState(() {
      connectionStatus = "Connecting...";
    });
    try {
      final response = await http.get(Uri.parse(camID));
      if (response.statusCode == 200) {
        setState(() {
          isCamConnected = true;
        });
      } else {
        setState(() {
          isCamConnected = false;
          connectionStatus = "Failed";
        });
      }
    } catch (e) {
      setState(() {
        isCamConnected = false;
        connectionStatus = "Failed";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            videoFeed(),
            topBar(),
            controller(),
          ],
        ),
      ),
    );
  }

  Widget topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 20,
            child: Row(
              children: [
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                      color: !isCamConnected ? Colors.red : Colors.green,
                      borderRadius: BorderRadius.circular(20)),
                ),
                const SizedBox(
                  width: 5,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    connectivityResult == ConnectivityResult.none
                        ? "No Internet"
                        : isCamConnected
                            ? "Connected"
                            : connectionStatus,
                    style:
                        const TextStyle(fontSize: 12, fontFamily: "Righteous"),
                  ),
                )
              ],
            ),
          ),
          const Text(
            "Home Surveillance Bot",
            style: TextStyle(fontSize: 24, fontFamily: "Righteous"),
          ),
          IconButton(
            icon: Icon(
              flashStatus ? Icons.flash_off : Icons.flash_on,
              size: 30,
            ),
            splashRadius: 25,
            onPressed: () {
              if (flashStatus) {
                sendFlashData(0, camID);
              } else {
                sendFlashData(255, camID);
              }
              setState(() {
                flashStatus = !flashStatus;
              });
            },
          )
        ],
      ),
    );
  }

  Widget controller() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                  color: Colors.black.withOpacity(0.1)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTapDown: (_) {
                        controllerFeed(1, camID);
                      },
                      onTapUp: (_) {
                        controllerFeed(3, camID);
                      },
                      child: const Icon(
                        Icons.arrow_upward,
                        size: 35,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {},
                          splashRadius: 27,
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 35,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          splashRadius: 27,
                          icon: const Icon(
                            Icons.arrow_forward,
                            size: 35,
                          ),
                        )
                      ],
                    ),
                    GestureDetector(
                      onTapDown: (_) {
                        controllerFeed(5, camID);
                      },
                      onTapUp: (_) {
                        controllerFeed(3, camID);
                      },
                      child: const Icon(
                        Icons.arrow_downward,
                        size: 35,
                      ),
                    )
                  ]),
            ),
          ),
          Container(
              height: 85,
              width: 400,
              child: CupertinoSlider(
                  value: speed,
                  min: 0,
                  max: 255,
                  activeColor: Colors.white,
                  onChanged: (changedVal) {
                    setState(() {
                      speed = changedVal;
                    });
                    changeSpeed(speed.toInt(), camID);
                  })),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                  color: Colors.black.withOpacity(0.1)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {},
                      splashRadius: 27,
                      icon: const Icon(
                        Icons.arrow_upward,
                        size: 35,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTapDown: (_) {
                            controllerFeed(2, camID);
                          },
                          onTapUp: (_) {
                            controllerFeed(3, camID);
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            size: 35,
                          ),
                        ),
                        GestureDetector(
                          onTapDown: (_) {
                            controllerFeed(4, camID);
                          },
                          onTapUp: (_) {
                            controllerFeed(3, camID);
                          },
                          child: const Icon(
                            Icons.arrow_forward,
                            size: 35,
                          ),
                        )
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      splashRadius: 27,
                      icon: const Icon(
                        Icons.arrow_downward,
                        size: 35,
                      ),
                    )
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget videoFeed() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.transparent,
      child: !isCamConnected
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset("assets/lottie/cctv.json",
                    repeat: true, animate: true),
                const SizedBox(
                  height: 5,
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context, builder: ((context) => fillIP()));
                  },
                  child: const Text(
                    "Connect",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Righteous",
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            )
          : Mjpeg(
              isLive: true,
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.fill,
              timeout: const Duration(seconds: 1000),
              stream: "$camID:81/stream"),
    );
  }

  Widget fillIP() {
    return AlertDialog(
      backgroundColor: Colors.white,
      titlePadding:
          const EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 20),
      contentPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
      actionsPadding: const EdgeInsets.only(right: 20, top: 30),
      insetPadding: EdgeInsets.zero,
      title: const Text(
        "Connect Bot",
      ),
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontFamily: "Righteous",
        color: Colors.black,
      ),
      content: SizedBox(
        width: 350,
        child: TextField(
          controller: camIDController,
          textAlignVertical: TextAlignVertical.center,
          textAlign: TextAlign.start,
          keyboardType: TextInputType.number,
          style: const TextStyle(
              color: Colors.black, fontSize: 16, fontFamily: "Righteous"),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            hintText: "192.168.1.11",
            hintStyle: const TextStyle(color: Colors.grey),
            fillColor: Colors.grey.withOpacity(0.2),
            filled: true,
            prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 8, right: 4),
              child: Text(
                "http://",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontFamily: "Righteous"),
              ),
            ),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(8.0),
            ),
            // prefixText: "http:// ",
            // prefixStyle: TextStyle(color: Colors.black),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text(
            "CANCEL",
            style: TextStyle(fontFamily: "Righteous", color: Colors.white),
          ),
        ),
        TextButton(
            onPressed: () async {
              if (camIDController.value.text.isNotEmpty) {
                setState(() {
                  camID = 'http://${camIDController.value.text}';
                  checkCamera();
                });
                Navigator.pop(context);
              } else {
                setState(() {
                  connectionStatus = "Wrong ID";
                });

                Navigator.pop(context);
              }
              camIDController.clear();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text(
              "CONNECT",
              style: TextStyle(fontFamily: "Righteous", color: Colors.white),
            ))
      ],
    );
  }
}
