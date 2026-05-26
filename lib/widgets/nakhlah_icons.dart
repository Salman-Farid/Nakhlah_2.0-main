import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Nakhlah Website Custom Icons
/// Ported from: nakhlah-web-2.0-main/components/icons/
/// Each icon matches the website's SVG exactly.

// ============================================================
// HELPER: SVG-based asset icons (from public/icons/*.svg)
// ============================================================

class PalmTreeIcon extends StatelessWidget {
  final double size;
  const PalmTreeIcon({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/nakhlah_design/Palm_Trees.svg',
      width: size,
      height: size,
    );
  }
}

class ActiveStreakIcon extends StatelessWidget {
  final double size;
  const ActiveStreakIcon({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/nakhlah_design/active-streak.svg',
      width: size,
      height: size,
    );
  }
}

class DatesIcon extends StatelessWidget {
  final double size;
  const DatesIcon({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/nakhlah_design/dates.svg',
      width: size,
      height: size,
    );
  }
}

class InjazStarIcon extends StatelessWidget {
  final double size;
  const InjazStarIcon({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/nakhlah_web/icons/star.svg',
      width: size,
      height: size,
    );
  }
}

// ============================================================
// INLINE SVG ICONS (from JSX components)
// ============================================================

class NakhlahFlameIcon extends StatelessWidget {
  final double size;
  const NakhlahFlameIcon({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      _flameSvg,
      width: size,
      height: size,
    );
  }
}

class NakhlahTrophyIcon extends StatelessWidget {
  final double size;
  final String variant;
  const NakhlahTrophyIcon({super.key, this.size = 36, this.variant = 'gold'});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      variant == 'silver' ? _trophySilverSvg : _trophyGoldSvg,
      width: size,
      height: size,
    );
  }
}

class NakhlahGemIcon extends StatelessWidget {
  final double size;
  const NakhlahGemIcon({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      _gemSvg,
      width: size,
      height: size,
    );
  }
}

class NakhlahCrownIcon extends StatelessWidget {
  final double size;
  const NakhlahCrownIcon({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      _crownSvg,
      width: size,
      height: size,
    );
  }
}

class NakhlahMedalIcon extends StatelessWidget {
  final double size;
  const NakhlahMedalIcon({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      _medalSvg,
      width: size,
      height: size,
    );
  }
}

class NakhlahHeartIcon extends StatelessWidget {
  final double size;
  const NakhlahHeartIcon({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      _heartSvg,
      width: size,
      height: size,
    );
  }
}

class NakhlahStarIcon extends StatelessWidget {
  final double size;
  const NakhlahStarIcon({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      _starSvg,
      width: size,
      height: size,
    );
  }
}

class NakhlahBookOpenIcon extends StatelessWidget {
  final double size;
  const NakhlahBookOpenIcon({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      _bookOpenSvg,
      width: size,
      height: size,
    );
  }
}

class NakhlahBarChartIcon extends StatelessWidget {
  final double size;
  const NakhlahBarChartIcon({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      _barChartSvg,
      width: size,
      height: size,
    );
  }
}

class NakhlahCalendarIcon extends StatelessWidget {
  final double size;
  const NakhlahCalendarIcon({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      _calendarSvg,
      width: size,
      height: size,
    );
  }
}

class NakhlahLockIcon extends StatelessWidget {
  final double size;
  final String variant;
  const NakhlahLockIcon({super.key, this.size = 36, this.variant = 'gold'});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      variant == 'silver' ? _lockSilverSvg : _lockGoldSvg,
      width: size,
      height: size,
    );
  }
}

class NakhlahGlowingStarIcon extends StatelessWidget {
  final double size;
  const NakhlahGlowingStarIcon({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      _glowingStarSvg,
      width: size,
      height: size,
    );
  }
}

class NakhlahTreasureChestIcon extends StatelessWidget {
  final double size;
  const NakhlahTreasureChestIcon({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      _treasureChestSvg,
      width: size,
      height: size,
    );
  }
}

class NakhlahBullsEyeIcon extends StatelessWidget {
  final double size;
  const NakhlahBullsEyeIcon({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      _bullsEyeSvg,
      width: size,
      height: size,
    );
  }
}

class NakhlahMilitaryMedalIcon extends StatelessWidget {
  final double size;
  const NakhlahMilitaryMedalIcon({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      _militaryMedalSvg,
      width: size,
      height: size,
    );
  }
}

class NakhlahStopwatchIcon extends StatelessWidget {
  final double size;
  const NakhlahStopwatchIcon({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      _stopwatchSvg,
      width: size,
      height: size,
    );
  }
}

class NakhlahHighVoltageIcon extends StatelessWidget {
  final double size;
  const NakhlahHighVoltageIcon({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      _highVoltageSvg,
      width: size,
      height: size,
    );
  }
}

class NakhlahLockKeyIcon extends StatelessWidget {
  final double size;
  const NakhlahLockKeyIcon({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      _lockKeySvg,
      width: size,
      height: size,
    );
  }
}

// ============================================================
// SVG STRING DATA
// ============================================================

