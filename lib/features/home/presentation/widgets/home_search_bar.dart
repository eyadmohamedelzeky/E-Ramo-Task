import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'section_header.dart';

/// Grey "كيف يمكننا مساعدتك" search field under the header. Submitting (the
/// keyboard search action or the magnifier) validates the query and hands it
/// to [onSearch].
class HomeSearchBar extends StatefulWidget {
  const HomeSearchBar({super.key, required this.onSearch});

  static const fieldKey = ValueKey('home-search-field');
  static const submitKey = ValueKey('home-search-submit');
  static const clearKey = ValueKey('home-search-clear');

  static const hint = 'كيف يمكننا مساعدتك';
  static const minQueryLength = 2;
  static const tooShortMessage = 'اكتب حرفين على الأقل للبحث';

  static const height = 37.0;

  final ValueChanged<String> onSearch;

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Rebuild to show / hide the clear button.
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final query = _controller.text.trim();
    if (query.length < HomeSearchBar.minQueryLength) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text(HomeSearchBar.tooShortMessage)),
        );
      return;
    }
    _focusNode.unfocus();
    widget.onSearch(query);
  }

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(6)),
      borderSide: BorderSide.none,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SectionHeader.horizontalPadding,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: HomeSearchBar.height),
        child: TextField(
          key: HomeSearchBar.fieldKey,
          controller: _controller,
          focusNode: _focusNode,
          textInputAction: TextInputAction.search,
          textAlignVertical: TextAlignVertical.center,
          style: AppTextStyles.searchInput,
          cursorColor: AppColors.primary,
          onSubmitted: (_) => _submit(),
          onTapOutside: (_) => _focusNode.unfocus(),
          decoration: InputDecoration(
            hintText: HomeSearchBar.hint,
            hintStyle: AppTextStyles.searchHint,
            filled: true,
            fillColor: AppColors.searchField,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            border: border,
            enabledBorder: border,
            focusedBorder: border,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 32,
              minHeight: HomeSearchBar.height,
            ),
            prefixIcon: Semantics(
              button: true,
              label: 'بحث',
              child: InkResponse(
                key: HomeSearchBar.submitKey,
                onTap: _submit,
                radius: 18,
                child: const Padding(
                  padding: EdgeInsetsDirectional.only(start: 8, end: 4),
                  child: Icon(
                    Icons.search_rounded,
                    size: 20,
                    color: AppColors.searchHint,
                  ),
                ),
              ),
            ),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 36,
              minHeight: HomeSearchBar.height,
            ),
            suffixIcon: _controller.text.isEmpty
                ? null
                : IconButton(
                    key: HomeSearchBar.clearKey,
                    tooltip: 'مسح',
                    onPressed: _controller.clear,
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: AppColors.searchHint,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
