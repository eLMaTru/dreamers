import 'package:dreamers/models/dream.dart';
import 'package:dreamers/providers/dreams_providers.dart';
import 'package:dreamers/screens/edit_dream_screen.dart';
import 'package:dreamers/widgets/drawer_item.dart';
import 'package:dreamers/widgets/dream_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dream_detail_screen.dart';

class DreamsScreen extends StatelessWidget {
  static const String routeName = "/dreams";

  @override
  Widget build(BuildContext context) {
    final dp = Provider.of<DreamsProvider>(context, listen: true);
    dp.getOwnDreams();
    List<Dream> dreams = dp.ownDreams;

    return Scaffold(
      drawer: DrawerItem(),
      appBar: AppBar(
        title: Text('Dreams'),
        centerTitle: true,
      ),
      body: dp.dreams.length > 0
          ? Container(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return customCard(context, dreams[index], dp);
                },
                itemCount: dreams.length,
              ),
            )
          : Text('Loading...'),
    );
  }

  Widget customCard(context, dream, dp) {
    return Dismissible(
      onDismissed: (direction) {
        dp.deleteDream(dream);
        print('borrado!!');
      },
      direction: DismissDirection.endToStart,
      key: ValueKey(dream.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        color: Colors.red,
      ),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        child: ListTile(
            trailing: IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(
                Icons.edit_outlined,
              ),
              onPressed: () {
                print(dream.id);
                Navigator.of(context).pushNamed(EditDreamScreen.routeName,
                    arguments: {'dreamId': dream.id});
              },
            ),
            leading: Container(
              padding: EdgeInsets.all(1),
              child: dream.userImage != null
                  ? CircleAvatar(
                      child: Text(''),
                      backgroundColor: Theme.of(context).accentColor,
                      radius: 22,
                      backgroundImage: NetworkImage(dream.userImage),
                      onBackgroundImageError: (exception, stackTrace) {
                        print(exception);
                      },
                    )
                  : CircleAvatar(
                      child: Text(
                        dream.username.toUpperCase().substring(0, 1),
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Theme.of(context).accentColor,
                      radius: 22,
                    ),
            ),
            title: Row(children: [
              Text(
                dream.username,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                dream.created,
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
              )
            ]),
            subtitle: Column(
              children: [
                dream.title == '' ? Text('') : Text(dream.title),
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
                    /*
                    
                    Row(
                      children: [
                        Icon(Icons.comment_outlined),
                        SizedBox(
                          width: 3,
                        ),
                        Text('${dream.commentLen}'),
                      ],
                    ),*/
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(DreamDetailScreen.routeName, arguments: dream);
            }),
      ),
      confirmDismiss: (DismissDirection direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirm"),
              content: const Text("Are you sure you wish to delete this item?"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("DELETE")),
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("CANCEL"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
