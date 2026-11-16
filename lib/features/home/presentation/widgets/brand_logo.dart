import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_text_styles.dart';

/// "امتلك" brand logo: the teal square mark on the start (right) side and the
/// word mark with its tagline beside it.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.height = 26});

  static const name = 'امتلك';

  /// The word mark is drawn with a kashida after the meem ("امـــتلك").
  static const wordmark = 'امـــتلك';
  static const tagline = 'للتسويق العقاري';

  final double height;

  @override
  Widget build(BuildContext context) {
    final scale = height / 26;
    return Semantics(
      label: name,
      image: true,
      child: ExcludeSemantics(
        // Artwork: keep its proportions regardless of the text scale.
        child: MediaQuery.withNoTextScaling(
          child: SizedBox(
            height: height,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  AppAssets.logoMark,
                  width: height,
                  height: height,
                ),
                SizedBox(width: 3 * scale),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      wordmark,
                      style: AppTextStyles.logoWordmark.copyWith(
                        fontSize: 19.5 * scale,
                      ),
                    ),
                    Text(
                      tagline,
                      style: AppTextStyles.logoTagline.copyWith(
                        fontSize: 5.4 * scale,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
