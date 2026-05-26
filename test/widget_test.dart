import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nakhlah/constants/app_theme.dart';

void main() {
  test('Nakhlah app uses pure white screen background', () {
    expect(AppTheme.light.scaffoldBackgroundColor, Colors.white);
    expect(AppTheme.light.appBarTheme.backgroundColor, Colors.white);
  });

  test('mascot SVG asset exists for home screen decoration', () {
    expect(
      File('assets/nakhlah_web/mascot.svg').existsSync(),
      isTrue,
    );
  });
}
