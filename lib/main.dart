import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController _controller = TextEditingController();
  List<File> _imageFiles = [];
  int _currentIndex = 0;

  Future<void> getImageFiles() async {
    final directoryPath = _controller.text;
    final directory = Directory(directoryPath);

    final fileExists = await directory.exists();
    if (!fileExists) {
      print('Directory does not exist at: $directoryPath');
      throw 'Directory does not exist';
    }

    final imageFiles = directory
        .listSync(recursive: true)
        .where((file) =>
            file is File &&
            (file.path.toLowerCase().endsWith('.jpg') ||
                file.path.toLowerCase().endsWith('.png') ||
                file.path.toLowerCase().endsWith('.arw')))
        .cast<File>()
        .toList();

    setState(() {
      _imageFiles = imageFiles;
    });
  }

  void nextImage() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _imageFiles.length;
    });
  }

  void deleteImage() {
    _imageFiles[_currentIndex].delete();
    _imageFiles.removeAt(_currentIndex);
    if (_currentIndex >= _imageFiles.length) {
      _currentIndex = 0;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyFlutter',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueGrey,
        colorScheme: ThemeData.dark().colorScheme.copyWith(
              secondary: Colors.lightBlueAccent,
            ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.lightBlueAccent, // text color
          ),
        ),
      ),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Enter directory path',
                  labelStyle: TextStyle(color: Colors.lightBlueAccent),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlueAccent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlueAccent),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: getImageFiles,
                  child: Text('Load Images'),
                ),
              ),
              if (_imageFiles.isNotEmpty)
                Expanded(
                  child: Image.file(
                    _imageFiles[_currentIndex],
                    fit: BoxFit.contain,
                  ),
                ),
              SizedBox(height: 10),
              if (_imageFiles.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: nextImage,
                    child: Text('Next Image'),
                  ),
                ),
              if (_imageFiles.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: deleteImage,
                    child: Text('Delete Image'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
