import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class PengaturanAkunPage extends StatefulWidget {
  const PengaturanAkunPage({super.key});

  @override
  State<PengaturanAkunPage> createState() => _PengaturanAkunPageState();
}

class _PengaturanAkunPageState extends State<PengaturanAkunPage> {
  final Color ungu = Colors.deepPurple;

  // Data akun awal
  Map<String, dynamic> akunData = {
    "Nama": "Zidan Faderynich",
    "Email": "zidan.dev@gmail.com",
    "No HP": "+62 896 8980 6753",
    "Tanggal Lahir": DateTime(1995, 5, 20),
    "Jenis Kelamin": "Laki-laki",
    "Alamat": "Jalan Merdeka No. 45, Jember",
  };

  final Map<String, IconData> iconMap = {
    "Nama": Icons.person,
    "Email": Icons.email,
    "No HP": Icons.phone,
    "Tanggal Lahir": Icons.cake,
    "Jenis Kelamin": Icons.wc,
    "Alamat": Icons.location_on,
  };

  final List<String> genderOptions = ["Laki-laki", "Perempuan"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pengaturan Akun",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: ungu,
        centerTitle: true,
        elevation: 4,
        shadowColor: ungu.withOpacity(0.5),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              itemCount: akunData.length,
              separatorBuilder: (_, __) =>
                  Divider(color: ungu.withOpacity(0.15), thickness: 1),
              itemBuilder: (context, index) {
                String key = akunData.keys.elementAt(index);
                var value = akunData[key];
                String displayValue;

                if (value is DateTime) {
                  displayValue =
                      "${value.day.toString().padLeft(2, '0')}-${value.month.toString().padLeft(2, '0')}-${value.year}";
                } else {
                  displayValue = value.toString();
                }

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    iconMap[key] ?? Icons.info,
                    color: ungu,
                  ),
                  title: Text(
                    key,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: ungu,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      displayValue,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  trailing: Icon(Icons.edit, color: ungu),
                  onTap: () {
                    switch (key) {
                      case "Tanggal Lahir":
                        _pickDate(context, key, value as DateTime);
                        break;
                      case "Jenis Kelamin":
                        _pickGender(context, key, value.toString());
                        break;
                      default:
                        _showEditDialog(key, displayValue);
                    }
                  },
                );
              },
            ),
          ),
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

  void _pickDate(
      BuildContext context, String label, DateTime currentDate) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: "Pilih $label",
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ungu,
              onPrimary: Colors.white,
              onSurface: ungu,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: ungu),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        akunData[label] = pickedDate;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$label berhasil disimpan"),
          backgroundColor: ungu,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _pickGender(BuildContext context, String label, String currentGender) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: genderOptions.map((gender) {
            bool selected = gender == currentGender;
            return ListTile(
              title: Text(
                gender,
                style: TextStyle(
                  color: selected ? ungu : Colors.black87,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.normal,
                ),
              ),
              trailing: selected ? Icon(Icons.check, color: ungu) : null,
              onTap: () {
                setState(() {
                  akunData[label] = gender;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("$label berhasil disimpan"),
                    backgroundColor: ungu,
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }

  void _showEditDialog(String label, String currentValue) {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) {
        bool isButtonEnabled = currentValue.trim().isNotEmpty;

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              title: Text("Edit $label", style: TextStyle(color: ungu)),
              content: Form(
                key: formKey,
                child: TextFormField(
                  controller: controller,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "Masukkan $label",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: ungu, width: 2),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                  validator: (value) => _validateInput(label, value),
                  onChanged: (value) {
                    setStateDialog(() {
                      isButtonEnabled = value.trim().isNotEmpty;
                    });
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Batal", style: TextStyle(color: ungu)),
                ),
                ElevatedButton(
                  onPressed: isButtonEnabled
                      ? () {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              akunData[label] = controller.text.trim();
                            });
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("$label berhasil disimpan"),
                                backgroundColor: ungu,
                                behavior: SnackBarBehavior.floating,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                            );
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ungu,
                    disabledBackgroundColor: ungu.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    "Simpan",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String? _validateInput(String label, String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return "$label tidak boleh kosong";

    if (label == "Email" &&
        !RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(trimmed)) {
      return "Format email tidak valid";
    }
    if (label == "No HP" && !RegExp(r'^\+?[\d\s]+$').hasMatch(trimmed)) {
      return "Format nomor HP tidak valid";
    }

    return null;
  }
}
