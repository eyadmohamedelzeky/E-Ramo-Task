class PromoSlide {
  const PromoSlide({
    required this.imageAsset,
    required this.title,
    required this.subtitle,
    this.ctaLabel = 'تواصل الآن',
  });

  final String imageAsset;
  final String title;
  final String subtitle;
  final String ctaLabel;
}

/// A contact request captured by the banner's "تواصل الآن" form.
///
/// The project has no backend, so requests are only kept in memory.
class ContactRequest {
  const ContactRequest({
    required this.name,
    required this.phone,
    required this.subject,
  });

  final String name;
  final String phone;
  final String subject;
}
