import 'package:flutter/material.dart';

class SaranKesan extends StatefulWidget {
  const SaranKesan({Key? key}) : super(key: key);

  @override
  State<SaranKesan> createState() => _SaranKesanState();
}

class _SaranKesanState extends State<SaranKesan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSaranCard(),
            const SizedBox(height: 16),
            _buildKesanCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSaranCard() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Saran',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Pembelajaran yang diberikan sudah cukup baik, namun ada beberapa hal yang perlu diperbaiki. '
              'seperti ada beberapa materi yang cukup rumit, sehingga mahasiswa kesulitan untuk memahaminya. '
              'Saran saya, materi yang diberikan sebaiknya lebih sedikit di detailkan , sehingga mahasiswa dapat lebih mudah memahaminya. ',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKesanCard() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kesan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Kesan saya terhadap mata kuliah ini adalah mata kuliah ini sangat menarik, karena materi yang diberikan sangat bermanfaat.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
