import 'package:flutter/material.dart';

class KebijakanPrivasiPage extends StatelessWidget {
  const KebijakanPrivasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Warna latar belakang soft
      appBar: AppBar(
        title: const Text(
          'Kebijakan Privasi',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 3,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.deepPurple.shade100),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.privacy_tip, size: 36, color: Colors.deepPurple),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Privasi Anda Prioritas Kami',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Kami menjaga data Anda dengan standar keamanan terbaik.',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildCard(
            icon: Icons.security_outlined,
            title: 'Perlindungan Data',
            content:
                'Informasi pribadi Anda tidak akan dibagikan tanpa persetujuan. Kami hanya menggunakan data untuk kebutuhan internal aplikasi.',
          ),
          const SizedBox(height: 16),
          _buildCard(
            icon: Icons.update_outlined,
            title: 'Pembaruan Kebijakan',
            content:
                'Kami dapat memperbarui kebijakan ini sewaktu-waktu. Setiap perubahan akan ditampilkan pada halaman ini secara transparan.',
          ),
          const SizedBox(height: 16),
          _buildCard(
            icon: Icons.verified_user_outlined,
            title: 'Persetujuan Pengguna',
            content:
                'Dengan menggunakan aplikasi ini, Anda menyetujui pengumpulan dan penggunaan informasi sesuai kebijakan ini.',
          ),
          const SizedBox(height: 32),
          const Text(
            '@MedvoraPolije2025. Semua Hak DIlindungi.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required IconData icon, required String title, required String content}) {
    return Card(
      elevation: 2,
      shadowColor: Colors.deepPurple.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28, color: Colors.deepPurple),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(content,
                      style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
