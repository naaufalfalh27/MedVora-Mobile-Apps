import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class DaruratPage extends StatefulWidget {
  const DaruratPage({super.key});

  @override
  State<DaruratPage> createState() => _DaruratPageState();
}

class _DaruratPageState extends State<DaruratPage> {
  LatLng? _currentPosition;
  bool _loading = true;
  List<Marker> _hospitalMarkers = [];
  List<Map<String, dynamic>> _hospitalList = [];
  String _waNumber = '';
  String _waName = '';
  String _waMessage = '';

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aktifkan lokasi terlebih dahulu')),
      );
      setState(() => _loading = false);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Izin lokasi ditolak')),
        );
        setState(() => _loading = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Izin lokasi ditolak permanen')),
      );
      setState(() => _loading = false);
      return;
    }

    Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(pos.latitude, pos.longitude);
      _loading = false;
    });
  }

  Future<void> _callEmergency() async {
    final Uri telUri = Uri(scheme: 'tel', path: '112');
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat melakukan panggilan')),
      );
    }
  }

  Future<void> _chatWhatsApp() async {
    if (_waNumber.isEmpty || _waMessage.isEmpty || _currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi data darurat terlebih dahulu')),
      );
      return;
    }

    final String locationUrl = 'https://www.google.com/maps?q=${_currentPosition!.latitude},${_currentPosition!.longitude}';
    final String fullMessage = '$_waMessage\n\nLokasi saat ini: $locationUrl';

    final Uri waUri = Uri.parse('https://wa.me/$_waNumber?text=${Uri.encodeComponent(fullMessage)}');
    if (await canLaunchUrl(waUri)) {
      await launchUrl(waUri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('WhatsApp tidak dapat dibuka')),
      );
    }
  }

  void _editEmergencyContact() {
    final nameController = TextEditingController(text: _waName);
    final numberController = TextEditingController(text: _waNumber);
    final messageController = TextEditingController(text: _waMessage);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Kontak Darurat'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nama Penerima')),
              TextField(controller: numberController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Nomor WhatsApp')),
              TextField(controller: messageController, maxLines: 3, decoration: const InputDecoration(labelText: 'Pesan Darurat')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _waName = nameController.text.trim();
                _waNumber = numberController.text.trim();
                _waMessage = messageController.text.trim();
              });
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Future<void> _findNearbyHospitals() async {
    if (_currentPosition == null) return;
    final lat = _currentPosition!.latitude;
    final lon = _currentPosition!.longitude;
    final overpassUrl = 'https://overpass-api.de/api/interpreter?data=[out:json];node(around:3000,$lat,$lon)[amenity=hospital];out;';

    try {
      final response = await http.get(Uri.parse(overpassUrl));
      final data = jsonDecode(response.body)['elements'];

      setState(() {
        _hospitalList = [];
        _hospitalMarkers = data.map<Marker>((item) {
          final double lat = item['lat'];
          final double lon = item['lon'];
          final Map tags = item['tags'] ?? {};
          final String name = tags['name'] ?? 'Rumah Sakit';
          final String? address = tags['addr:full'] ?? tags['addr:street'];
          final String? phone = tags['phone'];

          _hospitalList.add({
            'name': name,
            'lat': lat,
            'lon': lon,
            'address': address,
            'phone': phone,
          });

          return Marker(
            width: 40,
            height: 40,
            point: LatLng(lat, lon),
            child: const Icon(Icons.local_hospital, color: Colors.blue, size: 40),
          );
        }).toList();
      });

      _showHospitalListDialog();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal mengambil data rumah sakit')));
    }
  }

  void _showHospitalListDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rumah Sakit Terdekat'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (_, __) => const Divider(),
            itemCount: _hospitalList.length,
            itemBuilder: (context, index) {
              final hospital = _hospitalList[index];
              return ListTile(
                title: Text(hospital['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hospital['address'] != null) Text(hospital['address']),
                    if (hospital['phone'] != null) Text('Telp: ${hospital['phone']}'),
                  ],
                ),
                trailing: const Icon(Icons.directions, color: Colors.blue),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToLocation(hospital['lat'], hospital['lon']);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup')),
        ],
      ),
    );
  }

  void _navigateToLocation(double lat, double lon) async {
    if (_currentPosition == null) return;
    final userLat = _currentPosition!.latitude;
    final userLon = _currentPosition!.longitude;
    final Uri googleMapsUrl = Uri.parse('https://www.google.com/maps/dir/?api=1&origin=$userLat,$userLon&destination=$lat,$lon&travelmode=driving');

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tidak dapat membuka Google Maps')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _currentPosition == null
              ? const Center(child: Text('Gagal mendapatkan lokasi'))
              : Stack(
                  children: [
                    FlutterMap(
                      options: MapOptions(center: _currentPosition, zoom: 16.0),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: _currentPosition!,
                              width: 40,
                              height: 40,
                              child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
                            ),
                            ..._hospitalMarkers,
                          ],
                        ),
                      ],
                    ),
                    SafeArea(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: ElevatedButton.icon(
                            onPressed: _callEmergency,
                            icon: const Icon(Icons.call, color: Colors.white),
                            label: const Text('Telpon Darurat'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16.0, right: 16.0),
                          child: ElevatedButton(
                            onPressed: _editEmergencyContact,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                              shape: const CircleBorder(),
                            ),
                            child: Image.asset('assets/images/pen.png', width: 38, height: 38),
                          ),
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                onPressed: _findNearbyHospitals,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: const CircleBorder(),
                                  elevation: 4,
                                ),
                                child: const Icon(Icons.local_hospital, color: Colors.blue, size: 32),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: _chatWhatsApp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: EdgeInsets.zero,
                                  shape: const CircleBorder(),
                                ),
                                child: Image.asset('assets/images/logo_wa.png', width: 56, height: 56),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
