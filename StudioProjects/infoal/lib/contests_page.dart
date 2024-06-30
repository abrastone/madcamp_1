import 'package:flutter/material.dart';

class ContestsPage extends StatelessWidget {
  const ContestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 40),
            SizedBox(width: 20),
            const Text('대회 찾기'),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildEventCard(
            context,
            '한국대학생 프로그래밍 경시대회',
            '2024.10.12',
            '정보통신부',
            'assets/images/poster1.jpg',
              5,
              5,
              '브론즈',
              '골드'

          ),
          _buildEventCard(
            context,
            '국민대학교 알고리즘 대회',
            '2024.10.12',
            '국민대학교 소프트웨어융합학과',
            'assets/images/poster1.jpg',
            5,
            5,
            '브론즈',
            '골드'
          ),
          _buildEventCard(
            context,
            '전국여고생 프로그래밍 경진대회',
            '2024.10.12',
            '여고협회',
            'assets/images/poster1.jpg',
            5,
            5,
            '브론즈',
            '골드'
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // 이벤트 추가 기능
        },
        label: Text('추가하기'),
        icon: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildEventCard(BuildContext context, String title, String date, String organizer, String imagePath, int maker, int checker, String min_level, String max_level) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '일자: $date',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '주최: $organizer',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '모집: 출제($maker) / 검수($checker)',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '난이도: ($min_level) - ($max_level)',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                ),
                Text(
                  "more...",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                )
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }
}
