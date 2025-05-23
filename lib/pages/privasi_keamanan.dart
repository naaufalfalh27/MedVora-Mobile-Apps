import 'package:flutter/material.dart';
import 'kebijakan_privasi_page.dart'; // atau sesuaikan nama/path-nya


class PrivasiKeamananPage extends StatefulWidget {
  const PrivasiKeamananPage({super.key});

  @override
  State<PrivasiKeamananPage> createState() => _PrivasiKeamananPageState();
}

class _PrivasiKeamananPageState extends State<PrivasiKeamananPage> {
  bool isTwoFactorEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Privasi & Keamanan",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 4,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _settingTile(
            icon: Icons.lock_outline,
            title: "Ubah Password",
            subtitle: "Ganti password akun Anda",
            onTap: () {
              _showEmailVerificationDialog();
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text("Verifikasi Dua Langkah"),
            subtitle: const Text("Tambahkan lapisan keamanan ekstra ke akun Anda"),
            secondary: const Icon(Icons.verified_user_outlined, color: Colors.deepPurple),
            value: isTwoFactorEnabled,
            onChanged: (val) {
              if (val) {
                _showOtpDialog(); // Tampilkan dialog OTP saat diaktifkan
              } else {
                setState(() {
                  isTwoFactorEnabled = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Verifikasi dua langkah dinonaktifkan')),
                );
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.deepPurple),
            title: const Text("Kebijakan Privasi"),
            subtitle: const Text("Baca kebijakan privasi kami"),
            onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const KebijakanPrivasiPage()),
  );
},

          ),
        ],
      ),
    );
  }

  void _showEmailVerificationDialog() {
    String email = '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Verifikasi Email'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Masukkan email Anda untuk menerima tautan ubah password'),
            const SizedBox(height: 12),
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'contoh@email.com',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              onChanged: (value) {
                email = value;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Kirim email ke backend di sini
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Link verifikasi dikirim ke $email')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
            ),
            child: const Text(
    'Kirim',
    style: TextStyle(color: Colors.white), // Teks putih
  ),
          ),
        ],
      ),
    );
  }

  void _showOtpDialog() {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Pilih Metode Verifikasi'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('Verifikasi via Email'),
            onTap: () {
              Navigator.pop(context);
              _showEmailOtpDialog();
            },
          ),
          ListTile(
            leading: const Icon(Icons.phone_android_outlined),
            title: const Text('Verifikasi via Nomor HP'),
            onTap: () {
              Navigator.pop(context);
              _showPhoneOtpDialog();
            },
          ),
        ],
      ),
    ),
  );
}
void _showEmailOtpDialog() {
  String email = '';
  String otp = '';
  bool otpSent = false;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Verifikasi Email'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Masukkan email Anda untuk menerima kode OTP'),
                const SizedBox(height: 8),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'contoh@email.com',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  onChanged: (value) => email = value,
                ),
                const SizedBox(height: 12),
                if (otpSent)
                  TextField(
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: const InputDecoration(
                      hintText: 'Kode OTP',
                      counterText: '',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    onChanged: (value) => otp = value,
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              if (!otpSent)
                ElevatedButton(
                  onPressed: () {
                    if (!email.contains('@')) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Masukkan email yang valid')),
                      );
                      return;
                    }
                    // TODO: Kirim OTP via email (integrasi backend)
                    setState(() {
                      otpSent = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Kode OTP dikirim ke $email')),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                  child: const Text('Kirim OTP', style: TextStyle(color: Colors.white)),
                ),
              if (otpSent)
                ElevatedButton(
                  onPressed: () {
                    if (otp == '123456') {
                      setState(() {
                        isTwoFactorEnabled = true;
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(this.context).showSnackBar(
                        const SnackBar(content: Text('Verifikasi dua langkah diaktifkan')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Kode OTP salah')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                  child: const Text('Verifikasi', style: TextStyle(color: Colors.white)),
                ),
            ],
          );
        },
      );
    },
  );
}

void _showPhoneOtpDialog() {
  String phone = '';
  String otp = '';
  bool otpSent = false;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Verifikasi Nomor HP'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Masukkan nomor HP Anda untuk menerima kode OTP'),
                const SizedBox(height: 8),
                TextField(
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: '08xxxxxxxxxx',
                    prefixIcon: Icon(Icons.phone_android),
                  ),
                  onChanged: (value) => phone = value,
                ),
                const SizedBox(height: 12),
                if (otpSent)
                  TextField(
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: const InputDecoration(
                      hintText: 'Kode OTP',
                      counterText: '',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    onChanged: (value) => otp = value,
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              if (!otpSent)
                ElevatedButton(
                  onPressed: () {
                    if (phone.length < 10 || !phone.startsWith('08')) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Masukkan nomor HP yang valid')),
                      );
                      return;
                    }
                    // TODO: Kirim OTP via backend
                    setState(() {
                      otpSent = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Kode OTP dikirim ke $phone')),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                  child: const Text('Kirim OTP', style: TextStyle(color: Colors.white)),
                ),
              if (otpSent)
                ElevatedButton(
                  onPressed: () {
                    if (otp == '123456') {
                      setState(() {
                        isTwoFactorEnabled = true;
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(this.context).showSnackBar(
                        const SnackBar(content: Text('Verifikasi dua langkah diaktifkan')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Kode OTP salah')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                  child: const Text('Verifikasi', style: TextStyle(color: Colors.white)),
                ),
            ],
          );
        },
      );
    },
  );
}



  Widget _settingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
