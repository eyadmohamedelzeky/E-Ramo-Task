# E-Ramo Task – Implementation Report

Home page of the E-Ramo real-estate app rebuilt to match the three supplied
design screenshots, as **one continuously scrolling RTL page**.

- Repository: `https://github.com/eyadmohamedelzeky/E-Ramo-Task` (branch `main`)
- Toolchain used: Flutter 3.41.9 (stable) · Dart 3.11.5 · JDK 17 · Windows 10
- Date: 2026-11-16

---

## 1. Project status before the changes

| Item | State found |
|---|---|
| Git | Clean `main`, a single commit (`3c3c3b5 first commit`). |
| Code | Everything in one file, `lib/main.dart` (1,116 lines): `ERamoApp` → `HomeScreen` (StatefulWidget + `setState`). No state-management package, no routing. |
| Dependencies | `cupertino_icons`, `flutter_svg` (declared but unused). |
| Assets | `assets/logo.png` ("Chair Location"), `assets/office_cards.png`, `office_hero.png`, `office_lounge.png`, `office_space.png` (4–10 MB PNGs). **None were declared in `pubspec.yaml`**, so none were bundled or used. |
| Images | All photos loaded from Unsplash over the network (`Image.network`). |
| Tests | `test/widget_test.dart` – 1 smoke test (passing). |
| `flutter analyze` | 10 infos (9 × deprecated `withOpacity`, 1 × `sized_box_for_whitespace`). |
| README | Default Flutter README with a UTF‑16 fragment appended (left untouched). |

