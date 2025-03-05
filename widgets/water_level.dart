import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class WaterLevelPage extends StatefulWidget {
  const WaterLevelPage({super.key});

  @override
  _WaterLevelPageState createState() => _WaterLevelPageState();
}

class _WaterLevelPageState extends State<WaterLevelPage> {
  late DatabaseReference waterLevelRef;
  String waterLevelPercentage = "0"; // Default water level percentage as a string

  @override
  void initState() {
    super.initState();
    waterLevelRef = FirebaseDatabase.instance.ref('devices/waterLevel');
    _fetchWaterLevel();
  }

  void _fetchWaterLevel() {
    waterLevelRef.child('percentage').onValue.listen((event) {
      final percentage = event.snapshot.value as String? ?? "0"; // Use String type
      setState(() {
        waterLevelPercentage = percentage;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Convert the string to a number for percentage calculation, fallback to 0 if parsing fails
    final waterLevelAsNum = double.tryParse(waterLevelPercentage) ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Water Level"),
        backgroundColor: const Color.fromARGB(255, 158, 211, 254),


      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Water Tank ",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            // Tank and Water Level Percentage
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Tank Outline
                Container(
                  width: 150,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                // Water Level
                Container(
                  width: 150,
                  height: 300 * (waterLevelAsNum / 100), // Dynamic height based on parsed value
                  decoration: BoxDecoration(
                    color: Colors.blue.shade300,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Water Level Percentage Display
            Text(
              "$waterLevelPercentage%",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            // Display "Tank is low" if water level is below 40%
            if (waterLevelAsNum < 40)
              const Text(
                "The tank is low!",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';

// class WaterLevelPage extends StatefulWidget {
//   const WaterLevelPage({super.key});

//   @override
//   _WaterLevelPageState createState() => _WaterLevelPageState();
// }

// class _WaterLevelPageState extends State<WaterLevelPage> {
//   late DatabaseReference waterLevelRef;
//   String waterLevelPercentage = "0"; // Default water level percentage as a string

//   @override
//   void initState() {
//     super.initState();
//     waterLevelRef = FirebaseDatabase.instance.ref('devices/waterLevel');
//     _fetchWaterLevel();
//   }

//   void _fetchWaterLevel() {
//     waterLevelRef.child('percentage').onValue.listen((event) {
//       final percentage = event.snapshot.value as String? ?? "0"; // Use String type
//       setState(() {
//         waterLevelPercentage = percentage;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Convert the string to a number for percentage calculation, fallback to 0 if parsing fails
//     final waterLevelAsNum = double.tryParse(waterLevelPercentage) ?? 0;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Water Level"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               "Tank 1",
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 10),
//             // Tank and Water Level Percentage
//             Stack(
//               alignment: Alignment.bottomCenter,
//               children: [
//                 // Tank Outline
//                 Container(
//                   width: 150,
//                   height: 300,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.black, width: 2),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 // Water Level
//                 Container(
//                   width: 150,
//                   height: 300 * (waterLevelAsNum / 100), // Dynamic height based on parsed value
//                   decoration: BoxDecoration(
//                     color: Colors.blue.shade300,
//                     borderRadius: const BorderRadius.vertical(
//                       bottom: Radius.circular(10),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             // Water Level Percentage Display
//             Text(
//               "$waterLevelPercentage%",
//               style: const TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }