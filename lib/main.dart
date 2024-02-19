
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:ocr_scanner/camera_screen.dart';
import 'package:ocr_scanner/result_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';




void main() {
  runApp(const App());
}


class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Scanner',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}


class MainScreen extends StatefulWidget{
  const MainScreen({super.key});
  
  @override
  State<MainScreen> createState() => _MainScreenState();
  

}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver{

  final _textRecognizer = TextRecognizer(); 

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);

  }

  @override
  void dispose(){
    WidgetsBinding.instance.removeObserver(this);
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Builder(builder: (context) {
      return Row(
        children: [
          ElevatedButton(onPressed: () => OpenCam(), child: const Text("Camera"),),
          ElevatedButton(onPressed: () => _scanImage(), child: const Text("PDF"),),
        ],
      );
    });
  }

  Future<void> _scanImage() async{

    final navigator = Navigator.of(context);

    try{
      FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
      );

      final file = File(result!.files.single.path!);
      
      final inputImage = InputImage.fromFile(file);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      await navigator.push(
        MaterialPageRoute(builder: (context) => ResultScreen(text: recognizedText.text),
        ),
      );

    }catch (e){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred when scanning text"),
        ),
      );
    }

  }

  void OpenCam() async{
    final navigator = Navigator.of(context);

    navigator.push(
        MaterialPageRoute(builder: (context) => const CameraScreen(),
        ),
      );
  }

}





