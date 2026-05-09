import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nss_skilltest/src/features/form/presentations/bloc/form_bloc.dart';
import 'package:nss_skilltest/src/features/form/presentations/bloc/form_event_state.dart';
import 'package:nss_skilltest/src/features/form/utils/camera_utils.dart';
import 'package:signature/signature.dart';
import 'package:path_provider/path_provider.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class FormPage extends StatefulWidget {
  FormPage({super.key});

  @override
  State<FormPage> createState() => FormPageState();
}

class FormPageState extends State<FormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController platController;
  late TextEditingController kilometerController;
  late TextEditingController locationController;
  late TextEditingController reasonController;
  late TextEditingController notesController;

  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    final state = context.read<FormBloc>().state;
    platController = TextEditingController(text: state.licensePlate);
    kilometerController = TextEditingController(text: state.mileage);
    locationController = TextEditingController(text: state.address);
    reasonController = TextEditingController(text: state.reason);
    notesController = TextEditingController(text: state.notes);

    _getLocation();
  }

  void _getLocation() async {
    if (locationController.text.isNotEmpty) return;
    try {
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.whileInUse || perm == LocationPermission.always) {
        var pos = await Geolocator.getCurrentPosition();
        var places = await placemarkFromCoordinates(pos.latitude, pos.longitude);
        var p = places[0];
        locationController.text = "${p.street}, ${p.subLocality}, ${p.locality}";
        _saveState();
      }
    } catch (e) {
      print(e);
    }
  }

  void _saveState() {
    context.read<FormBloc>().add(
      FormUpdated(
        licensePlate: platController.text,
        mileage: kilometerController.text,
        reason: reasonController.text,
        notes: notesController.text,
        address: locationController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormBloc, InspectionFormState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(title: const Text("Form Inspeksi Kendaraan")),
            body: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextFormField(
                        "Nomor Polisi",
                        platController,
                        hint: "Contoh: B 1234 ABC",
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Wajib diisi';
                          // Simple regex for indonesian plate (1-2 letters, 1-4 numbers, 1-3 letters)
                          final regex = RegExp(
                            r"^[A-Z]{1,2}\s\d{1,4}\s[A-Z]{1,3}$",
                          );
                          if (!regex.hasMatch(value.toUpperCase()))
                            return 'Format plat nomor salah';
                          return null;
                        },
                      ),

                      const SizedBox(height: 10),
                      const Text(
                        "Foto Kendaraan",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _buildPhotoPicker(
                            "Depan",
                            state.photoFrontPath,
                            (path) => context.read<FormBloc>().add(
                              FormUpdated(photoFrontPath: path),
                            ),
                          ),
                          _buildPhotoPicker(
                            "Belakang",
                            state.photoBackPath,
                            (path) => context.read<FormBloc>().add(
                              FormUpdated(photoBackPath: path),
                            ),
                          ),
                          _buildPhotoPicker(
                            "Kiri",
                            state.photoLeftPath,
                            (path) => context.read<FormBloc>().add(
                              FormUpdated(photoLeftPath: path),
                            ),
                          ),
                          _buildPhotoPicker(
                            "Kanan",
                            state.photoRightPath,
                            (path) => context.read<FormBloc>().add(
                              FormUpdated(photoRightPath: path),
                            ),
                          ),
                          _buildPhotoPicker(
                            "Speedometer",
                            state.photoSpeedometerPath,
                            (path) => context.read<FormBloc>().add(
                              FormUpdated(photoSpeedometerPath: path),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),
                      const Text("Kondisi Eksterior"),
                      DropdownButtonFormField<String>(
                        value: state.exteriorCondition,
                        items: ['Baik', 'Lecet Ringan', 'Rusak', 'Sangat Rusak']
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (val) => context.read<FormBloc>().add(
                          FormUpdated(exteriorCondition: val),
                        ),
                      ),

                      const SizedBox(height: 15),
                      const Text("Kondisi Mesin"),
                      DropdownButtonFormField<String>(
                        value: state.engineCondition,
                        items: ['Hidup Normal', 'Hidup Tidak Normal', 'Mati']
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (val) => context.read<FormBloc>().add(
                          FormUpdated(engineCondition: val),
                        ),
                      ),

                      const SizedBox(height: 15),
                      _buildTextFormField(
                        "Kilometer Saat Ini",
                        kilometerController,
                        isNumber: true,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Wajib diisi';
                          final numValue = int.tryParse(value);
                          if (numValue == null || numValue <= 0)
                            return 'Kilometer harus lebih dari 0';
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),
                      _buildTextFormField(
                        "Lokasi Kendaraan Ditemukan",
                        locationController,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Wajib diisi'
                            : null,
                      ),

                      const SizedBox(height: 15),
                      const Text("Kendaraan Bisa Dipindahkan?"),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<bool>(
                              title: const Text("Ya"),
                              value: true,
                              groupValue: state.isMoveable,
                              onChanged: (val) => context.read<FormBloc>().add(
                                FormUpdated(isMoveable: val),
                              ),
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<bool>(
                              title: const Text("Tidak"),
                              value: false,
                              groupValue: state.isMoveable,
                              onChanged: (val) => context.read<FormBloc>().add(
                                FormUpdated(isMoveable: val),
                              ),
                            ),
                          ),
                        ],
                      ),

                      if (state.isMoveable == false) ...[
                        const SizedBox(height: 10),
                        _buildTextFormField(
                          "Alasan Tidak Bisa Dipindahkan",
                          reasonController,
                          validator: (value) {
                            if (state.isMoveable == false) {
                              if (value == null || value.isEmpty)
                                return 'Wajib diisi';
                              if (value.length < 30)
                                return 'Minimal 30 karakter';
                            }
                            return null;
                          },
                        ),
                      ],

                      const SizedBox(height: 15),
                      _buildTextFormField(
                        "Catatan Tambahan (Opsional)",
                        notesController,
                        isRequired: false,
                      ),

                      const SizedBox(height: 15),
                      const Text(
                        "Tanda Tangan Digital",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Signature(
                          controller: _signatureController,
                          height: 150,
                          backgroundColor: Colors.grey[200]!,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => _signatureController.clear(),
                            child: const Text("Clear"),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => _submit(state),
                          child: const Text("Submit"),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextFormField(
    String title,
    TextEditingController controller, {
    bool isRequired = true,
    bool isNumber = false,
    String? hint,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$title${isRequired ? ' *' : ''}"),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
            isDense: true,
          ),
          onChanged: (_) => _saveState(),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildPhotoPicker(
    String label,
    String? currentPath,
    Function(String) onPicked,
  ) {
    return InkWell(
      onTap: () async {
        final file = await CameraUtils.takePhotoWithWatermark();
        if (file != null) {
          onPicked(file.path);
        }
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: currentPath != null && currentPath.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(File(currentPath), fit: BoxFit.cover),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.camera_alt),
                  Text(label, style: const TextStyle(fontSize: 12)),
                ],
              ),
      ),
    );
  }

  Future<void> _submit(InspectionFormState state) async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cek form lagi")),
      );
      return;
    }
    
    if (state.photoFrontPath == null ||
        state.photoBackPath == null ||
        state.photoLeftPath == null ||
        state.photoRightPath == null ||
        state.photoSpeedometerPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("5 foto wajib ada")),
      );
      return;
    }
    
    if (state.isMoveable == null || _signatureController.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi data")),
      );
      return;
    }

    final bytes = await _signatureController.toPngBytes();
    if (bytes != null) {
      final dir = await getTemporaryDirectory();
      final f = File('${dir.path}/ttd.png');
      await f.writeAsBytes(bytes);
      context.read<FormBloc>().add(FormUpdated(signaturePath: f.path));
    }

    if (mounted) {
      showDialog(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text("Berhasil"),
          content: const Text("Data tersimpan"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }
}
