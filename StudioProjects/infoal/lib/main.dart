import 'package:flutter/material.dart';
import 'package:infoal/details_page.dart';
import 'contacts_page.dart';
import 'gallery_page.dart';
import 'album_collection_page.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'main.g.dart';

void main() {
  Hive_init();

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

// Hive 관련
@HiveType(typeId: 0)
class Person extends HiveObject {
  @HiveField(0)
  Map<String, List<String>?> info;

  Person(this.info);
}

void Hive_init() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PersonAdapter());
}

void Hive_addPerson(String name) async {
  //Box<Person> people = Hive.box('people');
  Box<Person> people = await Hive.openBox<Person>("people");
  //Map<String, List<String>?> nullPerson = {'특징': ['어쩌구저쩌구ㄴ러아ㅣㄴㄹ;ㅓ재댜ㅗㄹ내둘ㄴ우러농러ㅗㄴ어ㅘ니아ㅓㄴ앧ㄹ ㅜㅑㄷ랴됀', '으에에', '자살'], '고마워': null, '미안해': null, '속상해': null};
  Map<String, List<String>?> nullPerson = {'특징': null, '고마워': null, '미안해': null, '속상해': null};
  people.put(name, Person(nullPerson));
}

Future<Person> Hive_getPerson(String name) async {
  //Box<Person> people = Hive.box('people');
  Box<Person> people = await Hive.openBox<Person>("people");
  Person? ret = people.get(name);
  if (ret == null) {
    print("자살");
    return Person({'자살': ['죽을게']});
  }
  return ret;
}