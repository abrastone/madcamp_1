// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:flutter/services.dart' show rootBundle;
//
// class DetailsPage extends StatefulWidget {
//   const DetailsPage({super.key});
//   String? name, phoneNumber;
//   @override
//   State<DetailsPage> createState() => _DetailsPageState();
// }
//
// class _DetailsPageState extends State<DetailsPage> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
//
//
//
// class DetailPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           children: [
//             Image.asset('assets/images/logo.png', height: 40),
//             SizedBox(width: 10),
//             Text('홍길동'),
//           ],
//         ),
//       ),
//       body: Container(child: Text("aefasef"),),
//     );
//   }
// }
//
//
//
//
//
// // class ContactsPage extends StatefulWidget {
// //   const ContactsPage({super.key});
// //
// //   @override
// //   _ContactsPageState createState() => _ContactsPageState();
// // }
// //
// // class _ContactsPageState extends State<ContactsPage> {
// //   Map<String, List<dynamic>> contacts = {};
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadContacts();
// //   }
// //
// //   Future<void> _loadContacts() async {
// //     try {
// //       String jsonString = await rootBundle.loadString('assets/data/contacts.json');
// //       Map<String, dynamic> jsonResponse = jsonDecode(jsonString);
// //
// //       Map<String, List<dynamic>> parsedContacts = {};
// //       jsonResponse['data'].forEach((key, value) {
// //         parsedContacts[key] = List<dynamic>.from(value);
// //       });
// //
// //       setState(() {
// //         contacts = parsedContacts;
// //       });
// //     } catch (e) {
// //       print('Failed to load contacts: $e');
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Row(
// //           children: [
// //             Image.asset('assets/images/logo.png', height: 40),
// //             SizedBox(width: 10),
// //             const Text('연락처'),
// //           ],
// //         ),
// //       ),
// //       body: contacts.isNotEmpty
// //           ? ListView.builder(
// //         itemCount: contacts.keys.length,
// //         itemBuilder: (context, index) {
// //           String university = contacts.keys.elementAt(index);
// //           List<dynamic> universityContacts = contacts[university]!;
// //           return Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: Container(
// //               decoration: BoxDecoration(
// //                 color: Colors.blue.shade50,
// //                 borderRadius: BorderRadius.circular(20),
// //               ),
// //               child: ExpansionTile(
// //                 title: Text(university),
// //                 children: universityContacts.map((contact) {
// //                   return ListTile(
// //                     leading: Image.asset('assets/images/person.png', height: 40),
// //                     title: Text(contact['role']),
// //                     subtitle: Text(contact['contact']),
// //                     trailing: Image.asset('assets/images/phone.png', height: 30),
// //                   );
// //                 }).toList(),
// //               ),
// //             ),
// //           );
// //         },
// //       )
// //           : const Center(child: CircularProgressIndicator()),
// //     );
// //   }
// // }
