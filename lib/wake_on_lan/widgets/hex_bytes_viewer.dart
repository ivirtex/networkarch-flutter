// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_fonts/google_fonts.dart';

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
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(title),
        ),
        const SizedBox(height: 10),
        Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Theme.of(context).platform != TargetPlatform.iOS
              ? Color.alphaBlend(
                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  Theme.of(context).colorScheme.surfaceVariant,
                )
              : CupertinoDynamicColor.resolve(
                  CupertinoColors.systemGrey6,
                  context,
                ),
          elevation: 0.0,
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
    );
  }
}
