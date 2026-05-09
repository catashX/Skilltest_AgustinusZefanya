import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FormPage extends StatefulWidget {
  FormPage({super.key});

  @override
  State<FormPage> createState() => FormPageState();
}

class FormPageState extends State<FormPage> {
  final TextEditingController platController = TextEditingController();
  final TextEditingController kilometerController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Form Inspeksi Kendaraan")),
        body: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  FormTextWidget(
                    title: "Nomor Polisi",
                    controller: platController,
                    isRequired: true,
                  ),
                  SizedBox(height: 5.h),
                  FormTextWidget(
                    title: "Kilometer",
                    controller: kilometerController,
                    isRequired: true,
                  ),
                  SizedBox(height: 5.h),
                  FormTextWidget(title: "Alasan", controller: reasonController),
                  SizedBox(height: 5.h),
                  FormTextWidget(
                    title: "Notes",
                    controller: notesController,
                    isRequired: false,
                  ),
                  SizedBox(height: 5.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FormTextWidget extends StatelessWidget {
  const FormTextWidget({
    super.key,
    required this.title,
    required this.controller,
    this.isRequired = true,
  });

  final String title;
  final TextEditingController controller;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title),
        TextFormField(
          controller: controller,
          validator: (value) {
            if (value == null) return 'wajib diisi';
          },
        ),
      ],
    );
  }
}
