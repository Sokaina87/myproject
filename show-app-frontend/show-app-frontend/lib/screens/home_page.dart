import 'package:flutter/material.dart';
import 'package:show_app_frontend/models/show.dart';
import 'package:show_app_frontend/screens/add_show_page.dart';
import 'package:show_app_frontend/screens/profile_page.dart';
import 'package:show_app_frontend/screens/update_show_page.dart';
import 'package:show_app_frontend/services/show_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ShowService _showService = ShowService();
  late Future<List<Show>> _showsFuture;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _refreshShows();
  }

  void _refreshShows() {
    setState(() {
      _showsFuture = _showService.getShows();
    });
  }

  // [Previous methods...]

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Show App'),
        backgroundColor: Colors.blue.shade800,
      ),
      drawer: _buildDrawer(),
      body: FutureBuilder<List<Show>>(
        future: _showsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final shows = snapshot.data!;
          // [Filtering logic...]
          
          return _buildShowList(filteredShows);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Movies'),
          BottomNavigationBarItem(icon: Icon(Icons.animation), label: 'Anime'),
          BottomNavigationBarItem(icon: Icon(Icons.tv), label: 'Series'),
        ],
      ),
    );
  }
}