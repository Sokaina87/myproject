import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:show_app_frontend/models/show.dart';
import 'package:show_app_frontend/services/show_service.dart';

class UpdateShowPage extends StatefulWidget {
  final Show show;
  
  const UpdateShowPage({super.key, required this.show});

  @override
  State<UpdateShowPage> createState() => _UpdateShowPageState();
}

class _UpdateShowPageState extends State<UpdateShowPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late String _category;
  File? _imageFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.show.title);
    _descriptionController = TextEditingController(text: widget.show.description);
    _category = widget.show.category;
  }

  // [Image picking and update methods...]

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Show'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _confirmDelete,
          ),
        ],
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                child: Column(
                  children: [
                    // [Form fields...]
                    ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Update Show'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}