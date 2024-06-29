// lib/contacts_page.dart
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  Iterable<Contact>? _contacts;

  @override
  void initState() {
    super.initState();
    _getContacts();
  }

  Future<void> _getContacts() async {
    if (await Permission.contacts.request().isGranted) {
      final contacts = await ContactsService.getContacts();
      setState(() {
        _contacts = contacts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: _contacts != null
          ? ListView.builder(
        itemCount: _contacts!.length,
        itemBuilder: (context, index) {
          Contact contact = _contacts!.elementAt(index);
          String? phoneNumber;
          if (contact.phones != null && contact.phones!.isNotEmpty) {
            phoneNumber = contact.phones!.elementAt(0).value;
          }
          return ListTile(
            title: Text(contact.displayName ?? ''),
            subtitle: Text(phoneNumber ?? ''),
          );
        },
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
