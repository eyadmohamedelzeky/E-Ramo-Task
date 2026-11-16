// Renders the launcher icons from the "امتلك" logo mark
// (assets/icons/logo_mark.svg): the teal tile with the white glyph. The word
// mark is left out on purpose; it is unreadable at launcher-icon sizes.
//
// Outputs:
// * android/app/src/main/res/mipmap-*dpi/ic_launcher.png: legacy icon (the
//   rounded tile, 44dp on the 48dp canvas), used below Android 8.
// * android/app/src/main/res/mipmap-*dpi/ic_launcher_foreground.png: the
//   white glyph on a transparent 108dp adaptive-icon layer (Android 8+). The
//   teal background is @color/ic_launcher_background, and the same layer is
//   the Android 13+ monochrome (themed) icon. See
//   mipmap-anydpi-v26/ic_launcher.xml.
// * ios/Runner/Assets.xcassets/AppIcon.appiconset/*.png: full-bleed opaque
//   squares (iOS applies its own corner mask), written without an alpha
//   channel as the App Store requires.
//
// It lives in tool/ so it is not part of the regular `flutter test` run.
// Regenerate with:
//
//   flutter test tool/render_app_icons_test.dart
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test/helpers/test_app.dart';

const markPath = 'assets/icons/logo_mark.svg';
const androidRes = 'android/app/src/main/res';
const iosIconSet = 'ios/Runner/Assets.xcassets/AppIcon.appiconset';

const androidDensities = {
  'mdpi': 1.0,
  'hdpi': 1.5,
  'xhdpi': 2.0,
  'xxhdpi': 3.0,
  'xxxhdpi': 4.0,
};

/// The logo mark as drawn in the app header (rounded teal tile + glyph).
String markSvg() => File(markPath).readAsStringSync();

/// Only the white glyph: the tile is dropped (adaptive foreground layer).
String glyphSvg() => markSvg().replaceFirst(RegExp(r'<rect[^>]*/>'), '');

/// Square tile without rounded corners (iOS rounds the icon itself).
String fullBleedSvg() => markSvg().replaceFirst('rx="5"', 'rx="0"');

/// Renders [svg] at [artSize] centred on a [canvas]-sized square, at 1 logical
/// pixel per output pixel, and returns the RGBA image.
Future<ui.Image> _render(
  WidgetTester tester, {
  required String svg,
  required double canvas,
  required double artSize,
}) async {
  final boundaryKey = GlobalKey();
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: Align(
        alignment: Alignment.topLeft,
        child: RepaintBoundary(
          key: boundaryKey,
          child: SizedBox.square(
            dimension: canvas,
            child: Center(
              child: SvgPicture.string(svg, width: artSize, height: artSize),
            ),
          ),
        ),
      ),
    ),
  );
  // Give flutter_svg time to parse and decode the picture.
  for (var i = 0; i < 6; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 40)),
    );
    await tester.pump();
  }
  final boundary =
      boundaryKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  return (await tester.runAsync(() => boundary.toImage()))!;
}

Future<void> _writeRgbaPng(WidgetTester tester, ui.Image image, String path) =>
    tester
        .runAsync(() async {
          final data = await image.toByteData(format: ui.ImageByteFormat.png);
          File(path)
            ..createSync(recursive: true)
            ..writeAsBytesSync(data!.buffer.asUint8List());
        })
        .then((_) {});

/// Writes an opaque truecolour PNG (colour type 2, no alpha channel).
Future<void> _writeRgbPng(
  WidgetTester tester,
  ui.Image image,
  String path,
) => tester
    .runAsync(() async {
      final raw = (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!;
      final w = image.width, h = image.height;
      final rows = BytesBuilder();
      for (var y = 0; y < h; y++) {
        rows.addByte(0); // filter: none
        for (var x = 0; x < w; x++) {
          final i = (y * w + x) * 4;
          rows.add([raw.getUint8(i), raw.getUint8(i + 1), raw.getUint8(i + 2)]);
        }
      }
      final header = ByteData(13)
        ..setUint32(0, w)
        ..setUint32(4, h)
        ..setUint8(8, 8) // bit depth
        ..setUint8(9, 2) // colour type: RGB
        ..setUint8(10, 0)
        ..setUint8(11, 0)
        ..setUint8(12, 0);
      final png = BytesBuilder()
        ..add(const [137, 80, 78, 71, 13, 10, 26, 10])
        ..add(_chunk('IHDR', header.buffer.asUint8List()))
        ..add(_chunk('IDAT', zlib.encode(rows.takeBytes())))
        ..add(_chunk('IEND', const []));
      File(path)
        ..createSync(recursive: true)
        ..writeAsBytesSync(png.takeBytes());
    })
    .then((_) {});

List<int> _chunk(String type, List<int> data) {
  final typeBytes = ascii.encode(type);
  final out = ByteData(8 + data.length + 4);
  out.setUint32(0, data.length);
  final bytes = out.buffer.asUint8List()
    ..setRange(4, 8, typeBytes)
    ..setRange(8, 8 + data.length, data);
  out.setUint32(8 + data.length, _crc32([...typeBytes, ...data]));
  return bytes;
}

final List<int> _crcTable = List<int>.generate(256, (n) {
  var c = n;
  for (var k = 0; k < 8; k++) {
    c = (c & 1) != 0 ? 0xEDB88320 ^ (c >> 1) : c >> 1;
  }
  return c;
});

int _crc32(List<int> bytes) {
  var crc = 0xFFFFFFFF;
  for (final b in bytes) {
    crc = _crcTable[(crc ^ b) & 0xFF] ^ (crc >> 8);
  }
  return (crc ^ 0xFFFFFFFF) & 0xFFFFFFFF;
}

void main() {
  setUpAll(loadAppFonts);

  testWidgets('render launcher icons', (tester) async {
    setScreenSize(tester, const Size(1200, 1200));

    for (final MapEntry(key: density, value: d) in androidDensities.entries) {
      final dir = '$androidRes/mipmap-$density';
      // Legacy: the rounded tile with 2dp of margin on a 48dp canvas.
      await _writeRgbaPng(
        tester,
        await _render(tester, svg: markSvg(), canvas: 48 * d, artSize: 44 * d),
        '$dir/ic_launcher.png',
      );
      // Adaptive foreground: the glyph sized as if the tile filled the 72dp
      // visible area of the 108dp layer, i.e. well inside the 66dp safe zone.
      await _writeRgbaPng(
        tester,
        await _render(
          tester,
          svg: glyphSvg(),
          canvas: 108 * d,
          artSize: 72 * d,
        ),
        '$dir/ic_launcher_foreground.png',
      );
    }

    final contents =
        jsonDecode(File('$iosIconSet/Contents.json').readAsStringSync())
            as Map<String, dynamic>;
    for (final entry in (contents['images'] as List).cast<Map>()) {
      final points = double.parse((entry['size'] as String).split('x').first);
      final scale = double.parse(
        (entry['scale'] as String).replaceAll('x', ''),
      );
      final pixels = (points * scale).roundToDouble();
      await _writeRgbPng(
        tester,
        await _render(
          tester,
          svg: fullBleedSvg(),
          canvas: pixels,
          artSize: pixels,
        ),
        '$iosIconSet/${entry['filename']}',
      );
    }
  });
}
