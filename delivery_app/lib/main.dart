import 'dart:convert';
import 'dart:html' as html;
import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//This is the main page for the whole aplication
void main() {
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
  final List<Map<String, String>> _deliveries = [];
  final ImagePicker _picker = ImagePicker();
  String? _imageUrl;
  bool _isProcessing = false;

  Future<void> _pickImageAndProcess() async {
    try {
      setState(() {
        _isProcessing = true;
      });
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final imageBytes = await pickedFile.readAsBytes();
        setState(() {
          _imageUrl = pickedFile.path;
        });

        // Simulate OCR process for demo purposes
        await _processImage(imageBytes as Uint8List);
      }
    } catch (e) {
      _showErrorDialog('Error picking image: $e');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _processImage(Uint8List imageBytes) async {
    try {
      // Simulate OCR by parsing dummy text
      const recognizedText = '''
      John Doe Address: 123 Main St
      Jane Smith Address: 456 Elm St
      ''';

      final parsedData = _parseDeliveryData(recognizedText);

      setState(() {
        _deliveries.addAll(parsedData);
      });
    } catch (e) {
      _showErrorDialog('Error recognizing text: $e');
    }
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

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BNH Meals on Wheels Delivery App'),
      ),
      body: _isProcessing
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _pickImageAndProcess,
                child: const Text('Pick Image'),
              ),
            ],
          ),
          if (_imageUrl != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(_imageUrl!),
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
