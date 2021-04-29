import 'package:dreamers/models/dream.dart';
import 'package:dreamers/providers/dreams_providers.dart';
import 'package:dreamers/widgets/drawer_item.dart';
import 'package:dreamers/widgets/dream_card.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//import 'package:firebase_admob/firebase_admob.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/home";
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  var _desc = '';
  var _title = '';
  bool _init = false;
  bool isLoading = false;
  bool isPublic = false;

  void openDialogToSavingDream(BuildContext context) {
    //Navigator.of(context).pushNamed(FavoriteScreen.routeName);
    isPublic = false;
    showDialog(
        builder: (BuildContext buildContext) {
          return StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: AlertDialog(
                  content: Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      /*Positioned(
                      right: -40.0,
                      top: -40.0,
                      child: InkResponse(
                        onTap: () {
                          _desc = '';
                          _title = '';
                          Navigator.of(context).pop();
                        },
                        child: CircleAvatar(
                          child: Icon(Icons.close),
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ),*/
                      Text(
                        'Typing dream!',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                maxLength: 5000,
                                maxLines: 3,
                                decoration:
                                    InputDecoration(labelText: 'Dream *'),
                                keyboardType: TextInputType.multiline,
                                onSaved: (newValue) {
                                  _desc = newValue;
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please provide a value';
                                  }

                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Title (optional)'),
                                textInputAction: TextInputAction.next,
                                onSaved: (newValue) {
                                  _title = newValue;
                                },
                              ),
                            ),
                            CheckboxListTile(
                              title: Text("Public"),
                              value: isPublic,
                              onChanged: (newValue) {
                                setState(() {
                                  isPublic = newValue;
                                });
                              },
                              controlAffinity: ListTileControlAffinity
                                  .leading, //  <-- leading Checkbox
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        _desc = '';
                        _title = '';
                        Navigator.of(context).pop(false);
                      },
                      child: Text('Cancel'),
                    ),
                    RaisedButton(
                        color: Theme.of(context).accentColor,
                        textColor: Colors.white,
                        child: Text("Save"),
                        onPressed: () => onSaveDream()),
                  ],
                ),
              );
            },
          );
        },
        context: context);
  }

  void onSaveDream() {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }

    _formKey.currentState.save();
    //setState(() { _init = true;   });
    print(_desc + "\n" + _title);

    setState(() {
      isLoading = true;
      _init = true;
    });
    Provider.of<DreamsProvider>(context, listen: false)
        .addDream(
      Dream(title: _title, description: _desc, isPublic: isPublic),
    )
        .then((value) {
      setState(() {
        isLoading = false;
        _init = true;
      });
      Navigator.of(context).pop();
      //Navigator.of(context).pushReplacementNamed('/');
      _desc = '';
      _title = '';
    });

    // Navigator.of(context).pop();
    //Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  void initState() {
    // TODO: implement initState
    _init = true;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_init) {
      Provider.of<DreamsProvider>(context).dreamsRemote;
    }
    _init = false;
    super.didChangeDependencies();
  }

  Future<void> refreshDreams(BuildContext context) async{
    await Provider.of<DreamsProvider>(context, listen: false).dreamsRemote;
  }

  @override
  Widget build(BuildContext context) {
    //providers
   // Provider.of<DreamsProvider>(context, listen: false).clearComments();
    final dreamsData = Provider.of<DreamsProvider>(context);
    final dreamsHome = dreamsData.dreams;

    

    return Scaffold(
      drawer: DrawerItem(),
      appBar: AppBar(
        title: Text('Dreamers'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => refreshDreams(context),
        child: _init
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return DreamCard(dreamsHome[index]);
                  },
                  itemCount: dreamsHome.length,
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => openDialogToSavingDream(context),
      ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Container(
        height: 50.0,
      ),
    );
  }
}
