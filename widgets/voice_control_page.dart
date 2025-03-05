import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:logger/logger.dart';

class VoiceController extends StatefulWidget {
  const VoiceController({super.key});

  @override
  State<VoiceController> createState() => _VoiceControllerState();
}

class _VoiceControllerState extends State<VoiceController> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isInitialized = false;
  String _command = '';
  final DatabaseReference _doorRef =
      FirebaseDatabase.instance.ref("devices/doorState");
  final DatabaseReference _lampRef =
      FirebaseDatabase.instance.ref("devices/smartLight");

  final Logger logger = Logger();

  // Dropdown selected option
  String _selectedCommand = 'Open door';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      if (!_isInitialized) {
        bool available = await _speech.initialize(
          onStatus: (status) {
            logger.d('Status: $status');
          },
          onError: (error) {
            logger.e('Error: $error');
          },
        );

        if (available) {
          if (mounted) {
            setState(() {
              _isListening = true;
              _isInitialized = true;
              _command = 'Listening...';
            });
          }

          _speech.listen(
            onResult: (result) {
              if (mounted) {
                setState(() {
                  _command = result.recognizedWords.toLowerCase();
                  logger.d("Recognized Speech: $_command");
                  _executeCommand(_command);
                });
              }
            },
          );
        } else {
          if (mounted) {
            setState(() {
              _command =
                  'Speech recognition not available. Error initializing.';
            });
          }
          logger.e('Speech recognition not available.');
        }
      } else {
        if (mounted) {
          setState(() {
            _isListening = true;
            _command = 'Listening...';
          });
        }
        _speech.listen(
          onResult: (result) {
            if (mounted) {
              setState(() {
                _command = result.recognizedWords.toLowerCase();
                logger.d("Recognized Speech: $_command");
                _executeCommand(_command);
              });
            }
          },
        );
      }
    } else {
      if (mounted) {
        setState(() {
          _isListening = false;
          _command = 'Listening stopped';
        });
      }
      _speech.stop();
    }
  }

  void _executeCommand(String command) async {
    if (!mounted) return;

    if (command.contains('open door')) {
      await _doorRef.child("state").set(true);
      if (mounted) {
        setState(() {
          _command = 'Door opened';
        });
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Door opened')),
        );
      }
    } else if (command.contains('close door')) {
      await _doorRef.child("state").set(false);
      if (mounted) {
        setState(() {
          _command = 'Door closed';
        });
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Door closed')),
        );
      }
    } else if (command.contains('turn on lamp')) {
      await _lampRef.child("state").set(true);
      if (mounted) {
        setState(() {
          _command = 'Lamp turned on';
        });
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lamp turned on')),
        );
      }
    } else if (command.contains('turn off lamp')) {
      await _lampRef.child("state").set(false);
      if (mounted) {
        setState(() {
          _command = 'Lamp turned off';
        });
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lamp turned off')),
        );
      }
    } else {
      if (mounted) {
        setState(() {
          _command = 'Command not recognized';
        });
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Command not recognized')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Control'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Stack(
        children: [
          // Positioned at the top of the page
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label for dropdown menu
                const Text(
                  'Press the button and say a command like:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                // Dropdown menu for commands
                Card(
                  elevation: 5,
                  color: Colors.lightBlue[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButton<String>(
                      value: _selectedCommand,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedCommand = newValue;
                          });
                        }
                      },
                      items: <String>[
                        'Open door',
                        'Close door',
                        'Turn on lamp',
                        'Turn off lamp'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      isExpanded: true,
                      underline: Container(),
                      icon: Icon(Icons.arrow_drop_down),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Centered command result text (Awaiting command)
          Center(
            child: Card(
              elevation: 5,
              color: Colors.lightBlue[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _command.isEmpty
                      ? 'Awaiting command...'
                      : 'Heard: $_command', // Display recognized speech only
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          // Positioned at the bottom of the page
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: 30.0), // Adjust padding as needed
              child: FloatingActionButton(
                onPressed: _listen,
                backgroundColor: Colors.blueAccent,
                child: Icon(_isListening ? Icons.mic : Icons.mic_none),
              ),
            ),
          ),
        ],
      ),
    );
  }
}