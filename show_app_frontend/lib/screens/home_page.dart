import 'package:flutter/material.dart';
import 'package:show_app_frontend/models/show.dart';
import 'package:show_app_frontend/services/api_service.dart';
import 'package:show_app_frontend/screens/add_show_page.dart';
import 'package:show_app_frontend/screens/profile_page.dart';
import 'package:show_app_frontend/screens/update_show_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late Future<List<Show>> _showsFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _showsFuture = _apiService.getShows();
  }

  void _refreshShows() {
    setState(() {
      _showsFuture = _apiService.getShows();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Show App'),
        backgroundColor: Colors.blue.shade800,
      ),
      drawer: _buildDrawer(),
      body: FutureBuilder<List<Show>>(
        future: _showsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final shows = snapshot.data!;
            final filteredShows = shows.where((show) {
              if (_currentIndex == 0) return show.category == 'movie';
              if (_currentIndex == 1) return show.category == 'anime';
              return show.category == 'serie';
            }).toList();

            return _buildShowList(filteredShows);
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Movies'),
          BottomNavigationBarItem(icon: Icon(Icons.animation), label: 'Anime'),
          BottomNavigationBarItem(icon: Icon(Icons.tv), label: 'Series'),
        ],
        selectedItemColor: Colors.blue.shade800,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade800,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddShowPage()),
          );
          _refreshShows();
        },
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue.shade800),
            child: Text('Menu', style: TextStyle(
              color: Colors.white,
              fontSize: 24
            )),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Add Show'),
            onTap: () async {
              Navigator.pop(context);
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddShowPage()),
              );
              _refreshShows();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildShowList(List<Show> shows) {
    if (shows.isEmpty) {
      return Center(child: Text('No shows available'));
    }

    return ListView.builder(
      itemCount: shows.length,
      itemBuilder: (context, index) {
        final show = shows[index];
        return Dismissible(
          key: Key(show.id.toString()),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Delete Show'),
                content: Text('Are you sure you want to delete this show?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text('Delete', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
          onDismissed: (direction) async {
            await _apiService.deleteShow(show.id);
            _refreshShows();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Show deleted')),
            );
          },
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: show.image != null 
                ? Image.network(show.image!, width: 50, height: 50, fit: BoxFit.cover)
                : Icon(Icons.image, size: 50),
              title: Text(show.title, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(show.description),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateShowPage(show: show),
                  ),
                );
                _refreshShows();
              },
            ),
          ),
        );
      },
    );
  }
}