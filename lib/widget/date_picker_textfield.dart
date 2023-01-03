import 'package:datepickerdemo/widget/custom_date_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class DatePickerTextField extends StatefulWidget {
  const DatePickerTextField(
      {super.key,
      required this.dateCtrl,
      this.activeColor,
      this.fillColor,
      this.validator,
      required this.initialDate,
      this.startYear,
      this.endYear});
  final TextEditingController dateCtrl;
  final Color? activeColor;
  final Color? fillColor;
  final DateTime initialDate;
  final DateTime? startYear;
  final DateTime? endYear;
  final String? Function(String?)? validator;
  @override
  State<DatePickerTextField> createState() => _DatePickerTextFieldState();
}

class _DatePickerTextFieldState extends State<DatePickerTextField> {
  bool datePickerActive = false;
  DateTime? selectedDate;
  MaskTextInputFormatter dateMask = MaskTextInputFormatter(mask: "##/##/####");
  TextEditingController dateCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double widgetWidth = 300; // For Normal Web App on PC
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      widgetWidth = MediaQuery.of(context).size.width;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: dateCtrl,
          inputFormatters: [dateMask],
          validator: widget.validator,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            hintText: "dd/mm/yyyy",
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent, width: 0.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: widget.activeColor ?? Colors.black, width: 0.5),
            ),
            fillColor:
                widget.fillColor ?? const Color.fromARGB(255, 242, 242, 242),
            filled: true,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  FocusScope.of(context).unfocus();
                  datePickerActive = !datePickerActive;
                });
              },
              icon: Icon(
                Icons.calendar_month_outlined,
                color: widget.activeColor ?? Colors.black,
              ),
            ),
          ),
        ),
        if (datePickerActive)
          Container(
            alignment: Alignment.topRight,
            constraints: BoxConstraints(
              maxHeight: kIsWeb ? 400 : double.infinity,
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: FittedBox(
              child: CustomDatePicker(
                widgetWidth: widgetWidth,
                initialDate: widget.initialDate,
                startYear: widget.startYear,
                endYear: widget.endYear,
                cancel: () {
                  setState(() {
                    datePickerActive = false;
                  });
                },
                ok: (DateTime? returnedDate) {
                  if (returnedDate == null) return;
                  setState(
                    () {
                      selectedDate = returnedDate;
                      String oldText = dateCtrl.text;
                      dateCtrl.text =
                          DateFormat("dd/MM/yyyy").format(selectedDate!);
                      dateMask.formatEditUpdate(
                        TextEditingValue(text: oldText),
                        TextEditingValue(
                          text: dateCtrl.text,
                        ),
                      );
                      datePickerActive = false;
                    },
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
