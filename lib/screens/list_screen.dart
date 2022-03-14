import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../screens/detail_screen.dart';
import '../widgets/custom_scaffold.dart';
import '../screens/new_post.dart';


class ListScreen extends StatefulWidget {
  const ListScreen({ Key? key }) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  
  File ? image;
  final picker = ImagePicker();
  int? quantities; 

  Future getImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return;
    } else {
      image = File(pickedFile.path);
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => NewPost(image: image!)));
    }
  }

  Future<void> getQuantities() async {
    final QuerySnapshot result = await FirebaseFirestore.instance.collection('post').get();
    final List<DocumentSnapshot> documents = result.docs;
    var q = 0;
    for (var doc in documents) {
      q += int.parse(doc['quantity']);
    }
    setState(() {quantities = q;});
  }

  @override
  void initState() {
    super.initState();
    getQuantities();
  }

  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: 'Wasteagram - ${quantities}', 
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('post').orderBy('imageURL', descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData &&
                snapshot.data!.docs != null &&
                snapshot.data!.docs.length > 0) {
            return Column(
              children: [
                listView(context, snapshot),
                postButton(context)
              ],
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const CircularProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.only(top: 400.0),
                    child: postButton(context),
                  )
                ]),
            ); 
          }
        }
      ),
    );
  }

  Widget listView (BuildContext context, snapshot) {
    return Expanded(
      child: ListView.builder(
        itemCount: snapshot.data!.docs.length,
        itemBuilder: (context, index) {
          var item = snapshot.data!.docs[index];
          return Semantics(
            label: 'A tile of all previous posts',
            onTapHint: 'Leads to a detail screen of this post',
            child: ListTile(
              leading: Text(item['date'].toString(),
                            style: TextStyle(fontSize: 18)),
              trailing: Text(item['quantity'].toString(),
                              style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => DetailScreen(item: item)));
              },
            ),
          );
        },
      ),
    );
  }

  Widget postButton (BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Ink(
        decoration: const ShapeDecoration(
          color: Colors.blue,
          shape: CircleBorder(),
        ),
        child: Semantics(
          button: true,
          label: 'Choose a picture to add as a new post',
          child: IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: () {
              getImage();
              // throw new StateError('This is an intentional dart error!');
            },
          ),
        ),
      ),
    );
  }
}
