import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medivora/pages/kalenderPage.dart';
import 'package:http/http.dart' as http;
import 'alarm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  String namaPasien = ''; // Variabel untuk nama pasien
  List<dynamic> alarms = []; // Menyimpan data alarm

  @override
  void initState() {
    super.initState();
    _loadUserData();  // Load nama pasien dari SharedPreferences
    _checkAlarmTime();
    _getAlarms();
  }

  // Fungsi untuk memuat nama pasien dari SharedPreferences
   void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      namaPasien = prefs.getString('nama_pasien') ?? 'Pasien'; // Default 'Pasien' jika data tidak ada
    });
  }
   // Fungsi untuk mengambil data alarm dari API
  Future<void> _getAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    String? idPasien = prefs.getString('id_pasien');

    if (idPasien != null) {
      final response = await http.get(Uri.parse(
          'http://127.0.0.1/medvora_api/get_alarms.php?id_pasien=$idPasien'));

      if (response.statusCode == 200) {
        setState(() {
          alarms = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load alarms');
      }
    }
  }
  void _checkAlarmTime() {
    DateTime now = DateTime.now();
    String currentTime = DateFormat.Hm().format(now); // format: "22.00"

    List<Map<String, String>> alarms = [
      {"waktu": "22.00", "obat": "Paracetamol"},
      {"waktu": "03.29", "obat": "Ambeven"},
    ];

    for (var alarm in alarms) {
      if (alarm["waktu"] == currentTime) {
        Future.delayed(Duration.zero, () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AlarmPage(
                namaObat: alarm["obat"]!,
                waktuAlarm: alarm["waktu"]!,
              ),
            ),
          );
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    int weekday = today.weekday;
    DateTime startOfWeek = today.subtract(Duration(days: weekday - 1));
    List<String> days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text("Hi $namaPasien!"), // Menggunakan nama pasien
        backgroundColor: Colors.white,
        elevation: 1,
        actions: const [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Good Morning",
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 10),

            // Kalender Mingguan
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const KalenderPage()),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF35315B), Color(0xFF8D84F3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            color: Colors.white, size: 20),
                        const SizedBox(width: 10),
                        Text(DateFormat('MMMM yyyy').format(today),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(7, (index) {
                        DateTime date = startOfWeek.add(Duration(days: index));
                        bool isToday = date.day == today.day &&
                            date.month == today.month &&
                            date.year == today.year;
                        return Column(
                          children: [
                            Text(days[index],
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14)),
                            const SizedBox(height: 3),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color:
                                    isToday ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text("${date.day}",
                                  style: TextStyle(
                                      color:
                                          isToday ? Colors.black : Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text("Completion Rate",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Stack(
              children: [
                Container(
                  height: 8,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Container(
                  height: 8,
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                    color: const Color(0xFF35315B),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Medication Alarm List (Menampilkan data alarm)
            const Text("Medication Alarm List", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 400,
              child: ListView.separated(
                itemCount: alarms.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  var alarm = alarms[index];
                  return GestureDetector(
                    onTap: () => showInformasiObatPopup(
                      context,
                      alarm['id_obat'],
                      alarm['takaran'],
                      alarm['waktu_minum'],
                      alarm['tanggal_mulai'],
                      alarm['instruksi'],
                      alarm['efek_samping'],
                      alarm['catatan'],
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 12),
                            child: Row(
                              children: const [
                                Icon(Icons.medication, size: 28, color: Colors.blue),
                                SizedBox(width: 4),
                                Icon(Icons.circle, size: 14, color: Colors.orange),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  alarm['id_obat'],
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    buildTag(alarm['takaran']),
                                    const SizedBox(width: 8),
                                    buildTag(alarm['waktu_minum']),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                                    const SizedBox(width: 6),
                                    Text(alarm['tanggal_mulai'], style: const TextStyle(fontSize: 13)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }

  void showInformasiObatPopup(
    BuildContext context,
    String nama,
    String dosis,
    String waktu,
    String tanggal,
    String instruksi,
    String efek,
    String catatan,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
              constraints: const BoxConstraints(maxHeight: 500),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Informasi Obat", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          buildInfoField("Nama Obat", nama),
                          buildInfoField("Dosis Obat", dosis),
                          buildInfoField("Waktu Minum/ Jadwal alarm", waktu),
                          buildInfoField("Tanggal", tanggal),
                          buildInfoField("Instruksi", instruksi),
                          buildInfoField("Efek Samping", efek),
                          buildInfoField("Catatan", catatan, maxLines: 2),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, size: 20, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoField(String label, String value, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          TextFormField(
            initialValue: value,
            readOnly: true,
            maxLines: maxLines,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              filled: true,
              fillColor: Colors.white,
              isDense: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0x00ffe0e0)),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
            ),
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}