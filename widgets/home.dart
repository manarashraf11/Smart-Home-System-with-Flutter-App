import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'box1.dart';
import 'voice_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  final DatabaseReference tempReference = FirebaseDatabase.instance.ref("TEMP");
  final DatabaseReference humidityReference =
      FirebaseDatabase.instance.ref("HUMIDITY");
  String temperature = "0"; // Change type to String
  String humidity = "0";    // Change type to String

  final List<List<dynamic>> devices = [
    ["Smart Light", "icons/light-bulb.png", true, "devices/smartLight"],
    ["Smart Fan", "icons/fan.png", true, "devices/smartFan"],
    ["Door State", "icons/door.png", false, "devices/doorState"],
    ["Water Level", "icons/water-level.png", false, "devices/waterLevel"],
  ];

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchTempData();
    _fetchHumidityData();
  }
////////////////////////////temp from firebase////////////////////////////////////
  void _fetchTempData() {
    tempReference.onValue.listen((event) {
      final tempValue = event.snapshot.value as String? ?? "0"; // Parse as String
      setState(() {
        temperature = tempValue;
      });
    });
  }
  /////////////////humidity from firebase/////////////////////////////////////////

  void _fetchHumidityData() {
    humidityReference.onValue.listen((event) {
      final humidityValue = event.snapshot.value as String? ?? "0"; // Parse as String
      setState(() {
        humidity = humidityValue;
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeContent(
        temperature: temperature,
        humidity: humidity,
        devices: devices,
      ),
      const VoicePage(),
      const SettingsPage(),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: pages,
        ),
      ),
      /////////////bottom bar/////////////////////
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mic),
            label: 'Voice',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final String temperature; // Updated to String
  final String humidity;    // Updated to String
  final List<List<dynamic>> devices;

  const HomeContent({
    super.key,
    required this.temperature,
    required this.humidity,
    required this.devices,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Hello!',
                style: TextStyle(
                  color: Color.fromARGB(255, 70, 107, 242),
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(55),
                onTap: () {},
                child: Image.asset(
                  'icons/menu.png',
                  height: 45,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        const Text(
          'Welcome to your Smart Home',
          style: TextStyle(
            color: Color.fromARGB(255, 28, 63, 219),
            fontSize: 20,
          ),
        ),
        // Temperature & Humidity Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(8),
                width: 320,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Temperature
                    Column(
                      children: [
                        const Icon(Icons.thermostat, color: Colors.white),
                        const SizedBox(height: 4),
                        const Text(
                          'Temperature',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        Text(
                          temperature, // Use String value
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 70),
                    // Humidity
                    Column(
                      children: [
                        const Icon(Icons.water_drop, color: Colors.white),
                        const SizedBox(height: 4),
                        const Text(
                          'Humidity',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        Text(
                          humidity, // Use String value
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        // Smart Devices Section
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Smart Devices',
              style: TextStyle(
                color: Color.fromARGB(255, 14, 61, 164),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: devices.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              return Box(
                deviceName: devices[index][0],
                deviceImage: devices[index][1],
                firebasePath: devices[index][3],
              );
            },
          ),
        ),
      ],
    );
  }
}