**Running the original app** (emulator, captured before any change): top bar
(city picker, notifications, menu), search field, hero carousel ("منزل احلامك
متوفر الان"), "عقارات مميزة في مصر" and "أهم المشاريع العقارية في مصر" grids with
thick yellow borders, an "أحدث الشقق" feature card, a news row, and a bottom
navigation with mismatched icons (`Icons.macro_off` – a crossed-out virus – for
"السوق", the fire icon repeated for "عقاراتي"). Images appeared blank until the
network loaded; the page did not resemble the supplied design.

### Already present vs. required

| Design element | Before | After |
|---|---|---|
| RTL Arabic layout | Partial (`Directionality` around the home body only) | App-wide RTL (incl. bottom sheets) |
| "أحدث الدوبلكس/الشقق/الفيلات في مصر" listing carousels | Missing (only a static apartments card) | Implemented (×3, reusable) |
| "الكل / للبيع / للإيجار" filter | Missing | Implemented, functional |
| "اهم الأخبار" news cards | Different design | Re-implemented to the design |
| "إبحث عن عقارك بالمدينة" city cards | Missing | Implemented |
| Office promo banner with arrows/dots/CTA | Different hero design | Re-implemented to the design |
| Floating bottom nav with raised home button | Different design, wrong icons | Re-implemented to the design |

---

## 2. Screenshot analysis

* Screenshot **1** (217×436): duplex section → news section → floating bottom nav.
* Screenshot **2** (231×698): city section → office banner → apartments section → villas section.
  The blue vertical lines at x = 6–7 and 229–230 are a Figma selection frame, not UI.
* Screenshot **3** is **byte-identical to screenshot 2** (same MD5
  `7d3fc8e3…`), so it contributes no additional section.

Both screenshots share the same scale: the frame is 221 px wide (screenshot 1
is cropped 4 px on the right), i.e. **0.589 px per dp on a 375 dp frame**. All
dimensions below were measured with pixel scripts on the originals.

| Token | Value |
|---|---|
| Page background | `#FCFCFC` |
| Brand teal (active dots, centre nav button, badge text) | `#005879` |
| Inactive dot / purpose badge | `#D9D9D9` |
| Heart | `#E74335` |
| Banner CTA | `#EAB010` |
| Card border / news card bg / news border | `#EFEFEF` / `#F9F9F9` / `#EAEAEA` |
| Nav icon / label | `#484C52` / `#6A6E73` |
| Page side padding | 20 dp |
| Listing card | 334 × 151 dp, radius 12, photo 141 dp wide, next card peeks 13 dp, gap 8 dp |
| City card | 166 × 221 dp, radius 14, gap 9 dp |
| Banner | full-bleed, 134 dp tall, arrows Ø26 dp |
| News card | 221 × 227 dp, photo 108 dp, radius 14 |
| Page dots | Ø7 dp, 16 dp pitch, first page on the **left** |
| Bottom nav | white card inset 15 dp, radius 10/22, raised Ø66 dp button (56 dp teal + 5 dp white ring) |

**Font.** The design's typeface is not specified. Five free Arabic families
(Tajawal, Almarai, IBM Plex Sans Arabic, Cairo, Noto Sans Arabic) were measured
with Flutter's real text shaper against 23 strings from the design. **Cairo**
gave the most consistent sizes per role (titles ≈ 17, "مشاهدة الكل" 14.0,
tabs 12.8–13.2, nav labels 10.6–10.9, price 13.2, specs 12.1, counts 11.9/11.7)
and was bundled (static 400/500/600/700 instances generated from the OFL
variable font, subset to Arabic + Latin, 68 KB each).

---

## 3. Section order and implementation

All sections live in **one `CustomScrollView`** (`HomeFeed`) in the exact
screenshot order. The order is a single list in
`lib/features/home/presentation/home_feed.dart` (`HomeSectionKeys.ordered`).

| # | Screenshot | Section | Widget |
|---|---|---|---|
| 1 | 1 | أحدث الدوبلكس في مصر | `PropertyListingSection` |
| 2 | 1 | اهم الأخبار | `NewsSection` |
| 3 | 2 | إبحث عن عقارك بالمدينة | `CitySection` |
| 4 | 2 | مكتبك لازم يكون انيق (banner) | `PromoBannerCarousel` |
| 5 | 2 | أحدث الشقق في مصر | `PropertyListingSection` |
| 6 | 2 | أحدث الفيلات في مصر | `PropertyListingSection` |
| – | 1 | Floating bottom navigation (fixed, not scrolled) | `HomeBottomNav` |

* **Listing sections** – header + "مشاهدة الكل", `PurposeFilterTabs`, a snapping
  `PageView` (RTL, `padEnds: false`, viewport fraction computed from the screen
  so the next card peeks 13 dp on the left; two cards per row on tablets), and
  `PageDots`. `PropertyCard`: photo on the right with the grey "للبيع/للإيجار"
  tag, price + heart, one-line description, beds/baths/area, location, age
  ("منذ 4 ايام") and the "بواسطة" developer logo.
* **News** – horizontal list of `NewsCard`s (rounded photo, bold title, 4-line
  summary).
* **Cities** – horizontal list of `CityCard`s (photo, centred city name, sale
  and rent counts, bottom gradient for legibility).
* **Banner** – full-bleed `PageView` of the four office photos, dark overlay,
  centred title/subtitle, yellow "تواصل الآن" button, previous/next arrows
  (previous is dimmed on the first slide, as in the design) and dots.
* **Bottom nav** – المطورون · السوق · [home] · العروض · عقاراتى, white floating
  card with the raised teal home/search button. Three icons that have no
  Material equivalent (building + person, building + pin, house + magnifier)
  were drawn as SVGs and rendered with the existing `flutter_svg` dependency.

---

## 4. Functionality

| Element | Behaviour |
|---|---|
| الكل / للبيع / للإيجار | Filters that section's listings; carousel and dots reset to the first card. |
| Listing carousel | Swipe paging with snap; dots follow and are tappable. |
| Heart | Toggles the favourite (shared `FavoritesController`; the state is reflected in sheets too). |
| Listing card tap | Bottom sheet with photo, price, specs, location, developer and favourite button. |
| مشاهدة الكل | Opens a sheet with the full list (listings / news / cities grid). |
| City card | Sheet with the listings whose location is in that city. |
| News card | Sheet with the article. |
| Banner arrows / swipe / dots | Change slides; "previous" disabled on the first slide, "next" on the last. |
| تواصل الآن | Contact form (name + Egyptian mobile `01[0125]xxxxxxxx` validation); on submit a confirmation SnackBar is shown. |
| Bottom nav | Selecting a tab highlights it; the home button returns to the feed, or scrolls the feed to the top if already there; Android back returns to home first. |

**Limitations (no backend exists in the project):** listings, cities, news and
banner content are local data (`HomeContent`); contact requests are kept in
memory only and are not sent anywhere; the four non-home tabs (outside the
supplied design) show an empty state ("لا يوجد محتوى متاح في هذا القسم حالياً")
with a button back to the home page.

---

## 5. Files

### Created

```
lib/core/constants/app_assets.dart
lib/core/theme/app_colors.dart
lib/core/theme/app_text_styles.dart
lib/core/theme/app_theme.dart
lib/core/utils/formatters.dart
lib/features/home/data/home_content.dart
lib/features/home/models/{city,news_article,promo_slide,property_listing}.dart
lib/features/home/state/favorites_controller.dart
lib/features/home/presentation/home_feed.dart
lib/features/home/presentation/home_screen.dart
lib/features/home/presentation/widgets/{section_header,purpose_filter_tabs,page_dots,
    property_card,developer_logo,property_listing_section,news_section,city_section,
    promo_banner_carousel,home_bottom_nav}.dart
lib/features/home/presentation/sheets/{app_sheet,listings_sheet,property_details_sheet,
    cities_sheet,news_sheets,contact_request_sheet}.dart
assets/images/  (22 JPEGs, 3.7 MB)
assets/icons/   developers.svg, my_properties.svg, home_search.svg
assets/fonts/   Cairo-{Regular,Medium,SemiBold,Bold}.ttf + OFL.txt
test/helpers/test_app.dart
test/home_page_test.dart
test/unit_test.dart
E_RAMO_IMPLEMENTATION_REPORT.md
```

### Modified

* `lib/main.dart` – reduced to the app entry: theme, app-wide RTL, clamped
  text scale (max 1.15), favourites scope, Android edge-to-edge. The old
  single-file screen was replaced by the feature folder above (`ERamoApp` and
  `HomeScreen` keep their names; `main.dart` re-exports `HomeScreen`).
* `pubspec.yaml` – description, `assets/images/`, `assets/icons/`, Cairo font.
* `test/widget_test.dart` – **formatting only** (`dart format` line wrap); the
  test itself is unchanged and passes.
* `pubspec.lock` – transitive versions re-resolved by Flutter 3.41.9
  (`characters`, `matcher`, …); no direct dependency changed.
* `linux/`, `macos/`, `windows/` generated plugin registrants – line endings
  only (rewritten by `flutter pub get`), no content change.

### Removed

Nothing. The original `assets/*.png` files are untouched.

### Assets

* **Banner** – `banner_office_{1..4}.jpg` are 1440 px JPEG copies of the
  project's own `office_hero/lounge/space/cards.png` (4–10 MB each originals,
  kept in the repo but not bundled).
