import 'package:flutter/material.dart';

/// Colour tokens sampled from the supplied design screenshots.
abstract final class AppColors {
  /// Page background (#FCFCFC in the design).
  static const background = Color(0xFFFCFCFC);

  /// Listing cards use the page colour and are defined by their border.
  static const card = background;
  static const surface = Color(0xFFFFFFFF);

  /// Brand teal used by the active page dots and the centre nav button.
  static const primary = Color(0xFF005879);

  static const textPrimary = Color(0xFF000000);
  static const textBody = Color(0xFF1F1F1F);
  static const textMuted = Color(0xFF858585);
  static const textSubtle = Color(0xFF6C6C6C);
  static const textCaption = Color(0xFF3F3F3F);

  static const tabSelected = Color(0xFF3A3A3A);
  static const tabInactive = Color(0xFFB4B4B4);
  static const tabDivider = Color(0xFFC9C9C9);

  static const cardBorder = Color(0xFFEFEFEF);
  static const newsCardBackground = Color(0xFFF9F9F9);
  static const newsCardBorder = Color(0xFFEAEAEA);

  static const badgeBackground = Color(0xFFD9D9D9);
  static const dotInactive = Color(0xFFD9D9D9);

  static const favorite = Color(0xFFE74335);
  static const accent = Color(0xFFEAB010);

  static const navIcon = Color(0xFF484C52);
  static const navLabel = Color(0xFF6A6E73);

  static const developerRed = Color(0xFFE31E24);
  static const developerNavy = Color(0xFF3B4A6B);

  /// "امتلك" word mark (the square mark uses [primary]).
  static const logoText = Color(0xFF01425A);

  /// Header icons (chat, bell, menu).
  static const headerIcon = Color(0xFF2B2B2B);

  /// Red unread-count bubbles.
  static const badge = favorite;

  static const searchField = Color(0xFFEEEEEF);
  static const searchHint = Color(0xFF909094);

  /// "عقارات مميزة": card outline, "مميز" pill and purpose tag.
  static const featured = Color(0xFFFFC700);

  /// "اهم المشاريع": card outline and "مشروع" pill.
  static const project = Color(0xFF34A851);

  static const drawerBackground = Color(0xFFFCFCFC);
  static const drawerTile = Color(0xFFF8F8F8);
  static const divider = Color(0xFFEAEAEA);
  static const navy = Color(0xFF1F3567);
}
