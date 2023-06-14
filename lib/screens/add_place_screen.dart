import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_place_with_riverpod/providers/user_places.dart';
import 'package:flutter_place_with_riverpod/widgets/image_input.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _selectedImage;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _savePlace() {
    final enteredText = _titleController.text;

    if (enteredText.isEmpty || _selectedImage == null) {
      return;
    }

    ref.read(userPlacesProvider.notifier).addPlace(
          enteredText,
          _selectedImage!,
        );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Place'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                controller: _titleController,
              ),
              ImageInput(
                onPickImage: (image) => _selectedImage = image,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Place'),
                onPressed: _savePlace,
              )
            ],
          ),
        ),
      ),
    );
  }
}
