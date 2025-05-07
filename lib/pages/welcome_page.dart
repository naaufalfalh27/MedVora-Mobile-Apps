import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../main.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  final TextEditingController nikController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  String? nikError;
  String? passwordError;

  // Animasi controller untuk slide
  late AnimationController _slideAnimationController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller animasi
    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    // Pastikan untuk dispose controller saat halaman dihancurkan
    _slideAnimationController.dispose();
    super.dispose();
  }

  void _showLoginModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "Hallo!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "Masukkan akun yang telah didaftarkan di klinik",
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nikController,
                decoration: InputDecoration(
                  labelText: 'NIK',
                  prefixIcon: const Icon(Icons.credit_card),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: nikError != null ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                child: nikError != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 4, left: 12),
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 1),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                              parent: _slideAnimationController,
                              curve: Curves.easeInOut)),
                          child: Text(
                            nikError!,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12),
                          ),
                        ),
                      )
                    : Container(),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: passwordError != null ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                child: passwordError != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 4, left: 12),
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 1),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                              parent: _slideAnimationController,
                              curve: Curves.easeInOut)),
                          child: Text(
                            passwordError!,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12),
                          ),
                        ),
                      )
                    : Container(),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text("Lupa Password?"),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Masuk", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _login() async {
    setState(() {
      isLoading = true;
      nikError = null;
      passwordError = null;
    });

    final nik = nikController.text.trim();
    final password = passwordController.text.trim();

    if (nik.isEmpty || password.isEmpty) {
      setState(() {
        isLoading = false;
        if (nik.isEmpty) nikError = "NIK tidak boleh kosong";
        if (password.isEmpty) passwordError = "Password tidak boleh kosong";
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1/medvora_api/login.php'),
        body: {'nik': nik, 'password': password},
      );

      final data = jsonDecode(response.body);
      print("Response body: ${response.body}");

      setState(() => isLoading = false);

      if (response.statusCode == 200) {
        if (data['success']) {
          Navigator.pop(context); // tutup modal
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    "Login berhasil! Selamat datang, ${data['user']['nama']}")),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyHomePage()),
          );
        } else {
          setState(() {
            if ((data['message'] ?? '').toLowerCase().contains('nik')) {
              nikError = data['message'];
            } else if ((data['message'] ?? '')
                .toLowerCase()
                .contains('password')) {
              passwordError = data['message'];
            }
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal menghubungi server. Coba lagi!")),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7156D7),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const SizedBox(height: 20),
            const Text(
              'Medvora',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Text(
                'Selamat datang di Medvora, solusi pintar untuk memastikan kesehatan Anda tetap terjaga dengan pengingat obat yang tepat waktu.',
                style: TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton.icon(
                onPressed: _showLoginModal,
                icon: const Icon(Icons.arrow_forward),
                label: const Text("Mulai Sekarang"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF7156D7),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
