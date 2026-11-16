// Renders the native splash images from the in-app `BrandLogo` widget, so
// the launch screen shows exactly the logo of the home header.
//
// Outputs (transparent PNGs):
// * android/app/src/main/res/drawable-*dpi/splash_logo.png: the logo,
//   centred by `launch_background.xml` (all Android versions, and shown after
//   the Android 12+ system splash until Flutter's first frame).
// * android/app/src/main/res/drawable-*dpi/splash_icon.png: the logo centred
//   on a 288dp canvas, inside the 192dp circle that Android 12+ shows as
//   `windowSplashScreenAnimatedIcon`.
// * ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage{,@2x,@3x}.png
//
// It lives in tool/ so it is not part of the regular `flutter test` run.
// Regenerate (for example after replacing the logo) with:
//
//   flutter test tool/render_splash_images_test.dart
import 'dart:io';
import 'dart:ui' as ui;

import 'package:e_ramo_task/features/home/presentation/widgets/brand_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test/helpers/test_app.dart';

/// Logo height on the splash. The logo is then ~175dp wide and its bounding
/// box (diagonal ~181dp) fits the 192dp circle of the Android 12+ splash
/// icon. The same size is used everywhere so the logo does not jump between
/// the system splash, the launch background and the iOS launch screen.
const logoHeight = 48.0;

/// Canvas of an Android 12+ splash icon without an icon background.
const iconCanvas = 288.0;

const androidDensities = {
  'mdpi': 1.0,
  'hdpi': 1.5,
  'xhdpi': 2.0,
  'xxhdpi': 3.0,
  'xxxhdpi': 4.0,
};

const iosScales = {'': 1.0, '@2x': 2.0, '@3x': 3.0};

Future<void> _render(
  WidgetTester tester, {
  required Widget child,
  required double pixelRatio,
  required String path,
}) async {
  final boundaryKey = GlobalKey();
  await tester.pumpWidget(
    MediaQuery(
      data: const MediaQueryData(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Center(
          child: RepaintBoundary(key: boundaryKey, child: child),
        ),
      ),
    ),
  );
  // Give flutter_svg time to decode the mark.
  for (var i = 0; i < 6; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pump();
  }
  final boundary =
      boundaryKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  final bytes = await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: pixelRatio);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  });
  File(path)
    ..createSync(recursive: true)
    ..writeAsBytesSync(bytes!);
}

void main() {
  setUpAll(loadAppFonts);

  testWidgets('render native splash images', (tester) async {
    setScreenSize(tester, const Size(1200, 1200));
    // 2dp of air so no glyph touches (and is clipped at) the image edge.
    const logo = Padding(
      padding: EdgeInsets.all(2),
      child: BrandLogo(height: logoHeight),
    );
    const icon = SizedBox.square(
      dimension: iconCanvas,
      child: Center(child: logo),
    );

    for (final MapEntry(key: density, value: ratio)
        in androidDensities.entries) {
      final dir = 'android/app/src/main/res/drawable-$density';
      await _render(
        tester,
        child: logo,
        pixelRatio: ratio,
        path: '$dir/splash_logo.png',
      );
      await _render(
        tester,
        child: icon,
        pixelRatio: ratio,
        path: '$dir/splash_icon.png',
      );
    }
    for (final MapEntry(key: suffix, value: ratio) in iosScales.entries) {
      await _render(
        tester,
        child: logo,
        pixelRatio: ratio,
        path:
            'ios/Runner/Assets.xcassets/LaunchImage.imageset/'
            'LaunchImage$suffix.png',
      );
    }
  });
}
