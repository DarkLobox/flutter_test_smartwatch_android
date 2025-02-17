import 'package:flutter/material.dart';
import 'package:flutter_wear_os_connectivity/flutter_wear_os_connectivity.dart';

void main() => runApp(const MyPhoneApp());

class MyPhoneApp extends StatelessWidget {
  const MyPhoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PhoneScreen(),
    );
  }
}

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  _PhoneScreenState createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final _wearConnectivity = FlutterWearOsConnectivity();
  int _currentNumber = 0;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _wearConnectivity.configureWearableAPI();
    _startListening();
  }

  void _startListening() {
    _wearConnectivity
        .messageReceived(
      pathURI: Uri(scheme: 'wear', host: '*', path: '/randomNumber'),
    )
        .listen((message) {
      final numberStr = String.fromCharCodes(message.data);
      setState(() {
        _currentNumber = int.parse(numberStr);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phone App')),
      body: Center(
        child: Text('Número actual: $_currentNumber',
            style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}
