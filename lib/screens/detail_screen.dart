import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/custom_scaffold.dart';
import '../models/post.dart';

class DetailScreen extends StatefulWidget {

  DocumentSnapshot item;

  DetailScreen({ Key? key, required this.item }) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  
  var detailPost = FoodWastePost();

  void setDetailPost() {
    detailPost = FoodWastePost(
      date: widget.item['date'],
      quantity: widget.item['quantity'],
      imageURL: widget.item['imageURL'],
      latitude: widget.item['latitude'],
      longitude: widget.item['longitude'],
    );
  }

  @override
  void initState() {
    super.initState();
    setDetailPost();
  }

  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: 'Wasteagram',
      leading: BackButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Text('${detailPost.date}', style: TextStyle(fontSize: 25)),
          ),
          Center(
            child: Semantics(
              label: 'Image showing the food items',
              child: Image.network(
                detailPost.imageURL!,
                fit: BoxFit.contain),
            ),
          ),
          Container(
            child: Text('${detailPost.quantity} items', style: TextStyle(fontSize: 25))
          ),
          Container(
            child: Text('Location: ${detailPost.latitude}, ${detailPost.longitude}'),
          )
        ]
      )
    );
  }
}