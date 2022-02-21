// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_fonts/google_fonts.dart';

// Project imports:
import 'package:network_arch/constants.dart';

class HexBytesViewer extends StatelessWidget {
  const HexBytesViewer({
    required this.title,
    required this.bytes,
    Key? key,
  }) : super(key: key);

  final String title;
  final List<int> bytes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(title),
          ),
          const SizedBox(height: 10),
          Card(
            color: Constants.getPlatformBgColor(context),
            margin: EdgeInsets.zero,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
          ),
        ],
      ),
    );
  }
}
