import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart'; // Import your theme provider

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        //),
      ),
      body: ListView(
        children: [
          _buildSettingsItem(
            context,
            title: 'Dark Mode',
            trailing: Switch(
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
              },
            ),
            onTap: () {
              // No action needed since the Switch handles it
            },
          ),
          // Add more settings items here if needed
           _buildSettingsItem(
            context,
            title: 'Personal Information',
            onTap: () {
              // Navigate to Personal Information page
            },
          ),
          _buildSettingsItem(
            context,
            title: 'Account and Security',
            onTap: () {
              // Navigate to Account and Security page
            },
          ),
          _buildSettingsItem(
            context,
            title: 'App Notification',
            onTap: () {
              // Navigate to App Notification page
            },
          ),
          _buildSettingsItem(
            context,
            title: 'Activate Safe Mode',
            onTap: () {
              // Activate Safe Mode functionality
            },
          ),
          _buildSettingsItem(
            context,
            title: 'Temperature Unit',
            onTap: () {
              // Navigate to Temperature Unit settings
            },
          ),
          _buildSettingsItem(
            context,
            title: 'Privacy Settings',
            onTap: () {
              // Navigate to Privacy Settings
            },
          ),
        ],
      ),
    );
  }
      
  

  Widget _buildSettingsItem(BuildContext context,
      {required String title, Widget? trailing, required VoidCallback onTap}) {
    return ListTile(
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}


// import 'package:flutter/material.dart';

// class SettingsPage extends StatelessWidget {
//   const SettingsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text(
//           'Settings Page',
//           style: TextStyle(fontSize: 24, color: Colors.blue),
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';

// class SettingsPage extends StatelessWidget {
//   const SettingsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Settings'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: ListView(
//         children: [
//           _buildSettingsItem(
//             context,
//             title: 'Personal Information',
//             onTap: () {
//               // Navigate to Personal Information page
//             },
//           ),
//           _buildSettingsItem(
//             context,
//             title: 'Account and Security',
//             onTap: () {
//               // Navigate to Account and Security page
//             },
//           ),
//           _buildSettingsItem(
//             context,
//             title: 'App Notification',
//             onTap: () {
//               // Navigate to App Notification page
//             },
//           ),
//           _buildSettingsItem(
//             context,
//             title: 'Activate Safe Mode',
//             onTap: () {
//               // Activate Safe Mode functionality
//             },
//           ),
//           _buildSettingsItem(
//             context,
//             title: 'Dark Mode',
//             trailing: const Text('Off'),
//             onTap: () {
//               // Navigate to Dark Mode settings
//             },
//           ),
//           _buildSettingsItem(
//             context,
//             title: 'Temperature Unit',
//             onTap: () {
//               // Navigate to Temperature Unit settings
//             },
//           ),
//           _buildSettingsItem(
//             context,
//             title: 'Privacy Settings',
//             onTap: () {
//               // Navigate to Privacy Settings
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSettingsItem(BuildContext context,
//       {required String title, Widget? trailing, required VoidCallback onTap}) {
//     return ListTile(
//       title: Text(title),
//       trailing: trailing ?? const Icon(Icons.chevron_right),
//       onTap: onTap,
//     );
//   }
// }
