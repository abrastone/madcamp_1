// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// class ContestsPage extends StatefulWidget {
//   final List<Map<String, dynamic>> contests;
//   final Function(Map<String, dynamic>) onAddContest;
//   final Function(int) onDeleteContest;
//
//   const ContestsPage({
//     required this.contests,
//     required this.onAddContest,
//     required this.onDeleteContest,
//     super.key,
//   });
//
//   @override
//   _ContestsPageState createState() => _ContestsPageState();
// }
//
// class _ContestsPageState extends State<ContestsPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           children: [
//             Image.asset('assets/images/logo.png', height: 40),
//             SizedBox(width: 20),
//             const Text('대회 찾기'),
//           ],
//         ),
//       ),
//       body: widget.contests.isEmpty
//           ? Center(
//         child: Text(
//           '추가된 대회가 없습니다.',
//           style: TextStyle(fontSize: 18, color: Colors.grey),
//         ),
//       )
//           : ListView.builder(
//         padding: EdgeInsets.all(16),
//         itemCount: widget.contests.length,
//         itemBuilder: (context, index) {
//           final contest = widget.contests[index];
//           return _buildEventCard(
//             context,
//             contest['title'],
//             contest['date'],
//             contest['organizer'],
//             contest['posterImage'],
//             contest['detailImages'],
//             contest['maker'],
//             contest['checker'],
//             contest['minLevel'],
//             contest['maxLevel'],
//             index,
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () async {
//           final newContest = await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => AddContestPage()),
//           );
//           if (newContest != null) {
//             widget.onAddContest(newContest);
//           }
//         },
//         label: Text('추가하기'),
//         icon: Icon(Icons.add),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }
//
//   Widget _buildEventCard(
//       BuildContext context,
//       String title,
//       String date,
//       String organizer,
//       Uint8List posterImage,
//       List<Uint8List> detailImages,
//       int maker,
//       int checker,
//       String minLevel,
//       String maxLevel,
//       int index,
//       ) {
//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 10),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       elevation: 5,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
//             child: Image.memory(posterImage, fit: BoxFit.cover, height: 200, width: double.infinity),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   '일자: $date',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 Text(
//                   '주최: $organizer',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 Text(
//                   '모집: 출제($maker) / 검수($checker)',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 Text(
//                   '난이도: ($minLevel) - ($maxLevel)',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.delete, color: Colors.red),
//                       onPressed: () {
//                         widget.onDeleteContest(index);
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
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
//     if (isPoster) {
//       final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//       if (image != null) {
//         final bytes = await image.readAsBytes();
//         setState(() {
//           posterImage = bytes;
//         });
//       }
//     } else {
//       final List<XFile>? images = await _picker.pickMultiImage();
//       if (images != null) {
//         final bytesList = await Future.wait(images.map((image) => image.readAsBytes()));
//         setState(() {
//           detailImages = bytesList;
//         });
//       }
//     }
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
//                   decoration: const InputDecoration(
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
//                   decoration: const InputDecoration(
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
//                   decoration: const InputDecoration(
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
//                       children: detailImages.map((image) => Image.memory(image, height: 100)).toList(),
//                     ),
//                     ElevatedButton(
//                       onPressed: () => _pickImage(false),
//                       child: Text('상세 이미지 변경'),
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
