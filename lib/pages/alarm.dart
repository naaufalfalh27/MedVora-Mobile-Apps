import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AlarmPage extends StatefulWidget {
  final String namaObat;
  final String waktuAlarm;

  const AlarmPage({
    super.key,
    required this.namaObat,
    required this.waktuAlarm,
  });

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isAlarmActive = true;

  @override
  void initState() {
    super.initState();
    _playAlarm();
  }

  void _playAlarm() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource('alarm.mp3'));
  }

  void _stopAlarm() async {
    await _audioPlayer.stop();
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.alarm, size: 80),
                const SizedBox(height: 16),
                const Text("Saatnya minum obat",
                    style: TextStyle(fontSize: 16)),
                Text(
                  widget.waktuAlarm,
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold),
                ),
                Text(widget.namaObat),
                const SizedBox(height: 40),
                SwitchListTile(
                  value: !isAlarmActive,
                  onChanged: (val) {
                    setState(() {
                      isAlarmActive = false;
                      _stopAlarm();
                    });
                  },
                  title: const Text("Matikan Alarm",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  secondary: const Icon(Icons.volume_up),
                ),
                const SizedBox(height: 16),
                const Text("© 2025 MediVora. Semua Hak Dilindungi.",
                    style: TextStyle(fontSize: 10)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
