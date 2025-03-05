import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';

class Box extends StatefulWidget {
  final String deviceName;
  final String deviceImage;
  final String firebasePath; // Path to device in Firebase

  const Box({
    super.key,
    required this.deviceName,
    required this.deviceImage,
    required this.firebasePath,
  });

  @override
  State<Box> createState() => _BoxState();
}

class _BoxState extends State<Box> {
  late DatabaseReference deviceRef;
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    deviceRef = FirebaseDatabase.instance.ref(widget.firebasePath);
    _fetchDeviceState();
  }

  void _fetchDeviceState() {
    deviceRef.child("state").onValue.listen((event) {
      final state = event.snapshot.value as bool? ?? false;
      setState(() {
        isActive = state;
      });
    });
  }

  void _toggleDeviceState() async {
    if (widget.deviceName != "Water Level ") { // Exclude Water Level
      final newState = !isActive;
      await deviceRef.child("state").set(newState);
      setState(() {
        isActive = newState;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            color: isActive
                ? const Color.fromARGB(255, 213, 223, 247)
                : const Color.fromARGB(248, 231, 233, 234),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                widget.deviceImage,
                height: 60,
                color: const Color.fromARGB(255, 62, 97, 192),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.deviceName,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 24, 27, 110),
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (widget.deviceName != "Water Level ") // Exclude Water Level
                      Transform.rotate(
                        angle: pi / 2,
                        child: Switch(
                          activeColor: const Color.fromARGB(255, 45, 65, 216),
                          value: isActive,
                          onChanged: (value) => _toggleDeviceState(),
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
