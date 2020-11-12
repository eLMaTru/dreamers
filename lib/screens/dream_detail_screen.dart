import 'package:dreamers/models/dream.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dreams_providers.dart';

class DreamDetailScreen extends StatelessWidget {
  static const routeName = "/dream-detail";

  @override
  Widget build(BuildContext context) {
    //just test must be changed
    Dream dream = ModalRoute.of(context).settings.arguments as Dream;
    dream = Provider.of<DreamsProvider>(context, listen: false).findById(dream.id);

    return Scaffold(
      appBar: AppBar(
        title: Text("Dreamers"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                dream.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              child: Text(dream.title, style: TextStyle(fontSize: 20),),
            ),
            Divider(endIndent: 10, indent: 10,),
            Container(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(
                  dream.description,
                ),
              ),
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
