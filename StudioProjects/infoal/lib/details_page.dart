import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'main.dart';

class DetailsPage extends StatefulWidget {
  final Map<String, dynamic> contact;
  const DetailsPage({
    super.key,
    required this.contact,
  });
  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    String name = widget.contact['name'];
    return Scaffold(
        appBar: AppBar(title: Text(name),),
        body: FutureBuilder(
            future: Hive_getPerson(name), builder: (context, person) {
          if (person.hasData == false) {
            return CircularProgressIndicator();
          } else if (person.hasError) {
            return Text("자살할래");
          } else {
            Map<String, List<String>?> info = person.data!.info;
            List<String> infoKey = info.keys.toList();

            print(info.keys);
            print(infoKey);
            print(infoKey.length);
            print(infoKey[0]);
            print(info[infoKey[0]]);

            // print("case: infoContents == null");
            // return Text("....");


            return ListView.builder(
                itemCount: infoKey.length,
                itemBuilder: (BuildContext context, int index) {
                  String infoTitle = infoKey[index];
                  List<String>? infoContents = info[infoTitle];
                  if (infoContents == null) {
                    print("case: infoContents == null");
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ExpansionTile(
                              title: Text(infoTitle),
                              children: [Text("아직 작성하지 않았습니다.")]
                            )
                        )
                    );
                  } else {
                    print("case: infoContents != null");
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ExpansionTile(
                              title: Text(infoTitle),
                              children: infoContents.map((infoContents) {
                                return Card( // 각 연락처 띄우기
                                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: ListTile(
                                    title: Text(infoContents),
                                  ),
                                );
                              }).toList(),
                            )
                        )
                    );
                  }

            /*
                  return ListView.builder(itemBuilder: (context, index) {
                    String infoTitle = infoKey[index];
                    List<String>? infoContents = info[infoTitle];
                    print("infoContents: $infoContents");
                    if (infoContents != null) {
                      print("check: infoContents != null");
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ExpansionTile(
                                title: Text(infoTitle),
                                children: infoContents.map((infoContents) {
                                  return Card( // 각 연락처 띄우기
                                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    child: ListTile(
                                      title: Text(infoContents),
                                    ),
                                  );
                                }).toList(),
                              )
                          )
                      );
                    } else {
                      print("case: infoContents == null");
                      return Text("....");
                    }
                  });

             */
                }
            );


          }
        })
    );
  }
}

/*
                print(infoContents);
                if (infoContents == null) {
                  print("case: infoContents == null");
                  return Text("....");
                } else {
                  print("case: infoContents != null");



                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ExpansionTile(
                            title: Text(infoTitle),
                            children: infoContents.map((infoContents) {
                              return Card( // 각 연락처 띄우기
                                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: ListTile(
                                  title: Text(infoContents),
                                ),
                              );
                            }).toList(),
                          )
                      )
                  );



                }


              }

                // return Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Text(
                //     info['feature'].toString()
                //   )
                // );
              }
            })
        );
  }
}

ListView.builder(
  itemCount: filteredContacts.length,
  itemBuilder: (context, index) {
  String group = filteredContacts[index]; // group: 현재 그룹의 이름
  List<Map<String, dynamic>> groupContacts = widget.contacts[group]!; // groupContacts: 현재 그룹 내 연락처들
  return Padding(
    padding: const EdgeInsets.all(10.0),
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
        width: 3,
        color: Colors.white12,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row( // 그룹 (상단에 그룹 이름, Icons.photo, Icons.add)
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
                                  onChanged: (value) {
                                    contact = value;
                                  },
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
                                  Hive_addPerson(name);
                                 _addNewContact(group, name, contact);
                                  Navigator.of(context).pop();
                                },
                                child: Text('추가'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
...groupContacts.map((contact) { // 그룹 > 연락처



/*
class _DetailsPageState extends State<DetailsPage> {
  // Map<String, List<dynamic>> detail;
  //final person = await Hive.openBox<Person>('person');

  @override
  Widget build(BuildContext context) {
    String name = widget.contact['name'];
    return Scaffold(
        appBar: AppBar(title: Text(name),),
        body: <Widget>[
          Text("test"),
          // FutureBuilder(
          //   future: Hive_getPerson(name),
          //   builder: (context, person) {
          //     if (person.connectionState == ConnectionState.waiting) {
          //       return Center(child: Text("..."),);
          //     } else if (person.hasError) {
          //       return Center(child: Text("error"),);
          //     } else {
          //       Map<String, List<String>?> info = person.data!.info;
          //       ListView.builder(
          //         itemCount: info.keys.length,
          //         itemBuilder: (context, index) {
          //           String infoTitle = info.keys.elementAt(index);
          //           List<String>? infoContents = info[infoTitle];
          //           print(infoContents);
          //           if (infoContents != null) {
          //             print("check: infoContents != null");
          //             return Padding(
          //                 padding: const EdgeInsets.all(8.0),
          //                 child: Container(
          //                     decoration: BoxDecoration(
          //                       color: Colors.blue.shade50,
          //                       borderRadius: BorderRadius.circular(20),
          //                     ),
          //                     child: ExpansionTile(
          //                       title: Text(infoTitle),
          //                       children: infoContents.map((infoContents) {
          //                         return Text(infoContents);
          //                       }).toList(),
          //                     )
          //                 )
          //             );
          //           } else {
          //             print("check: infoContents == null");
          //             return Padding(
          //                 padding: const EdgeInsets.all(8.0),
          //                 child: Container(
          //                     decoration: BoxDecoration(
          //                       color: Colors.blue.shade50,
          //                       borderRadius: BorderRadius.circular(20),
          //                     ),
          //                     child: ExpansionTile(
          //                       title: Text(infoTitle),
          //                     )
          //                 )
          //             );
          //           }
          //         },
          //       );
          //     }
          //   }
          // )
        ]
    );
  }
}
*/

