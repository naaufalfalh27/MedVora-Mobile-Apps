import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:vibration/vibration.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class PengaturanUmumPage extends StatefulWidget {
  const PengaturanUmumPage({super.key});

  @override
  State<PengaturanUmumPage> createState() => _PengaturanUmumPageState();
}

class _PengaturanUmumPageState extends State<PengaturanUmumPage> {
  double _volume = 0.5;
  String _soundNotif = "Lite Bambu";
  String _getar = "Sedang";
  bool _notifAktif = true;

  final Color ungu = Colors.deepPurple;
  late AudioPlayer _audioPlayer;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final Map<String, String> _soundFiles = {
    "Lite Bambu": "assets/audio/lite_bambu.mp3",
    "Klasik": "assets/audio/klasik.mp3",
    "Modern": "assets/audio/modern.mp3",
  };

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initializeNotifications();
    tz.initializeTimeZones();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings =
        InitializationSettings(android: androidInit);
    await _flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  Future<void> _scheduleDailyNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'daily_notif_id',
      'Notifikasi Harian',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 8, 0, 0);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Waktunya Minum Obat',
      'Jangan lupa konsumsi obat hari ini!',
      scheduledDate,
      platformDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> _cancelNotification() async {
    await _flutterLocalNotificationsPlugin.cancel(0);
  }

  Future<void> _playSound() async {
    final soundPath = _soundFiles[_soundNotif];
    if (soundPath == null) return;

    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(soundPath), volume: _volume);
  }

  void _previewVibration(String level) async {
    int duration = 300;
    if (level == "Ringan") {
      duration = 100;
    } else if (level == "Sedang") {
      duration = 300;
    } else if (level == "Kuat") {
      duration = 600;
    }

    bool? hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator ?? false) {
      Vibration.vibrate(duration: duration);
    }

    Fluttertoast.showToast(
      msg: "Simulasi Getar: $level",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: ungu.withOpacity(0.8),
      textColor: Colors.white,
      fontSize: 14,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan Umum",
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
        backgroundColor: ungu,
        centerTitle: true,
        elevation: 4,
        shadowColor: ungu.withOpacity(0.4),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("🔔 Notifikasi Harian",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                const Text("Kelola pengingat harian untuk alarm obat Anda."),
                SwitchListTile(
                  title: Text("Aktifkan Notifikasi",
                      style: TextStyle(color: ungu)),
                  value: _notifAktif,
                  onChanged: (val) {
                    setState(() => _notifAktif = val);
                    if (val) {
                      _scheduleDailyNotification();
                    } else {
                      _cancelNotification();
                    }
                  },
                  activeColor: ungu,
                  contentPadding: EdgeInsets.zero,
                ),
                const Divider(height: 32),
                const Text("🔊 Volume Notifikasi",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                const Text("Atur seberapa keras suara notifikasi diputar."),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${(_volume * 100).round()}%",
                        style: const TextStyle(fontSize: 14))
                  ],
                ),
                Slider(
                  activeColor: ungu,
                  value: _volume,
                  onChanged: (val) {
                    setState(() => _volume = val);
                    _playSound();
                  },
                ),
                const Divider(height: 32),
                const Text("🎵 Suara Notifikasi",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                const Text(
                    "Pilih jenis suara yang akan diputar saat alarm berbunyi."),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _soundNotif,
                  iconEnabledColor: ungu,
                  iconDisabledColor: ungu,
                  items: _soundFiles.keys
                      .map((e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (val) {
                    if (val == null) return;
                    setState(() => _soundNotif = val);
                    _playSound();
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.music_note, color: ungu),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ungu),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const Divider(height: 32),
                const Text("📳 Getaran",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                const Text("Tentukan tingkat getar saat notifikasi berbunyi."),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _getar,
                  iconEnabledColor: ungu,
                  iconDisabledColor: ungu,
                  items: ["Ringan", "Sedang", "Kuat"]
                      .map((e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (val) {
                    if (val == null) return;
                    setState(() => _getar = val);
                    _previewVibration(val);
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.vibration, color: ungu),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ungu),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.question,
                      animType: AnimType.bottomSlide,
                      title: 'Konfirmasi',
                      desc: 'Apakah kamu yakin ingin menyimpan perubahan?',
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {
                        // Setelah user klik OK, tampilkan dialog sukses
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.scale,
                          title: 'Berhasil',
                          desc: 'Perubahan berhasil disimpan!',
                          btnOkOnPress: () {},
                        ).show();
                      },
                    ).show();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ungu,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    shadowColor: ungu.withOpacity(0.5),
                  ),
                  child: const Text(
                    "Simpan Perubahan",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
