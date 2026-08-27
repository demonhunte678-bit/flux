import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconThemeInfo {
  final String name;
  final Color primary;
  final Color color1;
  final Color color2;

  const IconThemeInfo({
    required this.name,
    required this.primary,
    required this.color1,
    required this.color2,
  });
}

const List<IconThemeInfo> iconThemes = [
  IconThemeInfo(
    name: 'emerald',
    primary: Color(0xFF1DB954),
    color1: Color(0xFF3DE372),
    color2: Color(0xFF117032),
  ),
  IconThemeInfo(
    name: 'azure',
    primary: Color(0xFF2196F3),
    color1: Color(0xFF64B5F6),
    color2: Color(0xFF1565C0),
  ),
  IconThemeInfo(
    name: 'violet',
    primary: Color(0xFF9C27B0),
    color1: Color(0xFFBA68C8),
    color2: Color(0xFF6A1B9A),
  ),
  IconThemeInfo(
    name: 'sunset',
    primary: Color(0xFFFF9800),
    color1: Color(0xFFFFB74D),
    color2: Color(0xFFE65100),
  ),
  IconThemeInfo(
    name: 'ruby',
    primary: Color(0xFFF44336),
    color1: Color(0xFFE57373),
    color2: Color(0xFFC62828),
  ),
  IconThemeInfo(
    name: 'amber',
    primary: Color(0xFFFFC107),
    color1: Color(0xFFFFE082),
    color2: Color(0xFFFF8F00),
  ),
  IconThemeInfo(
    name: 'graphite',
    primary: Color(0xFF4A4A4A),
    color1: Color(0xFF8E8E93),
    color2: Color(0xFF1C1C1E),
  ),
  IconThemeInfo(
    name: 'blossom',
    primary: Color(0xFFE91E63),
    color1: Color(0xFFF06292),
    color2: Color(0xFFAD1457),
  ),
];

const Map<String, Map<String, double>> densities = {
  'mdpi': {'legacy': 48, 'adaptive': 108},
  'hdpi': {'legacy': 72, 'adaptive': 162},
  'xhdpi': {'legacy': 96, 'adaptive': 216},
  'xxhdpi': {'legacy': 144, 'adaptive': 324},
  'xxxhdpi': {'legacy': 192, 'adaptive': 432},
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Generate Launcher Icons', () async {
    final File svgFile = File('icon.svg');
    if (!svgFile.existsSync()) {
      fail('icon.svg not found at root!');
    }

    final String svgString = svgFile.readAsStringSync();
    
    // Parse SVG into a PictureInfo
    final SvgStringLoader loader = SvgStringLoader(svgString);
    final PictureInfo pictureInfo = await vg.loadPicture(loader, null);

    final String resDir = 'android/app/src/main/res';
    final Directory resDirObj = Directory(resDir);
    if (!resDirObj.existsSync()) {
      fail('res directory not found at $resDir');
    }

    print('Generating launcher icons using flutter_svg...');

    for (final theme in iconThemes) {
      print('Processing theme: ${theme.name}');

      // For each density, render the required sizes
      for (final entry in densities.entries) {
        final String density = entry.key;
        final double legacySize = entry.value['legacy']!;
        final double adaptiveSize = entry.value['adaptive']!;

        final String mipmapDir = '$resDir/mipmap-$density';
        Directory(mipmapDir).createSync(recursive: true);

        // 1. Legacy Square Icon (rounded square)
        final Uint8List legacySqBytes = await renderIcon(
          pictureInfo: pictureInfo,
          size: legacySize,
          color1: theme.color1,
          color2: theme.color2,
          backgroundColor: Colors.white,
          isRound: false,
          paddingFactor: 0.03, // Tiny padding for background square
          logoScaleFactor: 0.52, // 52% of tile height (adds padding)
        );
        File('$mipmapDir/ic_launcher_${theme.name}.png').writeAsBytesSync(legacySqBytes);

        // 2. Legacy Round Icon (circular)
        final Uint8List legacyRdBytes = await renderIcon(
          pictureInfo: pictureInfo,
          size: legacySize,
          color1: theme.color1,
          color2: theme.color2,
          backgroundColor: Colors.white,
          isRound: true,
          paddingFactor: 0.03, // Tiny padding for background circle
          logoScaleFactor: 0.52, // 52% of tile height (adds padding)
        );
        File('$mipmapDir/ic_launcher_${theme.name}_round.png').writeAsBytesSync(legacyRdBytes);

        // 3. Adaptive Foreground Icon (transparent)
        final Uint8List adaptiveFgBytes = await renderIcon(
          pictureInfo: pictureInfo,
          size: adaptiveSize,
          color1: theme.color1,
          color2: theme.color2,
          backgroundColor: null,
          isRound: false,
          paddingFactor: 0.0,
          logoScaleFactor: 0.42, // Decreased to 0.42 to provide more padding and prevent Android clipping
        );
        File('$mipmapDir/ic_launcher_${theme.name}_foreground.png').writeAsBytesSync(adaptiveFgBytes);

        // 4. Adaptive Monochrome Icon (solid black, transparent background)
        final Uint8List adaptiveMonoBytes = await renderIcon(
          pictureInfo: pictureInfo,
          size: adaptiveSize,
          color1: Colors.black,
          color2: Colors.black,
          backgroundColor: null,
          isRound: false,
          paddingFactor: 0.0,
          logoScaleFactor: 0.42, // Decreased to 0.42 to provide more padding and prevent Android clipping
        );
        File('$mipmapDir/ic_launcher_${theme.name}_monochrome.png').writeAsBytesSync(adaptiveMonoBytes);

        // If emerald, save as default icon
        if (theme.name == 'emerald') {
          File('$mipmapDir/ic_launcher.png').writeAsBytesSync(legacySqBytes);
          File('$mipmapDir/ic_launcher_round.png').writeAsBytesSync(legacyRdBytes);
          File('$mipmapDir/ic_launcher_foreground.png').writeAsBytesSync(adaptiveFgBytes);
          File('$mipmapDir/ic_launcher_monochrome.png').writeAsBytesSync(adaptiveMonoBytes);
        }
      }

      // Generate the XML configuration files for adaptive launcher
      final String v26Dir = '$resDir/mipmap-anydpi-v26';
      Directory(v26Dir).createSync(recursive: true);

      final String xmlContent = '''<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/ic_launcher_background_${theme.name}" />
    <foreground android:drawable="@mipmap/ic_launcher_${theme.name}_foreground" />
    <monochrome android:drawable="@mipmap/ic_launcher_${theme.name}_monochrome" />
</adaptive-icon>
''';

      File('$v26Dir/ic_launcher_${theme.name}.xml').writeAsStringSync(xmlContent);
      File('$v26Dir/ic_launcher_${theme.name}_round.xml').writeAsStringSync(xmlContent);

      if (theme.name == 'emerald') {
        final String defaultXmlContent = '''<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/ic_launcher_background_emerald" />
    <foreground android:drawable="@mipmap/ic_launcher_foreground" />
    <monochrome android:drawable="@mipmap/ic_launcher_monochrome" />
</adaptive-icon>
''';
        File('$v26Dir/ic_launcher.xml').writeAsStringSync(defaultXmlContent);
        File('$v26Dir/ic_launcher_round.xml').writeAsStringSync(defaultXmlContent);
      }
    }

    // Generate colors.xml (light theme)
    final File colorsFile = File('$resDir/values/colors.xml');
    final StringBuffer colorsBuf = StringBuffer('<?xml version="1.0" encoding="utf-8"?>\n<resources>\n');
    for (final theme in iconThemes) {
      colorsBuf.writeln('    <color name="ic_launcher_background_${theme.name}">#FFFFFF</color>');
    }
    colorsBuf.writeln('</resources>');
    colorsFile.writeAsStringSync(colorsBuf.toString());

    // Generate colors.xml (night theme)
    final File colorsNightFile = File('$resDir/values-night/colors.xml');
    colorsNightFile.parent.createSync(recursive: true);
    final StringBuffer colorsNightBuf = StringBuffer('<?xml version="1.0" encoding="utf-8"?>\n<resources>\n');
    for (final theme in iconThemes) {
      colorsNightBuf.writeln('    <color name="ic_launcher_background_${theme.name}">#121212</color>');
    }
    colorsNightBuf.writeln('</resources>');
    colorsNightFile.writeAsStringSync(colorsNightBuf.toString());

    pictureInfo.picture.dispose();
    print('All icons generated successfully!');
  });
}