const _flameSvg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128">
  <defs>
    <radialGradient id="flame-outer" cx="68.884" cy="124.296" r="70.587" gradientTransform="matrix(-1 -.00434 -.00713 1.6408 131.986 -79.345)" gradientUnits="userSpaceOnUse">
      <stop offset="0.314" stop-color="#ff9800"/>
      <stop offset="0.662" stop-color="#ff6d00"/>
      <stop offset="0.972" stop-color="#f44336"/>
    </radialGradient>
    <radialGradient id="flame-inner" cx="64.921" cy="54.062" r="73.86" gradientTransform="matrix(-.0101 .9999 .7525 .0076 26.154 -11.267)" gradientUnits="userSpaceOnUse">
      <stop offset="0.214" stop-color="#ffca28"/>
      <stop offset="0.609" start-color="#ffa726"/>
      <stop offset="1" stop-color="#ff9800"/>
    </radialGradient>
  </defs>
  <path fill="url(#flame-outer)" d="M35.56 40.73c-.57 6.08-.97 16.84 2.62 21.42c0 0-1.69-11.82 13.46-26.65c6.1-5.97 7.51-14.09 5.38-20.18c-1.21-3.45-3.42-6.3-5.34-8.29c-1.12-1.17-.26-3.1 1.37-3.03c9.86.44 25.84 3.18 32.63 20.22c2.98 7.48 3.2 15.21 1.78 23.07c-.90 5.02-4.1 16.18 3.2 17.55c5.21.98 7.73-3.16 8.86-6.14c.47-1.24 2.1-1.55 2.98-.56c8.8 10.01 9.55 21.8 7.73 31.95c-3.52 19.62-23.39 33.9-43.13 33.9c-24.66 0-44.29-14.11-49.38-39.65c-2.05-10.31-1.01-30.71 14.89-45.11c1.18-1.08 3.11-.12 2.95 1.5"/>
  <path fill="url(#flame-inner)" d="M57.81 72.66c0 0 1.81 19.95 17.67 29.77c0 0-5.45-14.81 2.34-29.77c0 0 1.57 9.78 10.28 16.34c0 0-8.71-11.61-4.51-26.02c3.07-10.58 6.57-12.94 8.58-14.31c-1.39 5.69-1.17 16.51-10.59 27.27c0 0 .77-14.88-8.64-25.6c-5.82-6.59-8.87-9.39-10.42-11.12c0 11.48-8.81 23.59-16.31 33.44"/>
</svg>''';

const _trophyGoldSvg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128">
  <path fill="#fec417" d="M97.12 59.35c2.22-1.83 15.04-9.76 22.06-16.44c5.48-5.22 7.6-18.85-.83-25.48c-10.96-8.61-21.48.43-21.48.43s-.92-5.11-7.32-8.11c-8.06-3.78-18.27-5.19-27.66-5.07c-9.1.11-17.48 1.21-24.92 4.86c-6.66 3.27-7.06 7.93-7.06 7.93s-8.74-8.35-19.45-1.57C-.24 22.69 2.83 36.29 7.98 42c6.71 7.44 14.77 11.23 18.43 13.97c3.65 2.74 7.15 5.35 7.15 7.70s-1.04 2.87-1.44 2.74c-.39-.13-1.08-2.42-2.87-1.44c-2.44 1.35-1.70 6.79 3.39 7.31c4.93.51 5.87-4.70 5.87-4.70l.78-5.09l8.09 5.61l8.87 7.31l-.26 6.26s-.39 4.83-2.74 9.01s-6.13 8.35-6.13 8.35l-.12 3.78l32.89-.78l-1.04-3.65s-4.24-4.66-6.79-9.66c-1.82-3.58-2.11-7.19-2.11-7.19l-.08-8.98l17.07-10.46s1.83 1.44 1.57 1.96s-.32 5.85 3.78 7.83c4.05 1.96 7.31-.52 6.92-3.92c-.39-3.39-2.48-2.22-3.13-1.70s-2.09.65-2.48-1.31c-.40-1.94 1.30-3.77 3.52-5.60"/>
  <path fill="#ffa828" d="M63.92 22.63c-5.38.14-10.76.6-16.04 1.52c-5.23.92-9.94 2.73-13.68 5.42c3.26-1.12 7.11-1.71 11.39-1.84c8.82-.27 19.12 1.14 28.73 4.92c4.83 1.91 8.67 4.53 10.91 7.33c-2.58-4.48-8.24-9.55-17.31-13.09c-4.6-1.79-9.11-3.75-13.99-4.26"/>
  <path fill="#ffefab" d="M63.92 22.63c5.38-.14 10.76-.6 16.04-1.52c1.28-.23 2.53-.49 3.76-.8c-1.28.23-2.53.49-3.76.8c-5.28.92-10.66 1.38-16.04 1.52"/>
</svg>''';

const _trophySilverSvg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128">
  <path fill="#cfd3d6" d="M97.12 59.35c2.22-1.83 15.04-9.76 22.06-16.44c5.48-5.22 7.6-18.85-.83-25.48c-10.96-8.61-21.48.43-21.48.43s-.92-5.11-7.32-8.11c-8.06-3.78-18.27-5.19-27.66-5.07c-9.1.11-17.48 1.21-24.92 4.86c-6.66 3.27-7.06 7.93-7.06 7.93s-8.74-8.35-19.45-1.57C-.24 22.69 2.83 36.29 7.98 42c6.71 7.44 14.77 11.23 18.43 13.97c3.65 2.74 7.15 5.35 7.15 7.70s-1.04 2.87-1.44 2.74c-.39-.13-1.08-2.42-2.87-1.44c-2.44 1.35-1.70 6.79 3.39 7.31c4.93.51 5.87-4.70 5.87-4.70l.78-5.09l8.09 5.61l8.87 7.31l-.26 6.26s-.39 4.83-2.74 9.01s-6.13 8.35-6.13 8.35l-.12 3.78l32.89-.78l-1.04-3.65s-4.24-4.66-6.79-9.66c-1.82-3.58-2.11-7.19-2.11-7.19l-.08-8.98l17.07-10.46s1.83 1.44 1.57 1.96s-.32 5.85 3.78 7.83c4.05 1.96 7.31-.52 6.92-3.92c-.39-3.39-2.48-2.22-3.13-1.70s-2.09.65-2.48-1.31c-.40-1.94 1.30-3.77 3.52-5.60"/>
  <path fill="#aeb4b9" d="M63.92 22.63c-5.38.14-10.76.6-16.04 1.52c-5.23.92-9.94 2.73-13.68 5.42c3.26-1.12 7.11-1.71 11.39-1.84c8.82-.27 19.12 1.14 28.73 4.92c4.83 1.91 8.67 4.53 10.91 7.33c-2.58-4.48-8.24-9.55-17.31-13.09c-4.6-1.79-9.11-3.75-13.99-4.26"/>
  <path fill="#e6e8ea" d="M63.92 22.63c5.38-.14 10.76-.6 16.04-1.52c1.28-.23 2.53-.49 3.76-.8c-1.28.23-2.53.49-3.76.8c-5.28.92-10.66 1.38-16.04 1.52"/>
