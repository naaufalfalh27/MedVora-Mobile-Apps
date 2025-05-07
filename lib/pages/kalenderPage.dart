import 'package:flutter/material.dart';

class KalenderPage extends StatelessWidget {
  const KalenderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: const Color(0xFF35315B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Kalender", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Feb 2025',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          TableCalendarWidget(),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Legend(color: Colors.green, label: 'Selesai'),
                Legend(color: Colors.orange, label: 'Sebagian'),
                Legend(color: Colors.red, label: 'Belum'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TableCalendarWidget extends StatelessWidget {
  const TableCalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Tambahkan kalender dengan tanggal dummy
    return CalendarDatePicker(
      initialDate: DateTime(2025, 2, 1),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      onDateChanged: (date) {
        // Tindakan saat tanggal diklik
      },
    );
  }
}

class Legend extends StatelessWidget {
  final Color color;
  final String label;

  const Legend({required this.color, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(backgroundColor: color, radius: 6),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}
