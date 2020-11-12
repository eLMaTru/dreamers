import 'package:dreamers/providers/dreams_providers.dart';
import 'package:dreamers/widgets/drawer_item.dart';
import 'package:dreamers/widgets/dream_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'favorite_screen.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();

  void workingWithNavigation(BuildContext context) {
    //Navigator.of(context).pushNamed(FavoriteScreen.routeName);
    showDialog(
        builder: (BuildContext buildContext) {
          return AlertDialog(
            content: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.close),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                Text(
                  'Typing dream!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('Cancel'),
              ),
              RaisedButton(
                  color: Theme.of(context).accentColor,
                  textColor: Colors.white,
                  child: Text("Save"),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                    }
                    Navigator.of(context).pop(false);
                  }),
            ],
          );
        },
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    //providers
    final dreamsData = Provider.of<DreamsProvider>(context);
    final dreams = dreamsData.dreams;

    //final dreams = DUMMY_DREAMS.where((dream) => dream.isPublic).toList();

    return Scaffold(
      drawer: DrawerItem(),
      appBar: AppBar(
        title: Text('Dreamers'),
        centerTitle: true,
      ),
      body: Container(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return DreamCard(dreams[index]);
          },
          itemCount: dreams.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => workingWithNavigation(context),
      ),
    );
  }
}
