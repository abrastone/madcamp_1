import 'package:flutter/material.dart';
import 'contacts_page.dart';
import 'gallery_page.dart';
import 'album_collection_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
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
    });
  }

  void _updateImages(String group, List<String> images) {
    setState(() {
      galleryImages[group] = images;
    });
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
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
