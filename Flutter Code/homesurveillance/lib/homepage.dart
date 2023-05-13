import 'dart:async';
import 'package:flutter/material.dart';
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
    try {
      final response = await http.get(Uri.parse('http://192.168.1.11'));
      if (response.statusCode == 200) {
        setState(() {
          isCamConnected = true;
        });
      } else {
        setState(() {
          isCamConnected = false;
        });
      }
    } catch (e) {
      setState(() {
        isCamConnected = false;
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
                            : "Connecting...",
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
                sendFlashData(0);
              } else {
                sendFlashData(255);
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
                        controllerFeed(1);
                      },
                      onTapUp: (_) {
                        controllerFeed(3);
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
                        controllerFeed(5);
                      },
                      onTapUp: (_) {
                        controllerFeed(3);
                      },
                      child: const Icon(
                        Icons.arrow_downward,
                        size: 35,
                      ),
                    )
                  ]),
            ),
          ),
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
                            controllerFeed(2);
                          },
                          onTapUp: (_) {
                            controllerFeed(3);
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            size: 35,
                          ),
                        ),
                        GestureDetector(
                          onTapDown: (_) {
                            controllerFeed(4);
                          },
                          onTapUp: (_) {
                            controllerFeed(3);
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
          ? Lottie.asset("assets/lottie/cctv.json", repeat: true, animate: true)
          : const Mjpeg(
              isLive: true,
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.fill,
              timeout: Duration(seconds: 1000),
              stream: "http://192.168.1.11:81/stream"),
    );
  }

  void sendFlashData(int value) async {
    print("dd");
    try {
      var response = await http
          .get(Uri.parse('http://192.168.1.11/control?var=flash&val=$value'));
      if (response.statusCode == 200) {
        // Request successful
        print('Flash Status Changed');
      } else {
        // Request failed
        print('Failed to send request');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  void controllerFeed(int data) async {
    try {
      var response = await http
          .get(Uri.parse('http://192.168.1.11/control?var=car&val=$data'));
      if (response.statusCode == 200) {
        // Request successful
        print('Bot Movement Success');
      } else {
        // Request failed
        print('Failed to send request');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }
}
