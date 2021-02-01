import 'package:dreamers/models/dream.dart';
import 'package:dreamers/screens/dream_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DreamCard extends StatelessWidget {
  final Dream dream;
  final testText =
      "Creates a vertical array of children The [direction], [mainAxisAlignment], [mainAxisSize], [crossAxisAlignment], and [verticalDirection] arguments must not be null. If [crossAxisAlignment] is [CrossAxisAlignment.baseline], then [textBaseline] must not be null The [textDirection] argument defaults to the ambient [Directionality], if any. If there is no ambient directionality, and a text direction is going to be necessary to disambiguate start or end values for the [crossAxisAlignment], the [textDirection] must not be null.";

  DreamCard(this.dream);

  void selectDream(BuildContext context, Dream dream) {
    Navigator.of(context)
        .pushNamed(DreamDetailScreen.routeName, arguments: dream);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      child: ListTile(
          leading: Container(
            padding: EdgeInsets.all(1),
            child: CircleAvatar(
              child: dream.imageUrl == ''
                  ? Text('')
                  : Text('A'),
              backgroundColor: Theme.of(context).accentColor,
              radius: 22,
            backgroundImage: NetworkImage(
                  'https://www.080digital.com/wp-content/uploads/2017/06/pinterest.jpg'),
              onBackgroundImageError: (exception, stackTrace) {
                print(exception);
              },),
          ),
          title: Text(
            dream.username +'  '+ dream.created,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          subtitle: Column(
            children: [
              Text(
                dream.description.length > 401
                    ? dream.description.substring(0, 400) + '...'
                    : dream.description,
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(
                height: dream.imageUrl.isNotEmpty ? 10 : 0,
              ),
              dream.imageUrl.isNotEmpty
                  ? Image.network(
                      dream.imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Text(''),
                  SizedBox(
                height: 5,
              ),
              Row(
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
                  Row(
                    children: [
                      Icon(Icons.comment_outlined),
                      SizedBox(
                        width: 3,
                      ),
                      Text('2'),
                    ],
                  ),
                ],
              ),
            ],
          ),
          onTap: () {
            print("object");
          }),
    );
  }

  Widget getCard(BuildContext context) {
    return InkWell(
      onTap: () => selectDream(context, dream),
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1),
          ),
          elevation: 2,
          margin: EdgeInsets.symmetric(horizontal: 1, vertical: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    child: Text('A'),
                    backgroundColor: Theme.of(context).accentColor,
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    dream.title.isEmpty ? '' : dream.title.toUpperCase(),
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