</svg>''';

const _gemSvg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128">
  <path fill="#e1f5fe" d="m4.01 47.94l17.48-26.51L35.03 36.9z"/>
  <path fill="#81d4fa" d="M44.11 68.26L4.01 47.94L35.03 36.9z"/>
  <path fill="#64b5f6" d="M63.94 43.06L35.03 36.9l9.08 31.36z"/>
  <path fill="#0288d1" d="m123.87 47.94l-17.48-26.51L92.85 36.9z"/>
  <path fill="#81d4fa" d="m83.77 68.26l40.1-20.32L92.85 36.9z"/>
  <path fill="#e1f5fe" d="m63.94 43.06l28.91-6.16l-9.08 31.36z"/>
  <path fill="#b2ebf2" d="m83.77 68.26l-19.83-25.2l-19.83 25.2z"/>
  <path fill="#b3e5fc" d="M43 10.06h41.88l21.51 11.37L92.85 36.9l-28.91 6.16l-28.91-6.16l-13.54-15.47z"/>
  <path fill="#1e88e5" d="M63.94 117.27L4.01 47.94l40.1 20.32z"/>
  <path fill="#b3e5fc" d="m63.94 117.27l59.93-69.33l-40.1 20.32z"/>
  <path fill="#e1f5fe" d="m83.77 68.26l-19.83 49.01l-19.83-49.01z"/>
</svg>''';

const _crownSvg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128">
  <path fill="#f19534" d="M94.52 21.81c2.44-1.18 4.13-3.67 4.13-6.56a7.28 7.28 0 0 0-14.56 0c0 2.93 1.73 5.44 4.22 6.6c-2.88 15.6-7.3 27.21-23.75 29.69c0 0 4.43 22.15 25.15 22.15s22.82-21.93 22.82-21.93c-16.81.86-18.23-20.27-18.01-29.95"/>
  <path fill="#f19534" d="M34.74 21.81c-2.44-1.18-4.13-3.67-4.13-6.56a7.28 7.28 0 0 1 14.56 0c0 2.93-1.73 5.44-4.22 6.6c2.88 15.6 7.3 27.21 23.75 29.69c0 0-4.43 22.15-25.15 22.15S16.74 51.77 16.74 51.77c16.8.85 18.22-20.28 18-29.96"/>
  <path fill="#ffca28" d="M119.24 16.86c-3.33-.45-6.51 2.72-7.09 7.06c-.36 2.71.37 5.24 1.78 6.87l-2.4 9.95s-3.67 23.51-22.21 28.15C74.5 72.6 69.13 45.47 67.83 37.09c2.82-1.4 4.77-4.3 4.77-7.67c0-4.73-3.83-8.56-8.56-8.56s-8.56 3.83-8.56 8.56c0 3.39 1.98 6.32 4.85 7.7c-1.03 8.27-5.57 34.5-21.57 31.76c-16.24-2.79-23.33-30.14-24.97-37.58c1.95-1.6 3.04-4.42 2.64-7.45c-.58-4.35-4.02-7.47-7.68-6.98s-6.15 4.41-5.57 8.75c.42 3.16 2.36 5.67 4.79 6.62l12.72 79.03s11.1 8.77 43.35 8.77s43.35-8.77 43.35-8.77l12.75-79.24c2.06-1.08 3.68-3.51 4.08-6.49c.59-4.35-1.64-8.23-4.98-8.68"/>
  <ellipse cx="64.44" cy="88.3" fill="#26a69a" rx="9.74" ry="11.61"/>
  <path fill="#69f0ae" d="M64.44 79.56c.38.42.72 1.19 0 2.69s-4.6 3.53-5.31 3.94c-.71.42-1.18.23-1.4.06c-1.05-.84-.65-2.74.03-3.9c1.46-2.51 4.55-5.1 6.68-2.79"/>
  <path fill="#00796b" d="M63.72 92.63c-1.1.53-4.71 2.14-3.52 4.05c.7 1.13 2.15 1.61 3.48 1.67s2.64-.36 3.82-.97c5.6-2.9 6.05-10.52 4.96-11.1c-1.12-.6-1.88.95-2.46 1.61a20.3 20.3 0 0 1-6.28 4.74"/>
</svg>''';

const _heartSvg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128">
  <path fill="#db0a28" d="M64.8 120.71c3.68 0 32.11-24.18 48.7-44.07c15.96-19.14 10.2-41.74 6.69-48.03c-4.15-7.43-56.94 17.01-56.94 17.01S14.07 17.99 10.39 23.99C5.4 32.13-1.59 53.54 12.52 73.45C27.5 94.6 60.85 120.71 64.8 120.71"/>
  <path fill="#ff262e" d="M64.55 114.2s52.26-38.68 56.75-62.3c4.25-22.37-4.45-33.22-15.16-38.45C78.99.19 65.29 26.21 64 26.21S49.95.14 23.7 11.42C9.24 17.63 3.18 34.53 8.91 53.57c8.41 27.94 55.64 60.63 55.64 60.63"/>
</svg>''';

