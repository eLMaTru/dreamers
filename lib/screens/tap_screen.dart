import 'package:dreamers/screens/favorite_screen.dart';
import 'package:dreamers/screens/home_screen.dart';
import 'package:flutter/material.dart';

class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dreamers'),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.category),
                text: 'Dreams',
              ),
              Tab(icon: Icon(Icons.favorite))
            ],
          ),
        ),
        body: TabBarView(
          children: [
            HomePage(),
            FavoriteScreen(),
          ],
        ),
      ),
    );
  }
}

class BottonTabScreen extends StatefulWidget {
  @override
  _BottonTabScreenState createState() => _BottonTabScreenState();
}

class _BottonTabScreenState extends State<BottonTabScreen> {
  final List<Widget> _pages = [HomePage(), FavoriteScreen()];
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dreamers'),
      ),
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Dreams',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorites",
          ),
        ],
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).accentColor,
        currentIndex: _selectedPageIndex,
      ),
    );
  }
}
