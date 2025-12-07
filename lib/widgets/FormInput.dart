import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormInput extends StatelessWidget {
  const FormInput({
    super.key,
    this.initialValue,
    required this.onSaved,
    required this.label,
    required this.iconData,
    this.validator,
    this.maxLines = 1,
    this.readOnly = false,
    this.textInputType,
    this.inputFormatters,
    this.controller,
  });

  final bool readOnly;
  final String? initialValue;
  final String label;
  final IconData iconData;
  final int maxLines;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;

  final void Function(String? value) onSaved;
  final String? Function(String? value)? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        inputFormatters: inputFormatters,
        keyboardType: textInputType,
        initialValue: controller != null ? null : initialValue,
        maxLines: maxLines,
        readOnly: readOnly,
        controller: controller,
        minLines: 1,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey, width: 1),
          ),
          labelText: label,
          hintText: "请输入$label",
          prefixIcon: Icon(iconData, size: 18),
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