const _starSvg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128">
  <path fill="#fff" d="m68.05 7.23l13.46 30.7a7.05 7.05 0 0 0 5.82 4.19l32.79 2.94c3.71.54 5.19 5.09 2.5 7.71l-24.7 20.75c-2 1.68-2.91 4.32-2.36 6.87l7.18 33.61c.63 3.69-3.24 6.51-6.56 4.76L67.56 102a7.03 7.03 0 0 0-7.12 0l-28.62 16.75c-3.31 1.74-7.19-1.07-6.56-4.76l7.18-33.61c.54-2.55-.36-5.19-2.36-6.87L5.37 52.78c-2.68-2.61-1.2-7.17 2.5-7.71l32.79-2.94a7.05 7.05 0 0 0 5.82-4.19l13.46-30.7c1.67-3.36 6.45-3.36 8.11-.01"/>
  <path fill="#e8e8e1" d="m67.07 39.77l-2.28-22.62c-.09-1.26-.35-3.42 1.67-3.42c1.6 0 2.47 3.33 2.47 3.33l6.84 18.16c2.58 6.91 1.52 9.28-.97 10.68c-2.86 1.6-7.08.35-7.73-6.13"/>
  <path fill="#d5d0d0" d="M95.28 71.51L114.9 56.2c.97-.81 2.72-2.1 1.32-3.57c-1.11-1.16-4.11.51-4.11.51l-17.17 6.71c-5.12 1.77-8.52 4.39-8.82 7.69c-.39 4.4 3.56 7.79 9.16 3.97"/>
</svg>''';

const _bookOpenSvg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128">
  <path fill="#c62828" d="m70.24 100.79l48.55 4.62c4.57.44 5.74-2.11 5.74-4.27l-.05-2.62l-59.71-8.42c0 2.99 2.43 10.69 5.47 10.69"/>
  <path fill="#f44336" d="m72.01 98.51l7.64.67l40.91 3.95c2.2 0 3.97-1.75 3.97-3.91l-2.17-66.26c0-2.16-1.78-3.91-3.97-3.91l-46.38-4.38c-3.04 0-5.51 2.43-5.51 5.42v63c0 2.99 2.46 5.42 5.51 5.42"/>
  <path fill="#c62828" d="m57.76 100.79l-48.55 4.62c-4.57.44-5.74-2.11-5.74-4.27l.05-2.62l59.71-8.43c0 3-2.43 10.7-5.47 10.7"/>
  <path fill="#f44336" d="m55.99 98.51l-7.58.67l-40.97 3.96c-2.2 0-3.97-1.75-3.97-3.91l2.17-66.26c0-2.16 1.78-3.91 3.97-3.91l46.38-4.38c3.04 0 5.51 2.43 5.51 5.42v63c0 2.98-2.46 5.41-5.51 5.41"/>
  <path fill="#424242" d="M78.75 83.68H49.27l-.9 15.53l9.2.86s1.97 4.92 6.43 4.92s6.43-4.92 6.43-4.92l9.2-.86z"/>
  <path fill="#94c6d6" d="m119.65 32.82l-4-5.5L64 86.02l-51.65-58.7l-4 5.5l-.56 65.35s10.62 1.33 24.81-.11c12.36-1.25 18.18-4.45 22.31-3.62c4.96 1 5.86 4.05 6.02 4.57c.45 1.44 1.34 2.56 3.07 2.56s2.5-.6 3.03-2.38c.16-.52 1.1-3.74 6.06-4.74c4.13-.83 9.95 2.37 22.31 3.62c14.19 1.44 24.81.11 24.81.11z"/>
  <path fill="#f44336" d="M56.02 27.28c5.11 12.72 16.24 24.37 36.11 30.68c-5.39 1.51-14.79 3.07-28.41 3.07c-16.77 0-26.21-2.23-31.76-3.62c11.77-7.13 17.95-18.08 24.06-30.13"/>
</svg>''';

const _barChartSvg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128">
  <path fill="#fff" d="M4 4h120v120H4z"/>
  <path fill="none" stroke="#504534" stroke-miterlimit="10" stroke-width="2" d="M124 24.35H5.57M124 43.67H5.47M124 62.99H5.36M124 82.31H5.26M124 101.64H5.15"/>
  <path fill="#9ccc65" d="M38.72 121.91H21.89V55.38c0-1.36 1.1-2.46 2.46-2.46h11.91c1.36 0 2.46 1.1 2.46 2.46z"/>
  <path fill="#f44336" d="M72.42 121.91H55.58V74.84c0-1.36 1.1-2.46 2.46-2.46h11.91c1.36 0 2.46 1.1 2.46 2.46v47.07z"/>
  <path fill="#0091ea" d="M103.64 121.91H91.73c-1.36 0-2.46-1.1-2.46-2.46V25.86c0-1.36 1.1-2.46 2.46-2.46h11.91c1.36 0 2.46 1.1 2.46 2.46v93.59c0 1.36-1.1 2.46-2.46 2.46"/>
  <path fill="#504534" d="M124 120H8V4H4v120h120z"/>
  <path fill="#504534" d="M122 6v116H6V6zm2-2H4v120h120z"/>
