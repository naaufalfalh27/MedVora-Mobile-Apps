import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import 'pages/beranda.dart';
import 'pages/darurat.dart';
import 'pages/riwayat.dart';
import 'pages/pengaturan.dart';
import 'pages/welcome_page.dart';
import 'pages/chat.dart';
import 'pages/const.dart'; // tempat simpan geminiApiKey

void main() {
  // Inisialisasi Gemini API
  Gemini.init(apiKey: geminiApiKey);

  // Menjalankan aplikasi
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medicine Reminder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5D5FEF)),
      ),
      // Halaman pertama yang ditampilkan adalah WelcomePage
      home: const WelcomePage(),
    );
  }
}

// Navigasi utama setelah login/register
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Menyimpan index yang sedang aktif
  int _currentIndex = 0;

  // Daftar halaman yang akan ditampilkan
  final List<Widget> _pages = [
    const BerandaPage(), // Halaman Beranda
    const DaruratPage(), // Halaman Darurat
    const RiwayatPage(), // Halaman Riwayat
    const PengaturanPage(), // Halaman Pengaturan
  ];

  // Daftar label untuk setiap tab di bottom navigation
  final List<String> _labels = ["Beranda", "Darurat", "Riwayat", "Pengaturan"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: _pages[_currentIndex], // Menampilkan halaman sesuai index
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex, // Menandakan index aktif
        backgroundColor: Colors.transparent,
        color: const Color(0xFF5D5FEF),
        buttonBackgroundColor: const Color(0xFF5D5FEF),
        animationDuration: const Duration(milliseconds: 300),
        height: 60,
        items: [
          _buildNavItem(const Icon(Icons.home), 0),
          _buildNavItem(const Icon(Icons.priority_high), 1),
          _buildNavItem(const Icon(Icons.book), 2),
          _buildNavItem(const Icon(Icons.settings), 3),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Mengubah halaman yang ditampilkan
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const ChatPage()), // Navigasi ke halaman chat
          );
        },
        backgroundColor: const Color(0xFF5D5FEF),
        child: const Icon(Icons.chat),
      ),
    );
  }

  // Fungsi untuk membangun item bottom navigation
  Widget _buildNavItem(Icon icon, int index) {
    bool isActive = _currentIndex == index; // Menentukan apakah item aktif

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon.icon,
          size: 30,
          color: isActive
              ? Colors.white
              : Colors.black, // Menentukan warna berdasarkan status aktif
        ),
        if (!isActive)
          Text(
            _labels[index], // Menampilkan label jika tidak aktif
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
          ),
      ],
    );
  }
}
