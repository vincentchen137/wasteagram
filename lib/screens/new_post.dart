import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import '../widgets/custom_scaffold.dart';
import '../models/post.dart';
import '../screens/list_screen.dart';

class NewPost extends StatefulWidget {
  
  File? image;
  
  NewPost({ 
    Key? key,
   required this.image 
  }) : super(key: key);

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  
  static const newPost = 'New Post';

  final formKey = GlobalKey<FormState>();
  var foodWastePost = FoodWastePost();

  LocationData? locationData;
  var locationService = Location();

  String? url;

  bool loading = false;   // used to display CircularProgressIndicator when running async tasks

  void retrieveLocation() async {
    var _serviceEnabled = await locationService.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await locationService.requestService();
      if (!_serviceEnabled) {
        print('Failed to enable service. Returning.');
        return;
      }
    }

    var _permissionGranted = await locationService.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await locationService.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print('Location service permission not granted. Returning.');
      }
    }

    locationData = await locationService.getLocation();
    // test latitude and longitude
    // print('latitude = ${locationData!.latitude}');
    // print('longitude = ${locationData!.longitude}');
    setState(() {});
  }

  Future uploadImage() async {
    var fileName = DateTime.now().toString() + '.jpg';
    Reference storageReference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = storageReference.putFile(widget.image!);
    await uploadTask;
    String imageURL = await storageReference.getDownloadURL();
    // test url
    // print(imageURL);
    return imageURL;
  }

  Future addNewPost(String quantity) async {
    url = await uploadImage();

    var dateTime = DateFormat.yMMMMEEEEd().format(DateTime.now());    //dateTime is now a String
    
    foodWastePost = FoodWastePost(
      date: dateTime, 
      imageURL: url, 
      quantity: quantity, 
      latitude: locationData!.latitude, 
      longitude: locationData!.longitude,
    );
    FirebaseFirestore.instance.collection('post').add(foodWastePost.toMap());
    Navigator.of(context).push(MaterialPageRoute(builder: ((context) => ListScreen())));
    // Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    retrieveLocation();
  }

  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: newPost,
      leading: BackButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: loading ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        child: Column(                
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: Image.file(widget.image!, fit: BoxFit.contain)
            ),
            Form(
              key: formKey,
              child: Column
              (
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: formFields(context),
              )
            )
          ]
        ),
      )
    );
  }

  List<Widget> formFields(BuildContext context) {
    return [
      Padding(
        padding: EdgeInsets.only(top: 20),
        child: Semantics(
          label: 'Form field to enter in number of items',
          child: TextFormField(
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Number of Items',
              border: OutlineInputBorder()
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly
            ],
            onSaved: (value) {
              int? q;
              q = int.parse(value!);
              foodWastePost.quantity = q.toString();
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter an integer';
              } else {
                return null;
              }
            }
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 300),
        child: Container(
          color: Colors.blue,
          padding: EdgeInsets.all(20.0),
          child: Semantics(
            button: true,
            label: 'Create new post',
            child: IconButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  setState(() {
                    loading = true;
                  });
                  await addNewPost(foodWastePost.quantity!);
                  setState(() {
                    loading = false; 
                  });              
                }
              }, 
                icon: const Icon(Icons.cloud_upload_outlined),
                iconSize: 45,
              ),
          )
        ),
      )
    ];
  }
}