</svg>''';

const _medalSvg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128">
  <path fill="#176cc7" d="M69.09 4.24c-1.08.96-9.48 17.63-9.48 17.63l-6.25 25.21l24.32-2.23S97.91 7.23 98.32 6.36c.73-1.58 1.12-2.23-1.67-2.23c-2.79-.01-26.55-.79-27.56.11"/>
  <path fill="#fcc11a" d="M81.68 43.29c-1.21-.65-36.85-1.21-37.69 0c-.76 1.1-.33 6.87-.04 7.56c.52 1.2 11.97 5.85 11.97 5.85v2.89s.78.32 7.46.32s8.01-.34 8.01-.34l.05-2.78s9.94-5.12 10.46-5.83c.46-.59.99-7.02-.22-7.67"/>
  <path fill="#f8932a" d="M29.31 92.09c0 23.96 21.71 33.93 36.12 33.50c16.79-.50 34.85-13.24 33.36-36.10c-1.40-21.45-19.69-31.69-35.47-31.57c-18.34.13-34.01 13.24-34.01 34.17"/>
  <path fill="#fcc11a" d="M64.52 121.29c-.25 0-.51 0-.76-.01c-7.50-.25-15.12-3.08-20.54-8.33c-5.80-5.62-9.38-12.73-9.40-20.90c-.05-21.46 18.34-29.35 30.17-29.35h.10c16.03.07 29.88 12.05 30.24 28.94c.16 7.52-2.92 15.48-8.96 21.42c-5.63 5.53-13.94 8.23-20.85 8.23"/>
  <path fill="#2e9df4" d="M25.51 3.72c-.63.58 23.46 43.48 23.46 43.48s4.04.52 13.06.60s13.49-.52 13.49-.52S56.79 4.15 55.67 3.72c-.55-.22-7.97-.30-15.22-.38c-7.26-.09-14.34-.18-14.94.38"/>
  <path fill="#fefffa" d="M52.29 67.35c-1.46-1.25-8.89 2.52-14.11 11.15c-3.50 5.79-3.80 10.08-3.80 10.08s5.28 5.75 17.66 5.75s19.04-6.62 19.04-6.62s.57-8.52-4.23-14.11c-3.62-4.22-8.69-5.34-12.34-6.34"/>
</svg>''';

const _calendarSvg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128">
  <path fill="#bdbdbd" d="M6.81 35.5v75.03c0 3.12 2.9 5.21 6.32 7.61c3.53 2.48 5.48 2.25 7.17 2.25l95.86.62c3.77 0 5.03-2.57 5.03-5.34V35.5z"/>
  <path fill="#deded4" d="M9.75 36.33v72.13c0 2.7 2.19 4.88 4.88 4.88h94.85c2.7 0 5.22-2.01 5.22-4.71v-72.3z"/>
  <path fill="#f44336" d="M114.73 37.17H6.81V18.55c0-2.51 2.57-4.55 5.75-4.55h96.59c3.19 0 5.77 2.05 5.75 4.58z"/>
  <path fill="#757575" d="M103.71 116.62c-3.18.39-6.36.55-9.54.83c-3.18.2-6.36.38-9.54.49c-3.18.16-6.36.18-9.54.18s-6.36-.07-9.54-.18c-3.18-.11-6.36-.29-9.54-.49c-3.18-.28-6.36-.44-9.54-.83c-3.18-.39-5.36-1.02-5.36-1.02v-3.86h62.6v3.86s-2.18.63-5.36 1.02"/>
  <path fill="#c62828" d="M6.81 14v4.55h114.38V14c0-2.51-2.57-4.55-5.75-4.55H12.56C9.38 9.45 6.81 11.49 6.81 14"/>
  <path fill="#fff" d="M24.39 20.32v12.16h-5.38V20.32zm18.82 0v12.16h-5.38V20.32zm18.82 0v12.16h-5.38V20.32zm18.82 0v12.16h-5.38V20.32zm18.82 0v12.16h-5.38V20.32z"/>
  <path fill="#424242" d="M12.56 41.26h102.88v4.56H12.56zm0 15.22h102.88v4.56H12.56zm0 15.22h102.88v4.56H12.56zm0 15.22h102.88v4.56H12.56zm0 15.22h102.88v4.56H12.56z"/>
  <path fill="#9e9e9e" d="M103.71 112.76H24.28v3.86s2.18.63 5.36 1.02c3.18.39 6.36.55 9.54.83c3.18.2 6.36.38 9.54.49c3.18.16 6.36.18 9.54.18s6.36-.07 9.54-.18c3.18-.11 6.36-.29 9.54-.49c3.18-.28 6.36-.44 9.54-.83c3.18-.39 5.36-1.02 5.36-1.02z"/>
</svg>''';

const _lockGoldSvg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128">
  <path fill="#e2a610" d="M103.65 62.7h-.01c-.12-2.45-2.72-4.74-7.21-6.09c-9.61-2.89-20.27-4.58-32.43-4.68c-12.15.1-22.81 1.79-32.43 4.68c-4.49 1.35-7.07 3.64-7.2 6.09h-.02v50.08c-.11 2.8 3.02 5.8 10.26 7.85c7.48 2.12 17.6 3.49 29.38 3.49s21.9-1.37 29.38-3.49c7.59-2.15 10.66-5.34 10.22-8.25h.04V62.7z"/>
  <path fill="#4e342e" d="m71.9 108.24l-4.49-10.58a7.66 7.66 0 0 0 4.33-6.9c0-4.24-3.44-7.67-7.67-7.67s-7.67 3.44-7.67 7.67c0 2.85 1.56 5.34 3.87 6.66l-4.18 10.89c-.53 1.38.49 2.85 1.96 2.85h11.92c1.5 0 2.51-1.54 1.93-2.92"/>
  <path fill="#9e740b" d="M71.47 107.26H56.48l-.4 1.05c-.53 1.38.49 2.85 1.96 2.85h11.92c1.51 0 2.52-1.54 1.93-2.92z"/>
  <path fill="#fdd835" d="M40.22 62.7c.13-2.46 2.72-4.74 7.21-6.09c9.61-2.89 20.27-4.58 32.43-4.68c12.15.1 22.81 1.79 32.43 4.68c4.49 1.35 7.07 3.64 7.2 6.09"/>
  <path fill="#84b0c1" d="M31.85 50.18V31.16c0-16.14 13.09-29.24 29.24-29.24h2.03c16.14 0 29.24 13.09 29.24 29.24v19.02"/>
  <path fill="#b9e4ea" d="M35.85 49.18V31.16c0-14.55 11.8-26.35 26.35-26.35h2.03c14.55 0 26.35 11.8 26.35 26.35v18.02"/>
</svg>''';

