// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_fonts/google_fonts.dart';

// Project imports:
import 'package:network_arch/shared/shared.dart';

class HexBytesViewer extends StatelessWidget {
  const HexBytesViewer({
    required this.bytes,
    this.title,
    super.key,
  });

  final List<int> bytes;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (title != null) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(title!),
          ),
          const SizedBox(height: 10),
        ],
        DataCard(
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 16,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: [
                  for (final byte in bytes)
                    Text(
                      byte.toRadixString(16).padLeft(2, '0'),
                      style: GoogleFonts.sourceCodePro(),
                    ),
                ],
              ),
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 16,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: [
                  for (final byte in bytes)
                    if (byte < 128)
                      Text(
                        String.fromCharCode(byte),
                        style: GoogleFonts.sourceCodePro(),
                      )
                    else
                      Text(
                        '.',
                        style: GoogleFonts.sourceCodePro(),
                      ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