Future<Uint8List> renderIcon({
  required PictureInfo pictureInfo,
  required double size,
  required Color color1,
  required Color color2,
  required Color? backgroundColor,
  required bool isRound,
  required double paddingFactor,
  required double logoScaleFactor,
}) async {
  final ui.PictureRecorder recorder = ui.PictureRecorder();
  final ui.Canvas canvas = ui.Canvas(recorder, Rect.fromLTWH(0, 0, size, size));

  final double padding = size * paddingFactor;

  // 1. Draw background if provided
  if (backgroundColor != null) {
    final Paint bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    if (isRound) {
      canvas.drawCircle(Offset(size / 2, size / 2), size / 2 - padding, bgPaint);
    } else {
      final double r = size * 0.22;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(padding, padding, size - 2 * padding, size - 2 * padding),
          Radius.circular(r),
        ),
        bgPaint,
      );
    }
  }

  // 2. Draw logo shape with gradient shader
  final double logoSize = size * logoScaleFactor;
  final double logoLeft = (size - logoSize) / 2;
  final double logoTop = (size - logoSize) / 2;

  // Bounding box of the path in SVG space:
  const double pathLeft = 269.0;
  const double pathTop = 140.0;
  const double pathWidth = 557.0;
  const double pathHeight = 696.0;

  // Fit the path bounds into logoSize x logoSize, preserving aspect ratio:
  final double scale = logoSize / pathHeight;
  final double drawnWidth = pathWidth * scale;
  final double drawnHeight = pathHeight * scale;

  final double localLeft = (logoSize - drawnWidth) / 2;
  final double localTop = (logoSize - drawnHeight) / 2;

  final Rect logoRect = Rect.fromLTWH(logoLeft, logoTop, logoSize, logoSize);
  canvas.saveLayer(logoRect, Paint());

  // Translate and scale to draw SVG centered and scaled to fill logoSize
  canvas.save();
  canvas.translate(logoLeft + localLeft, logoTop + localTop);
  canvas.scale(scale);
  canvas.translate(-pathLeft, -pathTop);
  canvas.drawPicture(pictureInfo.picture);
  canvas.restore();

  // Apply gradient shader on top of drawn SVG shape
  final Paint shaderPaint = Paint()
    ..shader = ui.Gradient.linear(
      Offset(logoLeft + localLeft, logoTop + localTop),
      Offset(logoLeft + localLeft + drawnWidth, logoTop + localTop + drawnHeight),
      [color1, color2],
    )
    ..blendMode = BlendMode.srcIn;
  canvas.drawRect(logoRect, shaderPaint);

  canvas.restore(); // Restore saveLayer

  // 3. Export to PNG bytes
  final ui.Image image = await recorder.endRecording().toImage(size.toInt(), size.toInt());
  final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  
  image.dispose();
  return byteData?.buffer.asUint8List() ?? Uint8List(0);
}
