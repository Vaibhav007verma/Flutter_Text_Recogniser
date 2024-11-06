


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp( MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {

  XFile? imageFile;
  String scannedText = "";
  bool loader = false;

  @override
  void initState() {
    super.initState();
  }

  getImage(ImageSource source) async{
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if(pickedImage != null){
        setState(() {
          loader = true;
          imageFile = pickedImage;
        });
        getRecognisedText(pickedImage);
      }
    }catch(e){
      setState(() {
        loader = false;
        scannedText = "Error picking the Image";
        imageFile = null; setState(() { });
      });
    }
  }

  void getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = TextRecognizer(script: TextRecognitionScript.latin);
    RecognizedText recognisedText = await textDetector.processImage(inputImage);
    textDetector.close();
    scannedText = "";
    for(TextBlock block in recognisedText.blocks){
      for(TextLine line in block.lines){
        scannedText = scannedText + line.text + "\n";
      }
    }
    loader = false;
    setState(() { });
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  Scaffold(
        appBar: AppBar(title: Text("Hello World"),),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if(loader == true) CircularProgressIndicator(),
                if(imageFile != null) Container(height:300,width: 300,color: Colors.grey[300], child: Image.file(File(imageFile!.path)), margin: EdgeInsets.only(bottom: 10),),
                Container(width: MediaQuery.of(context).size.width*0.5,
                  height: 50, child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(onPressed: () => getImage(ImageSource.gallery), child: Column(children: [Icon(Icons.photo),Text("Gallery")],mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max,),style: ElevatedButton.styleFrom(primary: Colors.grey,onPrimary: Colors.white, shadowColor: Colors.grey[400], elevation: 10, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),),
                        ElevatedButton(onPressed: () => getImage(ImageSource.camera), child: Column(children:[Icon(Icons.camera),Text("Camera")],mainAxisAlignment: MainAxisAlignment.center,), style: ElevatedButton.styleFrom(primary: Colors.grey,onPrimary: Colors.white,shadowColor: Colors.grey[400],elevation: 10,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),)
                      ]),
                ),
                Container(margin: EdgeInsets.only(top: 10), child: Text(scannedText)),

              ],
            ),
          ),
        ),
      ),
    );
  }



}

