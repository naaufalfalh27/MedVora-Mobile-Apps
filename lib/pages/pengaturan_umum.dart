import 'package:flutter/material.dart';

class PengaturanUmumPage extends StatefulWidget {
  const PengaturanUmumPage({super.key});

  @override
  State<PengaturanUmumPage> createState() => _PengaturanUmumPageState();
}

class _PengaturanUmumPageState extends State<PengaturanUmumPage> {
  double _volume = 0.5;
  String _soundNotif = "Lite Bambu";
  String _getar = "Sedang";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pengaturan Umum")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Text("Volume Notifikasi"),
                Expanded(
                  child: Slider(
                    value: _volume,
                    onChanged: (val) => setState(() => _volume = val),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField(
              value: _soundNotif,
              items: ["Lite Bambu", "Klasik", "Modern"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => _soundNotif = val!),
              decoration: const InputDecoration(labelText: "Suara Notifikasi"),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField(
              value: _getar,
              items: ["Ringan", "Sedang", "Kuat"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => _getar = val!),
              decoration: const InputDecoration(labelText: "Getar"),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // simpan pengaturan
              },
              child: const Text("Simpan Perubahan"),
            )
          ],
        ),
      ),
    );
  }
}
