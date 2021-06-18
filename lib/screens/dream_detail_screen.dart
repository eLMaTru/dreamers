import 'dart:async';

import 'package:dreamers/models/comment.dart';
import 'package:dreamers/models/dream.dart';
import 'package:flutter/material.dart';
import 'package:dreamers/providers/dreams_providers.dart';
import 'package:provider/provider.dart';

class DreamDetailScreen extends StatefulWidget {
  static const routeName = "/dream-detail";

  @override
  _DreamDetailScreenState createState() => _DreamDetailScreenState();
}

class _DreamDetailScreenState extends State<DreamDetailScreen> {
  List<Comment> comments = [];
  final _formKey = GlobalKey<FormState>();
  var _dreamId;
  var _comment;
  var _isComment = false;
  Dream dream = Dream(description: '');
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    //
    Future.delayed(Duration.zero).then((value) async {
      setState(() {
        isLoading = true;
      });
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, Object>;
      dream = args['dream'] as Dream;
      await Provider.of<DreamsProvider>(context, listen: false)
          .fetchComments(dream);
      comments = Provider.of<DreamsProvider>(context, listen: false).commnets;
      setState(() {
        isLoading = false;
      });
    });
    super.initState();

    Timer.run(() {
      if (_isComment) {
        openCommentDialog(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //just test must be changed
//Navigator.pop(context,true);
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, Object>;
    //final dreamPro = Provider.of<DreamsProvider>(context, listen: false);
    dream = args['dream'] as Dream;
    //dream = dreamPro.findById(dream.id);
    _dreamId = dream.id;
    _isComment = args['isComment'] as bool;

    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop('String');
            }),
        title: Text("Dreamers"),
      ),
      body: SingleChildScrollView(
        child: Column(
          //mainAxisSize: MainAxisSize.max,
          children: [
            dream.imageUrl.isEmpty
                ? Text('')
                : Container(
                    height: 250,
                    width: double.infinity,
                    child: Image.network(
                      dream.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
            dream.title.isEmpty
                ? Text('')
                : Container(
                    child: Text(
                      dream.title,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
            Container(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(
                  dream.description,
                ),
              ),
              width: double.infinity,
            ),
            Divider(
              endIndent: 10,
              indent: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Provider.of<DreamsProvider>(context, listen: false)
                        .addReaction(dream, true)
                        .then((response) {
                      setState(() {
                        if (response["likeSum"] == true) {
                          dream.likeLen += 1;
                        }

                        if (response["likeSubtract"] == true) {
                          dream.likeLen =
                              dream.likeLen > 0 ? dream.likeLen - 1 : 0;
                        }

                        if (response["dislikeSubtract"] == true) {
                          dream.dislikeLen =
                              dream.dislikeLen > 0 ? dream.dislikeLen - 1 : 0;
                        }

                        print(dream.likeLen);
                      });
                    });
                  },
                  child: Row(
                    children: [
                      Icon(Icons.thumb_up_alt_outlined),
                      SizedBox(
                        width: 3,
                      ),
                      Text("${dream.likeLen}"),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Provider.of<DreamsProvider>(context, listen: false)
                        .addReaction(dream, false)
                        .then((response) {
                      setState(() {
                        if (response["dislikeSum"] == true) {
                          dream.dislikeLen += 1;
                        }

                        if (response["dislikeSubtract"] == true) {
                          dream.dislikeLen =
                              dream.dislikeLen > 0 ? dream.dislikeLen - 1 : 0;
                        }

                        if (response["likeSubtract"] == true) {
                          dream.likeLen =
                              dream.likeLen > 0 ? dream.likeLen - 1 : 0;
                        }

                        print(dream.dislikeLen);
                      });
                    });
                  },
                  child: Row(
                    children: [
                      Icon(Icons.thumb_down_alt_outlined),
                      SizedBox(
                        width: 3,
                      ),
                      Text("${dream.dislikeLen}"),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => openCommentDialog(context),
                  child: Row(
                    children: [
                      Icon(Icons.comment_outlined),
                      SizedBox(
                        width: 3,
                      ),
                      Text('${dream.commentLen}'),
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              endIndent: 10,
              indent: 10,
            ),
            Container(
              child: SizedBox(
                  height: 200.0,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Row(
                          children: [
                            isLoading == true
                                ? Center(child: CircularProgressIndicator())
                                : Expanded(
                                    child: InkWell(
                                        onLongPress: () {
                                          showDialog(
                                              context: context,
                                              builder: (_) => Center(
                                                    child: FloatingActionButton(
                                                      onPressed: () {
                                                        Provider.of<DreamsProvider>(
                                                                context,
                                                                listen: false)
                                                            .deleteComment(
                                                                comments[index])
                                                            .then((cidx) {
                                                          setState(() {
                                                            comments
                                                                .removeAt(cidx);
                                                            if (dream
                                                                    .commentLen >
                                                                0) {
                                                              dream.commentLen -=
                                                                  1;
                                                              Provider.of<DreamsProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .editDream(
                                                                      dream);
                                                            }
                                                          });
                                                          Navigator.of(context)
                                                              .pop(false);
                                                        });
                                                      },
                                                      child: Icon(
                                                        Icons.delete_forever,
                                                      ),
                                                    ),
                                                  ));
                                        },
                                        child: Text(comments[index].username +
                                            ': ' +
                                            comments[index].description))),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 50.0,
      ),
    );
  }

  void openCommentDialog(BuildContext ctx) {
    showDialog(
        barrierDismissible: false,
        context: ctx,
        builder: (BuildContext buildContext) {
          return StatefulBuilder(builder: (ctx, setState) {
            return SingleChildScrollView(
              child: WillPopScope(
                onWillPop: () {
                  _comment = '';
                  _isComment = false;
                  return Future.value(true);
                },
                child: AlertDialog(
                  content: Stack(
                    children: [
                      Text(
                        'Comment',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Form(
                        key: _formKey,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            autofocus: true,
                            maxLines: 5,
                            onFieldSubmitted: (_) => onSaveComment(),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(labelText: 'Comment'),
                            textInputAction: TextInputAction.send,
                            onSaved: (newValue) {
                              _comment = newValue;
                              print(newValue);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please provide a value';
                              }

                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        onSaveComment();
                      },
                      child: Text('Send'),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  void onSaveComment() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();
    _isComment = false;

    Provider.of<DreamsProvider>(context, listen: false)
        .addComment(_dreamId, _comment)
        .then((value) {
      setState(() {
        comments = Provider.of<DreamsProvider>(context, listen: false).commnets;
        dream.commentLen += 1;
        Provider.of<DreamsProvider>(context, listen: false).editDream(dream);
      });

      Navigator.of(context).pop(false);
      _comment = '';
    });
  }

  //build button
  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.image),
                onPressed: () {},
                color: Colors.blueGrey,
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.face),
                onPressed: () {
                  setState(() {
                    //  isShowSticker = !isShowSticker;
                  });
                },
                color: Colors.blueGrey,
              ),
            ),
            color: Colors.white,
          ),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(color: Colors.blueGrey, fontSize: 15.0),
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.blueGrey),
                ),
              ),
            ),
          ),

          // Button send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () {},
                color: Colors.blueGrey,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border: new Border(
              top: new BorderSide(color: Colors.blueGrey, width: 0.5)),
          color: Colors.white),
    );
  }
}
