import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'models/show.dart';
import 'services/api_service.dart';

class UpdateShowPage extends StatefulWidget {
  final Show show;

  UpdateShowPage({required this.show});

  @override
  _UpdateShowPageState createState() => _UpdateShowPageState();
}

class _UpdateShowPageState extends State<UpdateShowPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late String _category;
  File? _imageFile;
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.show.title);
    _descriptionController = TextEditingController(text: widget.show.description);
    _category = widget.show.category;
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    setState(() => _isLoading = true);

    try {
      await _apiService.updateShow(
        widget.show.id,
        _titleController.text,
        _descriptionController.text,
        _category,
        _imageFile,
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating show: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Show'),
        backgroundColor: Colors.blue.shade800,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final shouldDelete = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Delete Show'),
                  content: Text('Are you sure you want to delete this show?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );

              if (shouldDelete == true) {
                await _apiService.deleteShow(widget.show.id);
                Navigator.pop(context, true);
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _category,
                    items: ['movie', 'anime', 'serie']
                        .map((category) => DropdownMenuItem(
                              value: category,
                              child: Text(
                                category[0].toUpperCase() + category.substring(1),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => _category = value!),
                    decoration: InputDecoration(labelText: 'Category'),
                  ),
                  SizedBox(height: 20),
                  _imageFile != null
                      ? Image.file(_imageFile!, height: 200)
                      : widget.show.image != null
                          ? Image.network(widget.show.image!, height: 200)
                          : Text('No image available',
                              style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        icon: Icon(Icons.photo_library),
                        label: Text('Gallery'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.camera),
                        icon: Icon(Icons.camera_alt),
                        label: Text('Camera'),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade800,
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text('Update Show',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
    );
  }
}