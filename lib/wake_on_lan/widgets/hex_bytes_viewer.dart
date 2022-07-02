// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_fonts/google_fonts.dart';

// Project imports:
import 'package:network_arch/theme/themes.dart';

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
              : Themes.iOSOnboardingBgColor.resolveFrom(context),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(8),
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
                        style: GoogleFonts.sourceCodePro(
                          // On android, this makes no difference
                          color: Themes.iOStextColor.resolveFrom(context),
                        ),
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
                          style: GoogleFonts.sourceCodePro(
                            color: Themes.iOStextColor.resolveFrom(context),
                          ),
                        )
                      else
                        Text(
                          '.',
                          style: GoogleFonts.sourceCodePro(
                            color: Themes.iOStextColor.resolveFrom(context),
                          ),
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
