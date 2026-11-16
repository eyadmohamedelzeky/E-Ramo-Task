/// Formats an integer with comma thousands separators, e.g. 4000000 →
/// "4,000,000" (the design uses Latin digits).
String formatThousands(int value) {
  final digits = value.abs().toString();
  final buffer = StringBuffer(value < 0 ? '-' : '');
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

/// Relative listing age in Arabic, matching the design's "منذ 4 ايام".
String formatListedAgo(int days) {
  if (days <= 0) return 'اليوم';
  if (days == 1) return 'منذ يوم';
  if (days == 2) return 'منذ يومين';
  if (days <= 10) return 'منذ $days ايام';
  return 'منذ $days يوم';
}

/// Harakat (U+064B–U+0652), superscript alef (U+0670) and tatweel (U+0640).
final _arabicDiacritics = RegExp('[\u064B-\u0652\u0670\u0640]');

/// أ إ آ ٱ
final _alefVariants = RegExp('[\u0623\u0625\u0622\u0671]');
final _whitespace = RegExp(r'\s+');

/// Folds spelling variants so searches are forgiving: strips diacritics and
/// tatweel, unifies alef forms (أ إ آ → ا), ة → ه and ى → ي, lower-cases
/// Latin text and collapses whitespace.
String normalizeArabic(String text) => text
    .toLowerCase()
    .replaceAll(_arabicDiacritics, '')
    .replaceAll(_alefVariants, '\u0627')
    .replaceAll('\u0629', '\u0647')
    .replaceAll('\u0649', '\u064A')
    .replaceAll(_whitespace, ' ')
    .trim();
