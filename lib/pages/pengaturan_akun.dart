import 'package:flutter/material.dart';

class PengaturanAkunPage extends StatelessWidget {
  const PengaturanAkunPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pengaturan Akun")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildEditableField(context, "Nama", "Zidan Faderynich"),
          const SizedBox(height: 12),
          _buildEditableField(context, "Email", "zidan.dev@gmail.com"),
          const SizedBox(height: 12),
          _buildEditableField(context, "No HP", "+62 896 8980 6753"),
        ],
      ),
    );
  }

  Widget _buildEditableField(BuildContext context, String label, String value) {
    return ListTile(
      title: Text(label),
      subtitle: Text(value),
      trailing: const Icon(Icons.edit),
      onTap: () {
        showDialog(
          context: context,
          builder: (_) {
            final controller = TextEditingController(text: value);
            return AlertDialog(
              title: Text("Edit $label"),
              content: TextField(controller: controller),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Batal")),
                ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Simpan")),
              ],
            );
          },
        );
      },
    );
  }
}
