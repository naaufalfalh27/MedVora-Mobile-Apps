import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:medivora/pages/welcome_page.dart';

class PermissionLocationScreen extends StatelessWidget {
  const PermissionLocationScreen({super.key});

  Future<void> _requestLocationPermission(BuildContext context) async {
    final status = await Permission.location.request();

    if (status.isGranted) {
      // Izin diberikan, lanjut ke login
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const WelcomePage()),
      );
    } else if (status.isPermanentlyDenied) {
      // Jika ditolak permanen, arahkan ke pengaturan
      await openAppSettings();
    } else {
      // Jika ditolak sementara, tampilkan pesan
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Izin lokasi diperlukan untuk melanjutkan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Image.asset('assets/images/location.png', height: 120),
            const SizedBox(height: 24),
            const Text(
              'Izinkan Akses Lokasi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Medvora membutuhkan akses lokasi untuk menampilkan informasi fasilitas kesehatan terdekat di sekitar Anda.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                _requestLocationPermission(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5E4BC7),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Izinkan Lokasi",
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WelcomePage()),
                );
              },
              child: const Text(
                "Nanti Saja",
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
