// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomeState();
// }

// class _HomeState extends State<HomePage> {
//   final DatabaseReference tempReference = FirebaseDatabase.instance.ref("TEMP");
//   final DatabaseReference humidityReference =
//       FirebaseDatabase.instance.ref("HUMIDITY");
//   int temperature = 0;
//   int humidity = 0;

//   final List<List<dynamic>> devices = [
//   ["Smart Light", "icons/light-bulb.png", true, "devices/smartLight"],
//   ["Smart Fan", "icons/fan.png", true, "devices/smartFan"],
//   ["Door State", "icons/door.png", false, "devices/doorState"],
//   ["Water Level ", "icons/water-level.png", false, "devices/waterLevel"],
// ];


//   @override
//   void initState() {
//     super.initState();
//     _fetchTempData();
//     _fetchHumidityData();
//   }

//   void _fetchTempData() {
//     tempReference.onValue.listen((event) {
//       final tempValue = event.snapshot.value as int;
//       setState(() {
//         temperature = tempValue;
//       });
//     });
//   }

//   void _fetchHumidityData() {
//     humidityReference.onValue.listen((event) {
//       final humidityValue = event.snapshot.value as int;
//       setState(() {
//         humidity = humidityValue;
//       });
//     });
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           color: Colors.white,
//           child: Column(
//             children: [
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'Hello!',
//                       style: TextStyle(
//                         color: Color.fromARGB(255, 70, 107, 242),
//                         fontSize: 35,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     InkWell(
//                       borderRadius: BorderRadius.circular(55),
//                       onTap: () {},
//                       child: Image.asset(
//                         'icons/menu.png',
//                         height: 45,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const Text(
//                 'Welcome to your Smart Home',
//                 style: TextStyle(
//                   color: Color.fromARGB(255, 1, 1, 17),
//                   fontSize: 20,
//                 ),
//               ),
//               ////////////////TEMP&HUMIDITY///////////////////////////////////////////
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.blue,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       padding: const EdgeInsets.all(8),
//                       width: 320,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           //////////////TEMP///////////////////////////
//                           Column(
//                             children: [
//                               const Icon(Icons.thermostat, color: Colors.white),
//                               const SizedBox(height: 4),
//                               const Text(
//                                 'Temperature',
//                                 style: TextStyle(
//                                     color: Colors.white, fontSize: 20),
//                               ),
//                               Text(
//                                 '$temperature°C',
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(width: 70),
//                           ////////////////HUMIDITY/////////////////////////////////////////
//                           Column(
//                             children: [
//                               const Icon(Icons.water_drop, color: Colors.white),
//                               const SizedBox(height: 4),
//                               const Text(
//                                 'Humidity',
//                                 style: TextStyle(
//                                     color: Colors.white, fontSize: 20),
//                               ),
//                               Text(
//                                 '$humidity%',
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 5),
//               /////////////////////DEVICES////////////////////////////////////
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 40),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     'Smart Devices',
//                     style: TextStyle(
//                       color: Color.fromARGB(255, 2, 8, 21),
//                       fontSize: 25,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: GridView.builder(
//                   padding: const EdgeInsets.all(10),
//                   itemCount: devices.length,
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     childAspectRatio: 1,
//                   ),
//                   itemBuilder: (context, index) {
//                     return Box(
//                       deviceName: devices[index][0],
//                       deviceImage: devices[index][1],
//                       firebasePath: devices[index][3], // Add the Firebase path
//                     );
//                 },

//                 ),
//               ),
              
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'dart:math';

// class Box extends StatefulWidget {
//   final String deviceName;
//   final String deviceImage;
//   final String firebasePath; // Path to device in Firebase

//   const Box({
//     super.key,
//     required this.deviceName,
//     required this.deviceImage,
//     required this.firebasePath,
//   });

//   @override
//   State<Box> createState() => _BoxState();
// }

// class _BoxState extends State<Box> {
//   late DatabaseReference deviceRef;
//   bool isActive = false;

//   @override
//   void initState() {
//     super.initState();
//     deviceRef = FirebaseDatabase.instance.ref(widget.firebasePath);
//     _fetchDeviceState();
//   }

//   void _fetchDeviceState() {
//     deviceRef.child("state").onValue.listen((event) {
//       final state = event.snapshot.value as bool? ?? false;
//       setState(() {
//         isActive = state;
//       });
//     });
//   }

//   void _toggleDeviceState() async {
//     final newState = !isActive;
//     await deviceRef.child("state").set(newState);
//     setState(() {
//       isActive = newState;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       child: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Container(
//           decoration: BoxDecoration(
//             color: isActive
//                 ? const Color.fromARGB(255, 213, 223, 247)
//                 : const Color.fromARGB(248, 231, 233, 234),
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(
//                 widget.deviceImage,
//                 height: 60,
//                 color: const Color.fromARGB(255, 62, 97, 192),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         widget.deviceName,
//                         style: const TextStyle(
//                           color: Color.fromARGB(255, 24, 27, 110),
//                           fontSize: 23,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
                    
//                     if ( widget.deviceName != "Water Level ") // Exclude Water Level
//                     Transform.rotate(
//                       angle: pi / 2,
//                       child: Switch(
//                         activeColor: const Color.fromARGB(255, 45, 65, 216),
//                         value: isActive,
//                         onChanged: (value) => _toggleDeviceState(),
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
