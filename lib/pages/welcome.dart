import 'package:flutter/material.dart';
import 'chat.dart';

class WelcomeChat extends StatelessWidget {
  const WelcomeChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Tombol back
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, size: 28),
                ),
              ),
            ),

            // Konten tengah: Gambar + Teks
            Column(
              children: [
                Image.asset(
                  'assets/vora_bot.png', // pastikan file ini ada di folder assets dan didaftarkan di pubspec.yaml
                  height: 200,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Asisten AI',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
                  child: Text(
                    'Halo! Aku Vora, asisten pintarmu.\nSiap membantu apa saja untukmu!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),

            // Tombol Mulai Chat
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B2F6B),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatPage()),
                );
              },
              child: const Text(
                "Mulai Chat",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