const _lockSilverSvg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128">
  <path fill="#cfd3d6" d="M103.65 62.7h-.01c-.12-2.45-2.72-4.74-7.21-6.09c-9.61-2.89-20.27-4.58-32.43-4.68c-12.15.1-22.81 1.79-32.43 4.68c-4.49 1.35-7.07 3.64-7.2 6.09h-.02v50.08c-.11 2.8 3.02 5.8 10.26 7.85c7.48 2.12 17.6 3.49 29.38 3.49s21.9-1.37 29.38-3.49c7.59-2.15 10.66-5.34 10.22-8.25h.04V62.7z"/>
  <path fill="#5f6368" d="m71.9 108.24l-4.49-10.58a7.66 7.66 0 0 0 4.33-6.9c0-4.24-3.44-7.67-7.67-7.67s-7.67 3.44-7.67 7.67c0 2.85 1.56 5.34 3.87 6.66l-4.18 10.89c-.53 1.38.49 2.85 1.96 2.85h11.92c1.5 0 2.51-1.54 1.93-2.92"/>
  <path fill="#9aa0a6" d="M71.47 107.26H56.48l-.4 1.05c-.53 1.38.49 2.85 1.96 2.85h11.92c1.51 0 2.52-1.54 1.93-2.92z"/>
  <path fill="#e6e8ea" d="M40.22 62.7c.13-2.46 2.72-4.74 7.21-6.09c9.61-2.89 20.27-4.58 32.43-4.68c12.15.1 22.81 1.79 32.43 4.68c4.49 1.35 7.07 3.64 7.2 6.09"/>
  <path fill="#b0bec5" d="M31.85 50.18V31.16c0-16.14 13.09-29.24 29.24-29.24h2.03c16.14 0 29.24 13.09 29.24 29.24v19.02"/>
  <path fill="#e3f2fd" d="M35.85 49.18V31.16c0-14.55 11.8-26.35 26.35-26.35h2.03c14.55 0 26.35 11.8 26.35 26.35v18.02"/>
</svg>''';

const _glowingStarSvg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128">
  <path fill="#ffc107" d="m36.46 36.81l-14.14-9.06a2.213 2.213 0 0 1-.41-3.45l5.31-5.31c1.02-1.02 2.74-.8 3.47.45l8.84 14.37c1.16 1.98-1.11 4.2-3.07 3M24.1 80.39l-16.42.33a2.21 2.21 0 0 0-2.09 2.77l1.91 7.26c.37 1.4 1.96 2.07 3.22 1.37l14.51-7.59c2-1.13 1.17-4.19-1.13-4.14m38.14 27.89l-3.6 15.99c-.33 1.39.72 2.73 2.15 2.73h7.51c1.45 0 2.5-1.37 2.14-2.77l-3.91-15.99c-.58-2.23-3.75-2.2-4.29.04m29.3-71.47l14.14-9.06c1.22-.75 1.42-2.44.41-3.45l-5.31-5.31a2.212 2.212 0 0 0-3.47.45l-8.84 14.37c-1.16 1.98 1.11 4.2 3.07 3m12.36 43.58l16.42.33a2.21 2.21 0 0 1 2.09 2.77l-1.91 7.26a2.217 2.217 0 0 1-3.22 1.37l-14.51-7.59c-2-1.13-1.17-4.19 1.13-4.14"/>
  <path fill="#fdd835" d="m68.05 7.23l13.46 30.7a7.05 7.05 0 0 0 5.82 4.19l32.79 2.94c3.71.54 5.19 5.09 2.5 7.71l-24.7 20.75c-2 1.68-2.91 4.32-2.36 6.87l7.18 33.61c.63 3.69-3.24 6.51-6.56 4.76L67.56 102a7.03 7.03 0 0 0-7.12 0l-28.62 16.75c-3.31 1.74-7.19-1.07-6.56-4.76l7.18-33.61c.54-2.55-.36-5.19-2.36-6.87L5.37 52.78c-2.68-2.61-1.2-7.17 2.5-7.71l32.79-2.94a7.05 7.05 0 0 0 5.82-4.19l13.46-30.7c1.67-3.36 6.45-3.36 8.11-.01"/>
  <path fill="#ffff8d" d="m67.07 39.77l-2.28-22.62c-.09-1.26-.35-3.42 1.67-3.42c1.6 0 2.47 3.33 2.47 3.33l6.84 18.16c2.58 6.91 1.52 9.28-.97 10.68c-2.86 1.6-7.08.35-7.73-6.13"/>
  <path fill="#f4b400" d="M95.28 71.51L114.9 56.2c.97-.81 2.72-2.1 1.32-3.57c-1.11-1.16-4.11.51-4.11.51l-17.17 6.71c-5.12 1.77-8.52 4.39-8.82 7.69c-.39 4.4 3.56 7.79 9.16 3.97"/>
</svg>''';

