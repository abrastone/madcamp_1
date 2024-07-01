// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class AddContestPage extends StatefulWidget {
//   @override
//   _AddContestPageState createState() => _AddContestPageState();
// }
//
// class _AddContestPageState extends State<AddContestPage> {
//   final _formKey = GlobalKey<FormState>();
//   String title = '';
//   String date = '';
//   String organizer = '';
//   Uint8List? posterImage;
//   List<Uint8List> detailImages = [];
//   int maker = 0;
//   int checker = 0;
//   String minLevel = '';
//   String maxLevel = '';
//
//   final ImagePicker _picker = ImagePicker();
//
//   Future<void> _pickImage(bool isPoster) async {
//       final List<XFile>? images = await _picker.pickMultiImage();
//       if (images != null && images.isNotEmpty) {
//         if (isPoster) {
//           final bytes = await images.first.readAsBytes();
//           setState(() {
//             posterImage = bytes;
//           });
//         } else {
//           final List<Uint8List> newImages = [];
//           for (var image in images) {
//             final bytes = await image.readAsBytes();
//             newImages.add(bytes);
//           }
//           setState(() {
//             detailImages.addAll(newImages);
//           });
//         }
//       }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('대회 추가하기'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: <Widget>[
//                 TextFormField(
//                   decoration: InputDecoration(
//                     labelText: '제목',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return '제목을 입력하세요';
//                     }
//                     return null;
//                   },
//                   onSaved: (value) {
//                     title = value!;
//                   },
//                 ),
//                 SizedBox(height: 10),
//                 TextFormField(
//                   decoration: InputDecoration(
//                     labelText: '일자',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return '일자를 입력하세요';
//                     }
//                     return null;
//                   },
//                   onSaved: (value) {
//                     date = value!;
//                   },
//                 ),
//                 SizedBox(height: 10),
//                 TextFormField(
//                   decoration: InputDecoration(
//                     labelText: '주최',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return '주최를 입력하세요';
//                     }
//                     return null;
//                   },
//                   onSaved: (value) {
//                     organizer = value!;
//                   },
//                 ),
//                 SizedBox(height: 10),
//                 posterImage == null
//                     ? ElevatedButton(
//                   onPressed: () => _pickImage(true),
//                   child: Text('포스터 이미지 선택'),
//                 )
//                     : Column(
//                   children: [
//                     Image.memory(posterImage!, height: 100),
//                     ElevatedButton(
//                       onPressed: () => _pickImage(true),
//                       child: Text('포스터 이미지 변경'),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 detailImages.isEmpty
//                     ? ElevatedButton(
//                   onPressed: () => _pickImage(false),
//                   child: Text('상세 이미지 선택'),
//                 )
//                     : Column(
//                   children: [
//                     Wrap(
//                       spacing: 10,
//                       runSpacing: 10,
//                       children: detailImages
//                           .map((img) => Image.memory(img, height: 100))
//                           .toList(),
//                     ),
//                     ElevatedButton(
//                       onPressed: () => _pickImage(false),
//                       child: Text('상세 이미지 추가'),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 TextFormField(
//                   decoration: InputDecoration(
//                     labelText: '출제 인원',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return '출제 인원을 입력하세요';
//                     }
//                     return null;
//                   },
//                   onSaved: (value) {
//                     maker = int.parse(value!);
//                   },
//                 ),
//                 SizedBox(height: 10),
//                 TextFormField(
//                   decoration: InputDecoration(
//                     labelText: '검수 인원',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return '검수 인원을 입력하세요';
//                     }
//                     return null;
//                   },
//                   onSaved: (value) {
//                     checker = int.parse(value!);
//                   },
//                 ),
//                 SizedBox(height: 10),
//                 TextFormField(
//                   decoration: InputDecoration(
//                     labelText: '최소 난이도',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return '최소 난이도를 입력하세요';
//                     }
//                     return null;
//                   },
//                   onSaved: (value) {
//                     minLevel = value!;
//                   },
//                 ),
//                 SizedBox(height: 10),
//                 TextFormField(
//                   decoration: InputDecoration(
//                     labelText: '최대 난이도',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return '최대 난이도를 입력하세요';
//                     }
//                     return null;
//                   },
//                   onSaved: (value) {
//                     maxLevel = value!;
//                   },
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       _formKey.currentState!.save();
//                       final newContest = {
//                         'title': title,
//                         'date': date,
//                         'organizer': organizer,
//                         'posterImage': posterImage,
//                         'detailImages': detailImages,
//                         'maker': maker,
//                         'checker': checker,
//                         'minLevel': minLevel,
//                         'maxLevel': maxLevel,
//                       };
//                       Navigator.of(context).pop(newContest);
//                     }
//                   },
//                   child: Text('추가'),
//                   style: ElevatedButton.styleFrom(
//                     padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                     textStyle: TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
