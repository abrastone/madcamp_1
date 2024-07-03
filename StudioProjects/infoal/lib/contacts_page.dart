import 'package:flutter/material.dart';
import 'package:infoal/details_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ContactsPage extends StatefulWidget {
  final Map<String, List<Map<String, dynamic>>> contacts;
  final Function(Map<String, dynamic>) onAddContact;
  final Function(String) onViewGallery;

  const ContactsPage({
    required this.contacts,
    required this.onAddContact,
    required this.onViewGallery,
    Key? key,
  }) : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  String searchQuery = "";

  void _addNewContact(String group, String name, String contact, DateTime birthday) {
    widget.onAddContact({
      'group': group,
      'name': name,
      'contact': contact,
      'birthday': birthday.toIso8601String(),
    });
    _saveData();
  }

  void _deleteContact(String group, String name) {
    setState(() {
      widget.contacts[group]!.removeWhere((contact) => contact['name'] == name);

    });
    _saveData();
  }

  void _deleteGroup(String group) {
    setState(() {
      widget.contacts.remove(group);
    });
    _saveData();
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

  Future<void> _selectDate(BuildContext context, Function(DateTime) onDateSelected) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('contacts', json.encode(widget.contacts));
  }

  String _formatPhoneNumber(String input) {
    if (input.length == 11) {
      return '${input.substring(0, 3)}-${input.substring(3, 7)}-${input.substring(7)}';
    }
    return input;
  }

  @override
  Widget build(BuildContext context) {
    var filteredContacts = widget.contacts.keys.where((group) {
      return group.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade100,
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 40),
            SizedBox(width: 20),
            const Text(
              '연락처',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: '그룹 검색',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ),
      ),
      body: widget.contacts.isNotEmpty
          ? ListView.builder(
        itemCount: filteredContacts.length,
        itemBuilder: (context, index) {
          String group = filteredContacts[index];
          List<Map<String, dynamic>> groupContacts = widget.contacts[group]!;
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  width: 3,
                  color: Colors.white12,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          group,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.photo),
                              onPressed: () {
                                widget.onViewGallery(group);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    String name = '';
                                    String contact = '';
                                    DateTime birthday = DateTime.now();
                                    return StatefulBuilder(
                                      builder: (context, setState) {
                                        return AlertDialog(
                                          title: Text('연락처 추가하기'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextField(
                                                decoration: InputDecoration(hintText: '이름'),
                                                onChanged: (value) {
                                                  name = value;
                                                },
                                              ),
                                              TextField(
                                                decoration: InputDecoration(hintText: '연락처'),
                                                keyboardType: TextInputType.number,
                                                maxLength: 11,
                                                onChanged: (value) {
                                                  contact = value;
                                                },
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    '생일: ${DateFormat('yy-MM-dd').format(birthday)}',
                                                    style: TextStyle(fontSize: 16),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      _selectDate(context, (selectedDate) {
                                                        setState(() {
                                                          birthday = selectedDate;
                                                        });
                                                      });
                                                    },
                                                    child: Text('생일 선택'),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('취소'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                if (name.isEmpty || contact.isEmpty) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text('이름과 연락처를 입력하세요.'),
                                                    ),
                                                  );
                                                  return;
                                                }

                                                if (groupContacts.any((c) => c['name'] == name)) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text('이미 존재하는 이름입니다.'),
                                                    ),
                                                  );
                                                  return;
                                                }

                                                _addNewContact(group, name, _formatPhoneNumber(contact), birthday);
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('추가'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _deleteGroup(group);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ...groupContacts.map((contact) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DetailsPage(contact: contact)),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: Image.asset('assets/images/person.png', height: 40),
                          title: Text(contact['name']),
                          subtitle: Text('${contact['contact']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Image.asset('assets/images/phone.png', height: 30),
                                onPressed: () => _makePhoneCall(contact['contact']),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _deleteContact(group, contact['name']);
                                },
                              ),
                            ],
                          ),
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
          : Center(
        child: Text(
          '연락처를 등록해주세요.',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              String group = '';
              return AlertDialog(
                title: const Text('그룹 추가하기'),
                content: TextField(
                  decoration: InputDecoration(hintText: '그룹 이름'),
                  onChanged: (value) {
                    group = value;
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('취소'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (group.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('그룹 이름을 입력하세요.'),
                          ),
                        );
                        return;
                      }

                      if (widget.contacts.containsKey(group)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('이미 존재하는 그룹입니다.'),
                          ),
                        );
                        return;
                      }

                      setState(() {
                        widget.contacts[group] = [];
                        widget.onAddContact({
                          'group': group,
                        });
                        _saveData();
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text('추가'),
                  ),
                ],
              );
            },
          );
        },
        label: Text('그룹 추가하기'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.lightBlue.shade100,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
