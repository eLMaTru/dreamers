import 'package:dreamers/models/dream.dart';
import 'package:dreamers/screens/dream_detail_screen.dart';
import 'package:flutter/material.dart';

class DreamCard extends StatelessWidget {
  final Dream dream;

  DreamCard(this.dream);

  void selectDream(BuildContext context, Dream dream) {
    Navigator.of(context).pushNamed(DreamDetailScreen.routeName, arguments: dream);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectDream(context, dream),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Image.network(
                    dream.imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 3,
                  child: Container(
                    width: 145,
                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                    child: Text(
                      dream.title,
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
            )
          ],
        ),
      ),
    );
  }
}
