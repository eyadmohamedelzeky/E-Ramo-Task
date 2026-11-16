import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../models/promo_slide.dart';
import 'app_sheet.dart';

/// Contact form opened by the banners' "تواصل الآن" buttons and the drawer's
/// "أضف عقارك" / "خدمة العملاء" / "إنضم إلينا". [subject] is recorded with the
/// request and [description] is shown above the fields. Returns the
/// validated [ContactRequest], or `null` if the sheet was dismissed.
Future<ContactRequest?> showContactRequestSheet(
  BuildContext context, {
  required String subject,
  required String description,
  String title = ContactRequestForm.defaultTitle,
}) {
  return showModalBottomSheet<ContactRequest>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => ContactRequestForm(
      title: title,
      subject: subject,
      description: description,
    ),
  );
}

class ContactRequestForm extends StatefulWidget {
  const ContactRequestForm({
    super.key,
    required this.subject,
    required this.description,
    this.title = defaultTitle,
  });

  static const defaultTitle = 'تواصل معنا';
  static const submitLabel = 'إرسال الطلب';
  static const nameError = 'من فضلك أدخل الاسم';
  static const phoneError = 'أدخل رقم موبايل مصري صحيح (11 رقم)';

  /// Egyptian mobile numbers: 010 / 011 / 012 / 015 followed by 8 digits.
  static final phonePattern = RegExp(r'^01[0125]\d{8}$');

  final String title;
  final String subject;
  final String description;

  @override
  State<ContactRequestForm> createState() => _ContactRequestFormState();
}

class _ContactRequestFormState extends State<ContactRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      ContactRequest(
        name: _name.text.trim(),
        phone: _phone.text.trim(),
        subject: widget.subject,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SheetHeader(title: widget.title),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.description,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const ValueKey('contact-name'),
                      controller: _name,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'الاسم',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) =>
                          (value == null || value.trim().length < 2)
                          ? ContactRequestForm.nameError
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      key: const ValueKey('contact-phone'),
                      controller: _phone,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      textDirection: TextDirection.ltr,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(11),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'رقم الموبايل',
                        hintText: '01xxxxxxxxx',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                      validator: (value) =>
                          ContactRequestForm.phonePattern.hasMatch(
                            value?.trim() ?? '',
                          )
                          ? null
                          : ContactRequestForm.phoneError,
                      onFieldSubmitted: (_) => _submit(),
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      key: const ValueKey('contact-submit'),
                      onPressed: _submit,
                      child: const Text(ContactRequestForm.submitLabel),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
