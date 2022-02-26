// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:network_arch/shared/shared.dart';

class DomainTextField extends StatelessWidget {
  const DomainTextField({
    required this.controller,
    required this.label,
    this.enabled,
    this.errorText,
    this.keyboardType,
    this.suffixIcon,
    this.withoutPrefixIcon = false,
    this.onChanged,
    Key? key,
  }) : super(key: key);

  final TextEditingController controller;
  final String label;
  final bool? enabled;
  final String? errorText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final bool withoutPrefixIcon;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: (context) {
        return TextField(
          autocorrect: false,
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            errorText: errorText,
            labelText: label,
            prefixIcon: withoutPrefixIcon ? null : const Icon(Icons.language),
            suffixIcon: suffixIcon,
          ),
          onChanged: onChanged,
        );
      },
      iosBuilder: (context) {
        return CupertinoTextField(
          autocorrect: false,
          controller: controller,
          placeholder: label,
          enabled: enabled,
          suffix: suffixIcon,
          onChanged: onChanged,
        );
      },
    );
  }
}
