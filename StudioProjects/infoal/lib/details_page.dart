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
  void _addInfo(String name, String infoTitle, String text) {
    setState((){
      Hive_addInfo(name, infoTitle, text);
    });
  }

  dynamic _infoAddButton(context, name, infoTitle) {
    return IconButton(
      icon: Icon(Icons.add),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            String text = '';
            return AlertDialog(
              title: Text('$infoTitle 추가하기'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(hintText: '추가할 내용을 입력해주세요.'),
                    onChanged: (value) {
                      text = value;
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
                    _addInfo(name, infoTitle, text);
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
  }

  void _deleteInfo(name, infoTitle, text) {
    setState((){
      Hive_deleteInfo(name, infoTitle, text);
    });
  }

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
                  if (infoContents == null || infoContents.isEmpty) {
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
                              trailing: _infoAddButton(context, name, infoTitle),
                              children: [Text("아직 작성하지 않았습니다.")],
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
                              trailing: _infoAddButton(context, name, infoTitle),
                              children: infoContents.map((infoContents) {
                                return Card(
                                  margin: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  child: ListTile(
                                    title: Text(infoContents),
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        _deleteInfo(name, infoTitle, infoContents);
                                      },
                                    ),
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