import 'package:flutter/material.dart';
import 'contacts_page.dart';
import 'gallery_page.dart';
import 'album_collection_page.dart';
import 'calendar_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.lightBlue.shade100;

    return MaterialApp(
      home: HomePage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: primaryColor,
        fontFamily: 'Pretendard',
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          titleTextStyle: const TextStyle(
            color: Colors.black38,
            fontFamily: 'Pretendard',
            fontSize: 20,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: primaryColor,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.white70,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
        cardTheme: CardTheme(
          color: Colors.blue.shade100,
          shadowColor: Colors.grey.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      onGenerateRoute: (settings) {
        if (settings.name == '/gallery') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) {
              return GalleryPage(
                group: args['group'],
                images: args['images'].cast<String>(),
                onImagesChanged: args['onImagesChanged'],
              );
            },
          );
        }
        return null;
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  Map<String, List<Map<String, dynamic>>> contacts = {};
  Map<String, List<String>> galleryImages = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('contacts');
    if (data != null) {
      setState(() {
        contacts = (json.decode(data) as Map<String, dynamic>).map((key, value) =>
            MapEntry(key, List<Map<String, dynamic>>.from(value)));
      });
    }
  }

  void _addContact(Map<String, dynamic> contact) {
    setState(() {
      String group = contact['group'];
      if (contacts.containsKey(group)) {
        if (contact.containsKey('name')) {
          contacts[group]!.add(contact);
        }
      } else {
        contacts[group] = contact.containsKey('name') ? [contact] : [];
        galleryImages[group] = [];
      }
      _saveData();
    });
  }

  void _updateImages(String group, List<String> images) {
    setState(() {
      galleryImages[group] = images;
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('contacts', json.encode(contacts));
  }

  List<Widget> _widgetOptions(BuildContext context) {
    return <Widget>[
      ContactsPage(
        contacts: contacts,
        onAddContact: _addContact,
        onViewGallery: (group) {
          Navigator.pushNamed(
            context,
            '/gallery',
            arguments: {
              'group': group,
              'images': galleryImages[group] ?? [],
              'onImagesChanged': _updateImages,
            },
          );
        },
      ),
      AlbumCollectionPage(
        galleryImages: galleryImages,
        onImagesChanged: _updateImages,
      ),
      CalendarPage(contacts: contacts), // Pass the contacts to CalendarPage
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions(context).elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_album),
            label: 'Albums',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
