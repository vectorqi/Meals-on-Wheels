import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const DeliveryApp());
}

class DeliveryApp extends StatelessWidget {
  const DeliveryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BNH Meals on Wheels',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DeliveryHomePage(),
    );
  }
}

class DeliveryHomePage extends StatefulWidget {
  const DeliveryHomePage({Key? key}) : super(key: key);

  @override
  _DeliveryHomePageState createState() => _DeliveryHomePageState();
}

class _DeliveryHomePageState extends State<DeliveryHomePage> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  final List<Map<String, String>> _deliveries = [];

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(cameras.first, ResolutionPreset.medium);
    _initializeControllerFuture = _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _captureAndProcessImage() async {
    try {
      await _initializeControllerFuture;
      final image = await _cameraController.takePicture();

      final recognizedText = await _processImageWithMLKit(File(image.path));
      final parsedData = _parseDeliveryData(recognizedText);

      setState(() {
        _deliveries.addAll(parsedData);
      });
    } catch (e) {
      print('Error capturing or processing image: $e');
    }
  }

  Future<String> _processImageWithMLKit(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = GoogleMlKit.vision.textRecognizer();
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    textRecognizer.close();
    return recognizedText.text;
  }

  List<Map<String, String>> _parseDeliveryData(String text) {
    final lines = text.split('\n');
    final data = <Map<String, String>>[];

    for (final line in lines) {
      if (line.contains('Address:')) {
        final parts = line.split('Address:');
        if (parts.length == 2) {
          data.add({
            'name': parts[0].trim(),
            'address': parts[1].trim(),
            'status': 'Not Delivered',
          });
        }
      }
    }
    return data;
  }

  void _toggleStatus(int index) {
    setState(() {
      _deliveries[index]['status'] =
          _deliveries[index]['status'] == 'Not Delivered' ? 'Delivered' : 'Not Delivered';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BNH Meals on Wheels Delivery App'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _captureAndProcessImage,
            child: const Text('Capture Delivery Image'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _deliveries.length,
              itemBuilder: (context, index) {
                final delivery = _deliveries[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Name: ${delivery['name']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Address: ${delivery['address']}'),
                        Text('Status: ${delivery['status']}'),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () => _toggleStatus(index),
                      child: Text(
                        delivery['status'] == 'Not Delivered'
                            ? 'Mark as Delivered'
                            : 'Mark as Not Delivered',
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
