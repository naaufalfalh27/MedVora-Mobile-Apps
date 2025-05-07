import 'package:flutter/material.dart';

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> alarmList = [
      {
        "month": "Januari 2025",
        "data": [
          {"name": "Paracetamol", "time": "18.00", "status": "Selesai"},
          {"name": "Paracetamol", "time": "09.00", "status": "Selesai"},
        ]
      },
      {
        "month": "Desember 2024",
        "data": [
          {"name": "Paracetamol", "time": "09.00", "status": "Selesai"},
          {"name": "Paracetamol", "time": "09.00", "status": "Terlambat"},
          {"name": "Paracetamol", "time": "09.00", "status": "Terlambat"},
        ]
      },
      {
        "month": "November 2024",
        "data": [
          {"name": "Paracetamol", "time": "09.00", "status": "Selesai"},
        ]
      },
    ];

    Color getStatusColor(String status) {
      return status == "Selesai" ? Colors.purpleAccent : Colors.pinkAccent;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF8E6CEF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Riwayat Alarm",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search",
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(Icons.search),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.tune, color: Color(0xFF6C63FF)),
                      )
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: alarmList.length,
                itemBuilder: (context, i) {
                  final month = alarmList[i]["month"];
                  final alarms = alarmList[i]["data"] as List;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        month,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...alarms.map((alarm) {
                        final status = alarm["status"];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              )
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    alarm["name"],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    alarm["time"],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    "Rabu, 9 Januari 2025",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 12),
                                decoration: BoxDecoration(
                                  color:
                                      getStatusColor(status).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    color: getStatusColor(status),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF3B2F6B),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        currentIndex: 2,
        onTap: (index) {
          // Navigasi berdasarkan index
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.warning), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        ],
      ),
    );
  }
}
