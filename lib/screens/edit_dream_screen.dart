import 'package:dreamers/models/dream.dart';
import 'package:dreamers/providers/dreams_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditDreamScreen extends StatefulWidget {
  static const String routeName = '/addDream';
  @override
  _EditDreamScreenState createState() => _EditDreamScreenState();
}

class _EditDreamScreenState extends State<EditDreamScreen> {
  final _imageUrlController = TextEditingController();
  final _imageFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _desc = '';
  var _title = '';
  bool isLoading = false;

  @override
  void dispose() {
    _imageFocusNode.removeListener(_updateImageUrl);
    _imageUrlController.dispose();
    _imageFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageUrl);
  }

  void _updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      isLoading = true;
    });

    Provider.of<DreamsProvider>(context, listen: false)
        .addDream(Dream(
            id: DateTime.now().toString(),
            title: _title,
            description: _desc,
            isPublic: true))
        .then((value) {
      setState(() {
        isLoading = true;
      });
      //Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/');
    });
    print(_desc);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Dream'),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(15),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        maxLength: 5000,
                        maxLines: 3,
                        decoration: InputDecoration(labelText: 'Dream *'),
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
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Title (optional)'),
                        textInputAction: TextInputAction.next,
                        onSaved: (newValue) {
                          _title = newValue;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: Colors.black54)),
                              height: 100,
                              width: 100,
                              margin: EdgeInsets.only(top: 8, right: 10),
                              child: _imageUrlController.text.isEmpty
                                  ? Text('Enter a URL')
                                  : FittedBox(
                                      child: Image.network(
                                        _imageUrlController.text,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Image URL'),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                controller: _imageUrlController,
                                focusNode: _imageFocusNode,
                                onEditingComplete: () {
                                  setState(() {});
                                },
                              ),
                            ),
                          ]),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RaisedButton(
                            onPressed: () {},
                            child: Text(
                              "Cancel",
                              style: TextStyle(),
                            ),
                          ),
                          RaisedButton(
                            onPressed: _saveForm,
                            child: Text(
                              "Save",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Theme.of(context).accentColor,
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
    );
  }
}
