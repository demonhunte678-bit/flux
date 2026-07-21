import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flux/index.dart';

class FluxLogo extends StatelessWidget {
  final double size;
  final bool showBackground;
  final bool forceLightTheme;

  const FluxLogo({
    super.key,
    this.size = 120,
    this.showBackground = true,
    this.forceLightTheme = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final isDark = forceLightTheme ? false : (theme.brightness == Brightness.dark);

    // Generate gradient colors dynamically from the theme primary color
    final gradientColors = ThemeService.getGradientColors(primaryColor);

    // Dimensions of the actual shape inside icon.svg (viewBox is 1024x1024)
    const double pathLeft = 269.0;
    const double pathTop = 140.0;
    const double pathWidth = 557.0;
    const double pathHeight = 696.0;

    // Total box size for the logo shape
    final double logoSize = size * (showBackground ? 0.58 : 1.0);
    
    // Scale factor to map the 696px high path to logoSize
    final double scale = logoSize / pathHeight;
    final double drawnWidth = pathWidth * scale;
    final double drawnHeight = pathHeight * scale;

    // Layout the SVG inside a Stack and ClipRect to crop out the empty space
    Widget croppedLogo = ClipRect(
      child: SizedBox(
        width: drawnWidth,
        height: drawnHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: -pathLeft * scale,
              top: -pathTop * scale,
              width: 1024.0 * scale,
              height: 1024.0 * scale,
              child: SvgPicture.asset(
                'icon.svg',
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // Apply the gradient ShaderMask onto the cropped logo shape
    Widget gradientLogo = ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcIn,
      child: croppedLogo,
    );

    if (!showBackground) {
      return gradientLogo;
    }

    // Wrap the logo in a beautiful rounded rectangle, matching the phone theme
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(size * 0.23), // Matching smooth app icon corners
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
            blurRadius: size * 0.1,
            offset: Offset(0, size * 0.03),
          ),
        ],
      ),
      child: gradientLogo,
    );
  }
}