const _bullsEyeSvg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128">
  <path fill="#ff2a23" d="M63.04 7.57C36.72 6.97 7.69 28.8 8.25 64.16c.49 31.09 23.85 54.62 54.12 55.11S119.46 99.75 119.62 64c.17-36.03-27.63-55.77-56.58-56.43"/>
  <path fill="#fffdfe" d="M63.12 20.19c-20.88.71-41.95 16.29-42.44 43.76s23.52 42.77 42.44 42.77c24.02 0 44.09-18.92 43.59-44.09c-.49-25.16-19.41-43.26-43.59-42.44"/>
  <path fill="#ff2a23" d="M63.61 30.89c-18.92-.43-32.9 16.29-33.07 32.24c-.16 16.29 10.03 32.9 32.74 33.72S96.67 79.58 97 64.28c.34-15.3-11.84-32.9-33.39-33.39"/>
  <path fill="#fff" d="M41.98 63.73c-.16 14.31 10.03 22.54 22.37 22.54c11.21 0 22.21-7.07 22.21-22.04c0-13.49-10.2-21.55-21.55-22.04c-11.35-.5-22.87 7.73-23.03 21.54"/>
  <path fill="#fb2b22" d="M52.1 63.62c-.61 8.53 6.33 12.61 12.58 12.61c5.92 0 11.76-3.89 11.93-11.79c.15-7.42-5.67-11.95-11.93-12.17c-6.46-.22-12.09 4.42-12.58 11.35"/>
</svg>''';

const _highVoltageSvg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128">
  <path fill="#feb804" d="M69.68 54.04S98.65 7.63 99.31 6.47s.8-3.29-1.02-3.29s-46.95 46.07-46.95 46.07l-32.05 19s-2.15 1.32-1.82 2.97s1.77 1.72 2.43 1.72s34.85-.18 36.84-.24c2.47-.07 1.86 3.44 1.86 3.44l-21.64 34.02s-9.45 13.08-9.45 13.97c0 1.31 1.58 1.96 3.05 1.08c1.14-.68 74.84-63.13 78.09-67.42c.88-1.17 1.33-4.25-2.3-4.25s-32.54 8.42-32.54 8.42z"/>
  <path fill="#ffc927" d="M64.61 50.35c-.89 1.22-1.13 3.26.79 3.38c1.91.11 40.95-.18 40.95-.18S78.46 79.18 70.02 86.83s-36.39 32.43-38.27 34.18c-1.84 1.72-3.51 3.3-4.19 3.08c-.11-.03-.25-.62 2.38-4.95c2.40-3.95 25.44-42.56 26.34-44.02s1.69-2.7 2.14-3.38s1.91-4.39-1.13-4.39s-38 .9-38 .9s24.15-20.49 31.13-26S96.96 3.18 98.29 3.18S65.51 49.12 64.61 50.35"/>
  <path fill="#ffe567" d="M63.45 70.75c1.80-2.59 3.57-2.78 4.64-2.14c1.38.83 1.52 2.74-.22 5.05c-2.74 3.66-22.88 30.61-23.65 31.56c-1.46 1.80-3.61 1.01-2.21-1.60c1.17-2.16 19.58-30.19 21.44-32.87m-28.62-5.26c-3.45 2.31-6.66-1.14-4.35-3.67s17.47-15.15 20.54-17.76s20.99-18.20 22.38-19.32c1.84-1.48 2.98.02 1.82 1.56c-1.15 1.54-13.82 14.20-19.41 19.34c-4.32 3.98-17.70 17.65-20.98 19.85"/>
</svg>''';

const _treasureChestSvg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128">
  <path fill="#5e6367" d="M25.4 52.9s-7.7 2-8.1 2.3s-.8.7-.7 1.3s1.8 20.8 1.9 24.3s.6 8.8.6 9.5s.4 1.3 1.3 1.7s5.4 2.3 5.8 2.5s1.3.1 1.7-.2s1.3-.6 1.3-.6l34 14.6s-.3 1.6.2 2.1s5.6 2.6 6.2 2.6s1.8-1.8 1.8-1.8l-.6-39.5z"/>
  <path fill="#d27857" d="M43.3 11c4.9-4.3 8.8-5.4 8.8-5.4l15.6 3.2l26.1 8l-12 7.6L71 36.2l-35.2-13s2.7-7.9 7.5-12.2"/>
  <path fill="#a53a2a" d="M43.3 11c4.9-4.3 8.8-5.4 8.8-5.4l15.6 3.2l26.1 8l-12 7.6L71 36.2l-35.2-13s2.7-7.9 7.5-12.2" opacity="0.3"/>
  <path fill="#d27857" d="M24.5 85.1L39 91.6V69.5l-16-6.3z"/>
  <path fill="#e8a87c" d="M64.2 102.4l-16.6-7.2l.2-22.1l17 6.3z"/>
  <path fill="#5e6367" d="M17.2 53.4c-.1.5-.1 1-.1 1.5v27.2c0 .5 0 1 .1 1.5l16.7-7.4V60.8L17.2 53.4z"/>
  <path fill="#7ab9ff" d="M14.5 78.9c-1.4-.1-2.6.7-2.6.7s2.1 2 2.6 2.4s1.4.9 1.7.1s.4-2.7.4-2.7s-.4-.4-2.1-.5"/>
  <path fill="#f57c00" d="M68 93s-4 2-8 2s-8-2-8-2v12s4 2 8 2s8-2 8-2z"/>
  <path fill="#ffc107" d="M64 88c-6 0-10 4-10 4s4 4 10 4s10-4 10-4-4-4-10-4"/>
