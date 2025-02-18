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
  final wearConnectivity = FlutterWearOsConnectivity();
  int currentNumber = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await wearConnectivity.configureWearableAPI();
    startListening();
  }

  startListening() {
    wearConnectivity
        .messageReceived(
      pathURI: Uri(scheme: 'wear', host: '*', path: '/randomNumber'),
    )
        .listen((message) {
      final numberStr = String.fromCharCodes(message.data);
      setState(() {
        currentNumber = int.parse(numberStr);
      });
    });
  }

  setSyncData() async {
    DataItem? dataItem = await wearConnectivity.syncData(
        path: "/data-path",
        data: {"message": "Data sync ${DateTime.now().millisecondsSinceEpoch}"},
        isUrgent: true);
    showToast('--- set sync data ${dataItem?.mapData}');
  }

  showToast(String label) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(label),
      duration: const Duration(milliseconds: 300),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phone App')),
      body: Column(
        children: [
          Center(
            child: Text('Número actual: $currentNumber',
                style: const TextStyle(fontSize: 24)),
          ),
          ElevatedButton(
            onPressed: () {
              setSyncData();
            },
            child: const Text('Sincronizar'),
          ),
        ],
      ),
    );
  }
}
