import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../models/promo_slide.dart';
import 'page_dots.dart';

/// Full-bleed promotional banner (hero "منزل احلامك الآن متوفر" and office
/// banner "مكتبك لازم يكون انيق") with swipe paging and tappable dots. Paging
/// runs left-to-right like the design (first dot on the left). The design's
/// previous / next arrows were removed on request.
class PromoBannerCarousel extends StatefulWidget {
  const PromoBannerCarousel({
    super.key,
    required this.slides,
    required this.onCtaTap,
  });

  /// 134dp tall on a 375dp-wide frame.
  static const heightFactor = 134 / 375;

  final List<PromoSlide> slides;
  final ValueChanged<PromoSlide> onCtaTap;

  @override
  State<PromoBannerCarousel> createState() => _PromoBannerCarouselState();
}

class _PromoBannerCarouselState extends State<PromoBannerCarousel> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goTo(int page) {
    if (page < 0 || page >= widget.slides.length) return;
    _controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.slides.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final height = math.min(
              math.max(
                constraints.maxWidth * PromoBannerCarousel.heightFactor,
                120.0,
              ),
              260.0,
            );
            return SizedBox(
              height: height,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: PageView.builder(
                  controller: _controller,
                  itemCount: count,
                  onPageChanged: (page) => setState(() => _page = page),
                  itemBuilder: (context, index) => _PromoSlideView(
                    slide: widget.slides[index],
                    onCtaTap: () => widget.onCtaTap(widget.slides[index]),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 11),
        PageDots(count: count, current: _page, onDotTap: _goTo),
      ],
    );
  }
}

class _PromoSlideView extends StatelessWidget {
  const _PromoSlideView({required this.slide, required this.onCtaTap});

  final PromoSlide slide;
  final VoidCallback onCtaTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          slide.imageAsset,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.medium,
        ),
        const ColoredBox(color: Color(0x61000000)),
        Directionality(
          textDirection: TextDirection.rtl,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 56),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    slide.title,
                    style: AppTextStyles.bannerTitle,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 220),
                    child: Text(
                      slide.subtitle,
                      style: AppTextStyles.bannerSubtitle,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 9),
                  _CtaButton(label: slide.ctaLabel, onTap: onCtaTap),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CtaButton extends StatelessWidget {
  const _CtaButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.accent,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        key: const ValueKey('banner-cta'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        // Sized to its label (min 80 x 23dp) like the design; an `alignment`
        // here would stretch the button across the banner.
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 80, minHeight: 23),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            child: Center(
              widthFactor: 1,
              heightFactor: 1,
              child: Text(label, style: AppTextStyles.bannerCta),
            ),
          ),
        ),
      ),
    );
  }
}
