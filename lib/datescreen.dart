import 'package:datepickerdemo/widget/custom_date_picker.dart';
import 'package:datepickerdemo/widget/date_picker_textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class DateScreen extends StatefulWidget {
  const DateScreen({super.key});

  @override
  State<DateScreen> createState() => _DateScreenState();
}

class _DateScreenState extends State<DateScreen> {
  TextEditingController dateCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Select Date"),
              ),
              const SizedBox(height: 10),
              DatePickerTextField(
                dateCtrl: dateCtrl,
                initialDate: DateTime.now(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
