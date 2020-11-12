import 'package:dreamers/models/dream.dart';
import 'package:dreamers/screens/dream_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DreamCard extends StatelessWidget {
  final Dream dream;

  DreamCard(this.dream);

  void selectDream(BuildContext context, Dream dream) {
    Navigator.of(context)
        .pushNamed(DreamDetailScreen.routeName, arguments: dream);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectDream(context, dream),
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1),
          ),
          elevation: 2,
          margin: EdgeInsets.symmetric(horizontal: 1, vertical: 3),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [Column(children: [
CircleAvatar(
                child: Text('A'),
                backgroundColor: Theme.of(context).accentColor,
              )
            ],)
              ,
              Column(mainAxisSize: MainAxisSize.max, 
                children: [
                  Text(
                    dream.title.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(dream.description),
                  SizedBox(
                    height: 5,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(7),
                    ),
                    child: dream.imageUrl.isNotEmpty
                        ? Image.network(
                            dream.imageUrl,
                            height: 150,
                            width: 300,
                            fit: BoxFit.cover,
                          )
                        : Text(''),
                  ),
               
                     Padding(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        
                        children: <Widget>[
                          Row(
                            children: [
                              Icon(Icons.thumb_up_alt_outlined),
                              SizedBox(
                                width: 3,
                              ),
                              Text('11'),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.thumb_down_alt_outlined),
                              SizedBox(
                                width: 3,
                              ),
                              Text('2'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  
                ],
              ),
            ],
          )),
    );
  }
}
