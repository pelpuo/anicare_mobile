import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:anicare/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:audioplayers/audioplayers.dart';

class CommPage extends StatefulWidget {
  final BluetoothDevice server;

  const CommPage({required this.server});

  @override
  _CommPage createState() => new _CommPage();
}

class _CommPage extends State<CommPage> {
  static final clientID = 0;
  BluetoothConnection? connection;

  final TextEditingController textEditingController =
      new TextEditingController();

  bool isConnecting = true;
  bool get isConnected => connection?.isConnected ?? false;

  bool isDisconnecting = false;

  @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection?.input?.listen(_onDataReceived).onDone(() {
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  @override
  void dispose() {
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }

    super.dispose();
  }

  TextStyle titleStyle = const TextStyle(color: Color(0xff349EB5));
  Color distanceColor = AppColors.lightBlue;
  Color circleColor = const Color(0xffffffff);
  Color promptTextColor = const Color(0xff349EB5);

  String pulseMessage = "0";
  String tempMessage = "0";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        foregroundColor: const Color(0xff0367A5),
        elevation: 0,
        // title: const Text("Bluetooth Dashboard"),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Device Monitor",
                style: TextStyle(
                    color: AppColors.lightBlue,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Status:",
                          style: TextStyle(color: AppColors.lightBlue),
                        )),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      isConnecting
                          ? 'Connecting...'
                          : isConnected
                              ? 'Device Connected'
                              : 'Connection lost',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 18.0,
                          color: isConnecting
                              ? AppColors.textGrey
                              : isConnected
                                  ? AppColors.lightBlue
                                  : AppColors.red),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        color: circleColor,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "pulse:",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.red,
                                      height: 0.5,
                                      fontWeight: FontWeight.normal),
                                ),
                                Image.asset(
                                  "assets/pulse.png",
                                  height: 24,
                                )
                              ]),
                          const SizedBox(
                            height: 56,
                          ),
                          Text(pulseMessage,
                              style: TextStyle(
                                  fontSize: 48,
                                  color: distanceColor,
                                  height: 1,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 18),
                          const Text(
                            "bpm",
                            style: TextStyle(
                                fontSize: 24,
                                color: AppColors.red,
                                height: 0.5,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 36,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        color: circleColor,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "temperature:",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.red,
                                      height: 0.5,
                                      fontWeight: FontWeight.normal),
                                ),
                                Image.asset(
                                  "assets/temp.png",
                                  height: 24,
                                )
                              ]),
                          const SizedBox(
                            height: 54,
                          ),
                          Text(tempMessage,
                              style: TextStyle(
                                  fontSize: 48,
                                  color: distanceColor,
                                  height: 1,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 18),
                          const Text(
                            "°C",
                            style: TextStyle(
                                fontSize: 24,
                                color: AppColors.red,
                                height: 0.5,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 36,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                padding: const EdgeInsets.all(12),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Device name:",
                          style: TextStyle(color: AppColors.lightBlue),
                        )),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      widget.server.name!,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.lightBlue),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
              // Row(
              //   children: <Widget>[
              //     // Flexible(child:
              //     Expanded(
              //       child: Container(
              //         // color: Color(0xffffffff),
              //         padding: EdgeInsets.symmetric(vertical: 18),
              //         margin: const EdgeInsets.only(left: 16.0),
              //         child: Text(
              //           isConnecting
              //               ? 'Connecting...'
              //               : isConnected
              //                   ? 'Device Connected'
              //                   : 'Connection lost',
              //           textAlign: TextAlign.center,
              //           style: TextStyle(
              //               fontSize: 16.0,
              //               color: isConnected
              //                   ? Color(0xff349EB5)
              //                   : Color(0xffd2d2d2)),
              //         ),
              //       ),
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);

    print("11111111111111111111111111");
    print(dataString);
    setState(() {
      pulseMessage = double.parse(dataString.split(",")[0]).round().toString();
      tempMessage = double.parse(dataString.split(",")[1]).round().toString();
    });
  }

  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.length > 0) {
      try {
        connection?.output.add(Uint8List.fromList(utf8.encode(text + "\r\n")));
        await connection?.output.allSent;
      } catch (e) {
        // Ignore error, but notify state
        print(e.toString());
      }
    }
  }
}