* **Photos** – free images under the Unsplash License, chosen to match each
  design photo, bundled (no network needed):

| File | Subject | Source |
|---|---|---|
| duplex_1 | White modern living room | images.unsplash.com/photo-1600607687939-ce8a6c25118c |
| duplex_2 | Modern house exterior | photo-1600566753190-17f0baa2a6c3 |
| duplex_3 | Modern house at dusk | photo-1600585154340-be6161a56a0c |
| duplex_4 | Modern two-storey house | photo-1600047509807-ba8f99d2cdde |
| apartment_1 | Bright living room, tall windows | photo-1600210492486-724fe5c67fb0 |
| apartment_2 | Living room, beige sofa | photo-1618221195710-dd6b41faaea6 |
| apartment_3 | Apartment living room | photo-1502672260266-1c1ef2d93688 |
| apartment_4 | Apartment interior | photo-1522708323590-d24dbb6b0267 |
| villa_1 | White villa, palm, pool | photo-1564013799919-ab600027ffc6 |
| villa_2 | White villa with pool | photo-1613490493576-7fde63acd811 |
| villa_3 | Villa with pool | photo-1580587771525-78b9dba3b914 |
| villa_4 | Villa with pool | photo-1600596542815-ffad4c1539a9 |
| city_cairo | Nile & Cairo Tower at sunset | unsplash.com/photos/8Imf_kOVFLA |
| city_giza | Giza pyramids | unsplash.com/photos/geGVinctLMg |
| city_alexandria | Alexandria waterfront | unsplash.com/photos/wBSQOXk-go8 |
| news_1 | Keys over a house model | photo-1560518883-ce09059eeffa |
| news_2 | Keys, house models, calculator | unsplash.com/photos/R2mMFDpe1eM |
| news_3 | House exterior | photo-1570129477492-45c003edd2be |

  No free "thumbs-up with house model" photo (second news card in the design)
  was available; a real-estate keys/house-models photo is used instead.
* **Developer logo** – the design's red "GG" mark is a third-party logo that is
  not in the project; it is rendered as a monogram widget from the listing's
  developer data (red "GG" + caption in a white oval).
* The repo's `assets/logo.png` ("Chair Location") does not appear in the
  design and is not used.

## 6. Dependencies

**No packages added or changed.** `flutter_svg` (already declared) is now used
for the nav icons. The Cairo font is bundled as an asset (SIL OFL 1.1, licence
in `assets/fonts/OFL.txt`).

---

## 7. Testing

<!-- RESULTS -->