// return GestureDetector(
//
// child: ListTile(
// leading: Image.asset('assets/images/person.png', height: 40),
// title: Text(contact['role']),
// subtitle: Text(contact['contact']),
// trailing: GestureDetector( // 일단 임시로 이렇게 해놨는데, 이건 전화거는 걸로 변경하면 됨. 버튼 클릭 잘 되는 것 확인함.
//
// child: Image.asset('assets/images/phone.png', height: 30),
// ),
// ),
// );
// }).toList(),
//                   ),
//                 ),
//               )
//             }
//         ),
//       );
//     }).catchError((error) {
//       print('error: $error');
//       return Scaffold(
//         appBar: AppBar(title: Text("error page")),
//         body: Text("자살할게요 대충 에러 페이지");
//       )
//     });
//   }
// }

// ListView.builder(
// itemCount: contacts.keys.length,
// itemBuilder: (context, index) {
// String university = contacts.keys.elementAt(index);
// List<dynamic> universityContacts = contacts[university]!;
// return Padding(
// padding: const EdgeInsets.all(8.0),
// child: Container(
// decoration: BoxDecoration(
// color: Colors.blue.shade50,
// borderRadius: BorderRadius.circular(20),
// ),
// child: ExpansionTile(
// title: Text(university),
// children: universityContacts.map((contact) {

// }).toList(),




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





// class ContactsPage extends StatefulWidget {
//   const ContactsPage({super.key});
//
//   @override
//   _ContactsPageState createState() => _ContactsPageState();
// }
//
// class _ContactsPageState extends State<ContactsPage> {
//   Map<String, List<dynamic>> contacts = {};
//
//   @override
//   void initState() {
//     super.initState();
//     _loadContacts();
//   }
//
//   Future<void> _loadContacts() async {
//     try {
//       String jsonString = await rootBundle.loadString('assets/data/contacts.json');
//       Map<String, dynamic> jsonResponse = jsonDecode(jsonString);
//
//       Map<String, List<dynamic>> parsedContacts = {};
//       jsonResponse['data'].forEach((key, value) {
//         parsedContacts[key] = List<dynamic>.from(value);
//       });
//
//       setState(() {
//         contacts = parsedContacts;
//       });
//     } catch (e) {
//       print('Failed to load contacts: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           children: [
//             Image.asset('assets/images/logo.png', height: 40),
//             SizedBox(width: 10),
//             const Text('연락처'),
//           ],
//         ),
//       ),
//       body: contacts.isNotEmpty
//           ? ListView.builder(
//         itemCount: contacts.keys.length,
//         itemBuilder: (context, index) {
//           String university = contacts.keys.elementAt(index);
//           List<dynamic> universityContacts = contacts[university]!;
//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.blue.shade50,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: ExpansionTile(
//                 title: Text(university),
//                 children: universityContacts.map((contact) {
//                   return ListTile(
//                     leading: Image.asset('assets/images/person.png', height: 40),
//                     title: Text(contact['role']),
//                     subtitle: Text(contact['contact']),
//                     trailing: Image.asset('assets/images/phone.png', height: 30),
//                   );
//                 }).toList(),
//               ),
//             ),
//           );
//         },
//       )
//           : const Center(child: CircularProgressIndicator()),
//     );
//   }
// }
*/