import 'package:dreamers/models/dream.dart';
import 'package:dreamers/providers/dreams_providers.dart';
import 'package:dreamers/screens/dream_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DreamCard extends StatefulWidget {
  final Dream dream;

  DreamCard(this.dream);

  @override
  _DreamCardState createState() => _DreamCardState();
}

class _DreamCardState extends State<DreamCard> {
  final testText =
      "Creates a vertical array of children The [direction], [mainAxisAlignment], [mainAxisSize], [crossAxisAlignment], and [verticalDirection] arguments must not be null. If [crossAxisAlignment] is [CrossAxisAlignment.baseline], then [textBaseline] must not be null The [textDirection] argument defaults to the ambient [Directionality], if any. If there is no ambient directionality, and a text direction is going to be necessary to disambiguate start or end values for the [crossAxisAlignment], the [textDirection] must not be null.";

  void selectDream(BuildContext context, Dream dream, bool isComment) {
    Navigator.of(context).pushNamed(DreamDetailScreen.routeName,
        arguments: {"dream": dream, "isComment": isComment}).then((value) {
      setState(() {
        widget.dream;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(1),
          child: widget.dream.userImage != null
              ? CircleAvatar(
                  child: Text(''),
                  backgroundColor: Theme.of(context).accentColor,
                  radius: 22,
                  backgroundImage: NetworkImage(widget.dream.userImage),
                  onBackgroundImageError: (exception, stackTrace) {
                    print(exception);
                  },
                )
              : CircleAvatar(
                  child: Text(
                    widget.dream.username.toUpperCase().substring(0, 1),
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Theme.of(context).accentColor,
                  radius: 22,
                ),
        ),
        title: Row(children: [
          Text(
            widget.dream.username,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            widget.dream.created,
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
          )
        ]),
        subtitle: Column(
          children: [
            widget.dream.title == '' ? Text('') : Text(widget.dream.title),
            Text(
              widget.dream.description.length > 401
                  ? widget.dream.description.substring(0, 400) + '...'
                  : widget.dream.description,
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: widget.dream.imageUrl.isNotEmpty ? 10 : 0,
            ),
            widget.dream.imageUrl.isNotEmpty
                ? Image.network(
                    widget.dream.imageUrl,
                    height: 150,
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
                InkWell(
                  onTap: () {
                    Provider.of<DreamsProvider>(context, listen: false)
                        .addReaction(widget.dream, true)
                        .then((response) {
                      setState(() {
                        if (response["likeSum"]) {
                          widget.dream.likeLen += 1;
                        }

                        if (response["likeSubtract"]) {
                          widget.dream.likeLen = widget.dream.likeLen > 0
                              ? widget.dream.likeLen - 1
                              : 0;
                        }

                        if (response["dislikeSubtract"]) {
                          widget.dream.dislikeLen = widget.dream.dislikeLen > 0
                              ? widget.dream.dislikeLen - 1
                              : 0;
                        }

                        print(widget.dream.likeLen);
                      });
                    });
                  },
                  child: Row(
                    children: [
                      Icon(Icons.thumb_up_alt_outlined),
                      SizedBox(
                        width: 3,
                      ),
                      Text("${widget.dream.likeLen}"),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Provider.of<DreamsProvider>(context, listen: false)
                        .addReaction(widget.dream, false)
                        .then((response) {
                      setState(() {
                        if (response["dislikeSum"]) {
                          widget.dream.dislikeLen += 1;
                        }

                        if (response["dislikeSubtract"]) {
                          widget.dream.dislikeLen = widget.dream.dislikeLen > 0
                              ? widget.dream.dislikeLen - 1
                              : 0;
                        }

                        if (response["likeSubtract"]) {
                          widget.dream.likeLen = widget.dream.likeLen > 0
                              ? widget.dream.likeLen - 1
                              : 0;
                        }

                        print(widget.dream.dislikeLen);
                      });
                    });
                  },
                  child: Row(
                    children: [
                      Icon(Icons.thumb_down_alt_outlined),
                      SizedBox(
                        width: 3,
                      ),
                      Text("${widget.dream.dislikeLen}"),
                    ],
                  ),
                ),
                InkWell(
                  child: Row(
                    children: [
                      Icon(Icons.comment_outlined),
                      SizedBox(
                        width: 3,
                      ),
                      Text('${widget.dream.commentLen}'),
                    ],
                  ),
                  onTap: () => selectDream(context, widget.dream, true),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
        onTap: () => selectDream(context, widget.dream, false),
      ),
    );
  }

  Widget getCard(BuildContext context) {
    return InkWell(
      onTap: () => selectDream(context, widget.dream, false),
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
                    widget.dream.title.isEmpty
                        ? ''
                        : widget.dream.title.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(widget.dream.description),
                  SizedBox(
                    height: 5,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(7),
                    ),
                    child: widget.dream.imageUrl.isNotEmpty
                        ? Image.network(
                            widget.dream.imageUrl,
                            height: 50,
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
