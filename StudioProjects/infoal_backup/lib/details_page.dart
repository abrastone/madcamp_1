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
                              children: [Text("아직 작성하지 않았습니다.")],
                              // trailing: IconButton(
                              //   icon: Icon(Icons.add),
                              //   onPressed: () {
                              //     showDialog(
                              //       context: context,
                              //       builder: (BuildContext context) {
                              //         String name = '';
                              //         String contact = '';
                              //         return AlertDialog(
                              //           title: Text('연락처 추가하기'),
                              //           content: Column(
                              //             mainAxisSize: MainAxisSize.min,
                              //             children: [
                              //               TextField(
                              //                 decoration: InputDecoration(hintText: '이름'),
                              //                 onChanged: (value) {
                              //                   name = value;
                              //                 },
                              //               ),
                              //               TextField(
                              //                 decoration: InputDecoration(hintText: '연락처'),
                              //                 onChanged: (value) {
                              //                   contact = value;
                              //                 },
                              //               ),
                              //             ],
                              //           ),
                              //           actions: [
                              //             TextButton(
                              //               onPressed: () {
                              //                 Navigator.of(context).pop();
                              //               },
                              //               child: Text('취소'),
                              //             ),
                              //             TextButton(
                              //               onPressed: () {
                              //                 Hive_addPerson(name);
                              //                 _addNewContact(group, name, contact);
                              //                 Navigator.of(context).pop();
                              //               },
                              //               child: Text('추가'),
                              //             ),
                              //           ],
                              //         );
                              //       },
                              //     );
                              //   },
                              // ),
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

                }
            );
          }
        })
    );
  }
}