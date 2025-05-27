import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/types/category.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class SellForm extends StatefulWidget {
  SellForm({super.key, required this.onSubmit});

  final Future<(bool, String)> Function(
    String description,
    String price,
    ApplianceCategory category,
    LatLng location,
    String imageUrl,
    DateTime availableFrom,
    DateTime availableUntil,
  )?
  onSubmit;

  final MapController mapController = MapController();

  @override
  State<SellForm> createState() => _SellFormState();
}

class _SellFormState extends State<SellForm> {
  final _formKey = GlobalKey<FormState>();
  final String _imgbbApiKey = '026b5184a33f91cf9b72a3d19231d5b0';

  LatLng? _selectedLocation;
  String? _description;
  String? _price;
  ApplianceCategory? _category;
  DateTime? _availableFrom;
  DateTime? _availableUntil;
  String? _errorMessage;

  XFile? _imageFile;
  Uint8List? _imageBytes;

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });

        if (kIsWeb) {
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _imageBytes = bytes;
          });
        } else {}
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fout bij kiezen afbeelding: $e')));
    }
  }

  Future<String> _uploadImageToImgbb() async {
    if (_imageFile == null) return '';
    try {
      final uri = Uri.parse('https://api.imgbb.com/1/upload');
      final request = http.MultipartRequest('POST', uri)
        ..fields['key'] = _imgbbApiKey;

      if (kIsWeb && _imageBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            _imageBytes!,
            filename: 'device_image.jpg',
          ),
        );
      } else {
        request.files.add(
          await http.MultipartFile.fromPath('image', _imageFile!.path),
        );
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);

      if (response.statusCode == 200 && data['success'] == true) {
        return data['data']['url'] ?? '';
      } else {
        throw Exception('ImgBB upload mislukt');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fout bij uploaden afbeelding')),
      );
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: "Description"),
              validator:
                  (value) =>
                      value == null || value.isEmpty
                          ? "Please enter a description"
                          : null,
              onSaved: (newValue) => _description = newValue,
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(labelText: "Price"),
              validator: (value) {
                if (value == null || value.isEmpty)
                  return "Please enter a price";
                if (double.tryParse(value) == null)
                  return "Please enter a valid number";
                return null;
              },
              onSaved: (newValue) => _price = newValue,
            ),
            const SizedBox(height: 8),
            DropdownMenu(
              dropdownMenuEntries: ApplianceCategory.entries,
              width: double.infinity,
              label: const Text("Category"),
              onSelected: (value) => setState(() => _category = value),
            ),
            const SizedBox(height: 16),
            Text(
              _availableFrom != null
                  ? "Available From: ${_availableFrom!.year}/${_availableFrom!.month}/${_availableFrom!.day}"
                  : "Available From: Not set",
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _availableFrom ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) setState(() => _availableFrom = picked);
                },
                child: const Text("Select Available From date"),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _availableUntil != null
                  ? "Available Until: ${_availableUntil!.year}/${_availableUntil!.month}/${_availableUntil!.day}"
                  : "Available Until: Not set",
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _availableUntil ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) setState(() => _availableUntil = picked);
                },
                child: const Text("Select Available Until date"),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: FlutterMap(
                mapController: widget.mapController,
                options: MapOptions(
                  initialCenter: LatLng(51.23016715, 4.4161294643975015),
                  initialZoom: 14.0,
                  interactionOptions: InteractionOptions(
                    flags: InteractiveFlag.all,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'edu.ap.flutter_map',
                  ),
                  MarkerLayer(
                    markers: [
                      if (_selectedLocation != null)
                        Marker(
                          alignment: Alignment(0, -1),
                          point: _selectedLocation!,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                    ],
                  ),
                  const Center(
                    child: Icon(Icons.close, color: Colors.black45, size: 40),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed:
                    () => setState(
                      () =>
                          _selectedLocation =
                              widget.mapController.camera.center,
                    ),
                child: const Text("Pick This Location"),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 200,
              child:
                  _imageFile != null
                      ? (kIsWeb
                          ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                          : Image.file(
                            File(_imageFile!.path),
                            fit: BoxFit.cover,
                          ))
                      : const Center(child: Text('No image selected')),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _pickImage,
                child: const Text('Pick Image'),
              ),
            ),
            const Divider(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    if (_selectedLocation == null ||
                        _availableFrom == null ||
                        _availableUntil == null ||
                        _availableFrom!.isAfter(_availableUntil!) ||
                        _category == null ||
                        _imageFile == null) {
                      setState(
                        () =>
                            _errorMessage = "Please fill all fields correctly",
                      );
                      return;
                    }

                    final imageUrl = await _uploadImageToImgbb();
                    if (imageUrl.isEmpty) {
                      setState(() => _errorMessage = "Image upload failed");
                      return;
                    }

                    widget
                        .onSubmit!(
                          _description!,
                          _price!,
                          _category!,
                          _selectedLocation!,
                          imageUrl,
                          _availableFrom!,
                          _availableUntil!,
                        )
                        .then((result) {
                          if (!result.$1) {
                            setState(() => _errorMessage = result.$2);
                          } else {
                            if (context.mounted) Navigator.pop(context);
                          }
                        });
                  }
                },
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll<Color>(Colors.green),
                  foregroundColor: WidgetStatePropertyAll<Color>(Colors.white),
                ),
                child: const Text("Submit"),
              ),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
    );
  }
}
