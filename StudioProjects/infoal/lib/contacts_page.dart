import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  Map<String, List<dynamic>> contacts = {};
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    try {
      String jsonString = await rootBundle.loadString('assets/data/contacts.json');
      Map<String, dynamic> jsonResponse = jsonDecode(jsonString);

      Map<String, List<dynamic>> parsedContacts = {};
      jsonResponse['data'].forEach((key, value) {
        parsedContacts[key] = List<dynamic>.from(value);
      });

      setState(() {
        contacts = parsedContacts;
      });
    } catch (e) {
      print('Failed to load contacts: $e');
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    try {
      if (!await launchUrl(launchUri)) {
        throw 'Could not launch $launchUri';
      }
    } catch (e) {
      print('Error making phone call: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // 검색어에 따라 필터링된 대학교 목록 생성
    var filteredContacts = contacts.keys.where((university) {
      return university.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 40),
            SizedBox(width: 20),
            const Text('연락처'),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: '대회 검색',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ),
      ),
      body: contacts.isNotEmpty
          ? ListView.builder(
        itemCount: filteredContacts.length,
        itemBuilder: (context, index) {
          String university = filteredContacts[index];
          List<dynamic> universityContacts = contacts[university]!;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  width: 2,
                  color: Colors.white12,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      university,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...universityContacts.map((contact) {
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: Image.asset('assets/images/person.png', height: 40),
                        title: Text(contact['role']),
                        subtitle: Text(contact['contact']),
                        trailing: IconButton(
                          icon: Image.asset('assets/images/phone.png', height: 30),
                          onPressed: () => _makePhoneCall(contact['contact']),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
