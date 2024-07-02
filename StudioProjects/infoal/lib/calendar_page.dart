import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CalendarPage extends StatefulWidget {
  final Map<String, List<Map<String, dynamic>>> contacts;

  const CalendarPage({Key? key, required this.contacts}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  Map<DateTime, List<Map<String, dynamic>>> _events = {};
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  List<Map<String, dynamic>> _selectedDayEvents = [];

  @override
  void initState() {
    super.initState();
    _initializeEvents();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('contacts');
    if (data != null) {
      setState(() {
        widget.contacts.clear();
        widget.contacts.addAll((json.decode(data) as Map<String, dynamic>).map((key, value) =>
            MapEntry(key, List<Map<String, dynamic>>.from(value))));
        _initializeEvents();
      });
    } else {
      _initializeEvents();
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('contacts', json.encode(widget.contacts));
  }

  void _initializeEvents() {
    _events.clear();
    widget.contacts.values.expand((groupContacts) => groupContacts).forEach((contact) {
      if (contact.containsKey('birthday')) {
        DateTime birthday = DateTime.parse(contact['birthday']);
        DateTime normalizedBirthday = DateTime(_focusedDay.year, birthday.month, birthday.day);

        if (_events[normalizedBirthday] == null) {
          _events[normalizedBirthday] = [];
        }
        _events[normalizedBirthday]!.add(contact);
      }
    });
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    DateTime normalizedDay = DateTime(_focusedDay.year, day.month, day.day);
    return _events[normalizedDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade100,
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 40),
            SizedBox(width: 20),
            const Text(
              '캘린더',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _selectedDayEvents = _getEventsForDay(selectedDay);
              });
            },
            eventLoader: _getEventsForDay,
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.yellow,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${events.length}',
                      style: const TextStyle().copyWith(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                  );
                }
                return null;
              },
              defaultBuilder: (context, day, focusedDay) {
                if (_events[day] != null) {
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    decoration: const BoxDecoration(
                      color: Colors.yellow,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${day.day}',
                      style: TextStyle().copyWith(color: Colors.black),
                    ),
                  );
                }
                return null;
              },
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue.shade300,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blue.shade500,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _selectedDayEvents.length,
              itemBuilder: (context, index) {
                final event = _selectedDayEvents[index];
                return Card(
                  child: ListTile(
                    leading: Image.asset('assets/images/person.png', height: 40),
                    title: Text(event['name']),
                    subtitle: Text(event['contact']),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
