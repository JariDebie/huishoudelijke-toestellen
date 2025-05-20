import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/types/category.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class SellForm extends StatefulWidget {
  SellForm({super.key, required this.onSubmit});

  final Future<(bool, String)> Function(
    String description,
    String price,
    ApplianceCategory category,
    String imageUrl,
    DateTime availableFrom,
    DateTime availableUntil,
  )?
  onSubmit;
  final MapController mapController = MapController();
  final ImagePicker imagePicker = ImagePicker();

  @override
  State<SellForm> createState() => _SellFormState();
}

class _SellFormState extends State<SellForm> {
  final _formKey = GlobalKey<FormState>();

  LatLng? _selectedLocation;
  String? _description;
  String? _price;
  ApplianceCategory? _category;
  DateTime? _availableFrom;
  DateTime? _availableUntil;
  String? _errorMessage;

  File? _imageFile;
  Future<void> _pickImage() async {
    XFile? pickedFile = await widget.imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      if (kIsWeb) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      } else {
        Directory appDirectory = await getApplicationDocumentsDirectory();
        String fileName =
            "${DateTime.now().toIso8601String()}${extension(pickedFile.path)}";
        String savePath = join(appDirectory.path, "images", fileName);

        await Directory(dirname(savePath)).create(recursive: true);

        File savedImage = await File(pickedFile.path).copy(savePath);

        setState(() {
          _imageFile = savedImage;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 8,
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: "Description"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter a description";
              }
              return null;
            },
            onSaved: (newValue) {
              setState(() {
                _description = newValue;
              });
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: "Price"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter a price";
              }
              return null;
            },
            onSaved: (newValue) {
              setState(() {
                _price = newValue;
              });
            },
          ),
          DropdownMenu(
            dropdownMenuEntries: ApplianceCategory.entries,
            width: double.infinity,
            label: const Text("Category"),
            onSelected: (value) {
              setState(() {
                _category = value;
              });
            },
          ),

          if (_availableFrom != null)
            Text(
              "Available From: ${_availableFrom!.year}/${_availableFrom!.month}/${_availableFrom!.day}",
            )
          else
            const Text("Available From: Not set"),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _availableFrom ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (pickedDate != null && pickedDate != _availableFrom) {
                  setState(() {
                    _availableFrom = pickedDate;
                  });
                }
              },
              child: const Text("Select Available From date"),
            ),
          ),

          if (_availableUntil != null)
            Text(
              "Available Until: ${_availableUntil!.year}/${_availableUntil!.month}/${_availableUntil!.day}",
            )
          else
            const Text("Available Until: Not set"),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _availableUntil ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (pickedDate != null && pickedDate != _availableUntil) {
                  setState(() {
                    _availableUntil = pickedDate;
                  });
                }
              },
              child: const Text("Select Available From date"),
            ),
          ),

          SizedBox(
            height: 300,
            child: FlutterMap(
              mapController: widget.mapController,
              options: MapOptions(
                initialCenter: LatLng(51.23016715, 4.4161294643975015),
                initialZoom: 14.0,
                interactionOptions: InteractionOptions(
                  flags:
                      InteractiveFlag.drag |
                      InteractiveFlag.pinchMove |
                      InteractiveFlag.pinchZoom |
                      InteractiveFlag.doubleTapZoom |
                      InteractiveFlag.scrollWheelZoom,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'edu.ap.flutter_map',
                ),
                MarkerLayer(
                  markers: [
                    if (_selectedLocation != null)
                      Marker(
                        alignment: Alignment(0, -1),
                        point: _selectedLocation!,
                        child: Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                  ],
                ),
                Center(
                  child: Icon(Icons.close, color: Colors.black45, size: 40),
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                setState(() {
                  _selectedLocation = widget.mapController.camera.center;
                });
              },
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(Colors.blue),
                foregroundColor: WidgetStatePropertyAll<Color>(Colors.white),
              ),
              child: const Text("Pick This Location"),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 200,
            child:
                _imageFile != null
                    ? kIsWeb
                        ? Image.network(_imageFile!.path, fit: BoxFit.cover) // web
                        : Image.file(_imageFile!, fit: BoxFit.cover) // mobile
                    : const Center(child: Text('No image selected')),
          ),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _pickImage,
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(Colors.blue),
                foregroundColor: WidgetStatePropertyAll<Color>(Colors.white),
              ),
              child: const Text('Pick Image'),
            ),
          ),
          Divider(height: 8, thickness: 1),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  if (_selectedLocation == null) {
                    setState(() {
                      _errorMessage = "Please select a location";
                    });
                    return;
                  }
                  if (_availableFrom == null || _availableUntil == null) {
                    setState(() {
                      _errorMessage = "Please select available dates";
                    });
                    return;
                  }
                  if (_category == null) {
                    setState(() {
                      _errorMessage = "Please select a category";
                    });
                    return;
                  }
                  if (_imageFile == null) {
                    setState(() {
                      _errorMessage = "Please select an image";
                    });
                  }

                  widget
                      .onSubmit!(
                        _description!,
                        _price!,
                        _category!,
                        _imageFile!.path,
                        _availableFrom!,
                        _availableUntil!,
                      )
                      .then((result) {
                        if (!result.$1) {
                          setState(() {
                            _errorMessage = result.$2;
                          });
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
          if (_errorMessage != null)
            Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}