</svg>''';

const _militaryMedalSvg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128">
  <path fill="#176bc6" d="M35.96 3.19c-.46.28-.2 24.41.09 24.9c.36.61 5.11 5.04 9.34 8.73c3.31 2.88 6.23.86 6.78.86c1.25 0 22.25.23 22.88.23c.26 0 3.98 2.17 7.11-.49c4.45-3.8 9.8-8.57 9.89-9.27c.09-.68.10-24.66-.23-24.87c-.15-.10-3.94-.16-9.23-.22c-4.5-.05-13.67 2.26-19.52 2.24c-7.50-.02-11.79-2.36-17.63-2.31c-5.35.04-9.31.09-9.48.20"/>
  <path fill="#fff" d="m45.42 2.96l-.03 33.86s1.64 1.46 3.29 2.81c1.56 1.28 3.13 2.45 3.25 2.44c1.09-.08 23.76.48 24.23.25c.26-.13 1.95-1.46 3.54-2.77c1.23-1.02 2.48-2.10 2.48-2.10l.45-34.41s-2.84-.01-6.56-.04c-.02 0-9.26 1.08-12.76 1.09c-4.20.01-8.04-1.16-11.74-1.16c-4.28 0-6.15.03-6.15.03"/>
  <path fill="#db0d2a" d="M51.82 42.10c-.63-.47-.26-39.17-.26-39.17s4.14-.05 12.93-.01c7.66.03 11.58.08 11.58.08s.36 38.64-.03 39.27s-6.80 3.83-11.18 3.90s-12.73-3.83-13.04-4.07"/>
  <path fill="#fbc21f" d="M64.25 52.54c2.08-.12 12.26-9.96 12.07-10.28c-.13-.22-6.19-.25-12.31-.28s-12.27-.16-12.30.06c-.05.43 9.98 10.65 12.54 10.50"/>
  <path fill="#fbc21f" d="M63.99 50.82c-.69 0-1.16 1.30-1.57 2.18S51.68 76.93 51.55 77.14c-.14.20-23.35.41-24.44.55s-1.89.54-1.89 1.02s-.15 1.46.46 1.93c.61.48 19.42 16.04 19.42 16.38s-6.14 24.95-6.07 25.50s.42 1.13.83 1.47s.69.33 1.38.18c1.29-.28 21.63-12.77 21.91-12.70c.27.07 21.18 12.36 21.72 12.43c.55.07 1.16 0 1.56-.28s.81-1.35.60-2.10c-.20-.75-4.42-22.44-4.28-22.85s18.07-15.89 18.46-16.16c.57-.4.73-1.62.02-2.23c-.58-.50-23.12-.69-24.06-.66c-.53.02-1.01.30-1.44.61"/>
</svg>''';

const _stopwatchSvg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128">
  <path fill="#504534" d="M68.324 17.126v11.04h-8.71v-11.04z"/>
  <path fill="#504534" d="M55.19 6.84c0-.7.39-1.35 1.02-1.66C57.3 4.63 59.54 4 64 4s6.7.63 7.8 1.18c.63.31 1.02.96 1.02 1.66v9.01c0 1.35-1.26 1.54-2.28 1.54l-13.6-.16c-1.57-.22-1.73-.36-1.73-1.38V6.84z"/>
  <ellipse cx="64" cy="16.56" fill="#504534" rx="8.65" ry="1.56"/>
  <path fill="#504534" d="M106.34 22.61a1.54 1.54 0 0 1 1.59-.38c.98.33 2.68 1.28 5.33 3.93s3.6 4.35 3.93 5.33c.19.56.03 1.17-.38 1.59l-5.35 5.35c-.8.8-1.66.17-2.27-.44l-7.99-8.18c-.8-1.06-.82-1.24-.21-1.85z"/>
  <path fill="#8d6e63" d="M64 28c-22.09 0-40 17.91-40 40s17.91 40 40 40s40-17.91 40-40s-17.91-40-40-40m0 72c-17.67 0-32-14.33-32-32s14.33-32 32-32s32 14.33 32 32s-14.33 32-32 32"/>
  <path fill="#d7ccc8" d="M64 32c-19.88 0-36 16.12-36 36s16.12 36 36 36s36-16.12 36-36s-16.12-36-36-36m0 64c-15.46 0-28-12.54-28-28s12.54-28 28-28s28 12.54 28 28s-12.54 28-28 28"/>
  <path fill="#504534" d="M64 36v32l22.63 13.22"/>
  <path fill="#8d6e63" d="M64 68l-4-4V36h8v28z"/>
</svg>''';

const _lockKeySvg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128">
  <path fill="#e2a610" d="M85.86 62.7h-.01c-.12-2.45-2.72-4.74-7.21-6.09c-9.61-2.89-20.27-4.58-32.43-4.68c-12.15.1-22.81 1.79-32.43 4.68c-4.49 1.35-7.07 3.64-7.2 6.09h-.01v50.08c0 2.79 3.02 5.8 10.26 7.85c7.48 2.12 17.6 3.49 29.38 3.49s21.9-1.37 29.38-3.49c7.59-2.15 10.39-5.32 10.27-8.25z"/>
  <path fill="#4e342e" d="m54.11 108.24l-4.49-10.58a7.66 7.66 0 0 0 4.33-6.9c0-4.24-3.44-7.67-7.67-7.67s-7.67 3.44-7.67 7.67c0 2.85 1.56 5.34 3.87 6.66l-4.18 10.89c-.53 1.38.49 2.85 1.96 2.85h11.92c1.5 0 2.52-1.54 1.93-2.92"/>
  <path fill="#9e740b" d="M53.69 107.26H38.7l-.4 1.05c-.53 1.38.49 2.85 1.96 2.85h11.92c1.51 0 2.52-1.54 1.93-2.92z"/>
  <path fill="#fdd835" d="M22.22 62.7c.13-2.46 2.72-4.74 7.21-6.09c9.61-2.89 20.27-4.58 32.43-4.68c12.15.1 22.81 1.79 32.43 4.68c4.49 1.35 7.07 3.64 7.2 6.09"/>
  <path fill="#84b0c1" d="M13.85 50.18V31.16c0-16.14 13.09-29.24 29.24-29.24h2.03c16.14 0 29.24 13.09 29.24 29.24v19.02"/>
  <path fill="#b9e4ea" d="M17.85 49.18V31.16c0-14.55 11.8-26.35 26.35-26.35h2.03c14.55 0 26.35 11.8 26.35 26.35v18.02"/>
  <circle cx="41.85" cy="40" fill="#4e342e" r="7"/>
  <path fill="#4e342e" d="M41.85 47v15"/>
</svg>''';
