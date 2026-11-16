# E-Ramo Task – Updated UI Report (new screenshot set)

This update brings the existing E-Ramo home page in line with the **new**, complete set of three design screenshots. The app is still **one continuously scrolling RTL page**. The previous implementation was extended, not rebuilt. Its architecture, widgets, tests and conventions were kept.

- Repository: `C:\Users\Eyad\Documents\GitHub\E-Ramo-Task` (branch `main`, nothing committed)
- Toolchain: Flutter 3.41.9 (stable), Windows 10
- Date: 2026-11-16
- Previous report, left untouched: `E_RAMO_IMPLEMENTATION_REPORT.md`
- Visual evidence: `docs/ui-update/*.jpg`. Each image shows the design on the left and the app on the right, at the same dp scale. They were captured before the follow-up changes in §12, so they still show the carousel arrows and the right-hand panel.
- **Follow-up (§12):**
  - Carousel arrows removed.
  - Native splash shows the "امتلك" logo.
  - The launcher icon is the logo mark on Android (adaptive) and iOS.
  - App renamed "امتلك" on Android and iOS.
  - The "المزيد" panel now opens from the left, next to its menu button.

---

## 1. Existing implementation status (before this update)

| Item | State found |
|---|---|
| Git | One commit (`3c3c3b5 first commit`). The previous implementation is uncommitted work in the tree: `lib/core/**`, `lib/features/home/**`, tests and assets. |
| Architecture | `lib/core` holds theme, assets and formatters. `lib/features/home` holds `data`, `models`, `state` (an `InheritedNotifier` favourites controller) and `presentation` (feed, sheets, widgets). No state-management or network packages. |
| Page content | Duplex section → news → city cards → office banner → apartments → villas, plus the floating bottom nav. |
| Previous references | Old shot 1: duplex/news/nav. Old shots 2 and 3 were byte-identical: cities → villas. They had no header, search bar, hero, featured section, projects section or drawer. |
| `flutter analyze` | No issues |
| Tests | 26 (8 unit + 1 smoke + 17 widget), all passing |
| Emulator baseline | Captured before any change: the page opened on the duplex section with no header. Reproduced from `E:\claude-emu-scratch\eramo-before-debug-x64.apk`. |

The original `main.dart` in the first commit had a header, search field, hero and "featured / projects" grids. The previous implementation removed them because the old screenshots did not show them. The new screenshots bring them back with a different, precise design, and they are re-implemented here from the new references.

## 2. Differences identified (old implementation vs new references)

The new set is `Desktop\1.png` (391×721), `2.png` (240×964) and `3.png` (238×474). The page is 240 px wide, which is 375 dp at 0.64 px/dp. Screenshot 1 is cropped 12 px on the left; this was confirmed by the shared projects section and the centred logo. Screenshot 1 also contains the side-menu frame "Frame 34343".

| # | Screenshot | Element | Old implementation | Action |
|---|---|---|---|---|
| 1 | 1 | Header: centred "امتلك" logo (teal mark, word mark with kashida, tagline) | missing | **added** |
| 2 | 1 | Header row: "القاهرة ⌄" city picker (start); chat with red badge "5", bell with "2", hamburger menu | missing | **added** |
| 3 | 1 | Grey search field "كيف يمكننا مساعدتك" with magnifier | missing | **added** |
| 4 | 1 | Hero carousel "منزل احلامك الآن متوفر", subtitle, yellow "تواصل الآن", arrows, 4 dots | missing | **added** (reuses `PromoBannerCarousel`) |
| 5 | 1 | "عقارات مميزة في مصر": "مشاهدة الكل", الكل/للبيع/للإيجار tabs, vertical cards with gold outline, "★ مميز" pill, gold purpose tag, rent price "4,000 ج.م شهريا" | missing | **added** |
| 6 | 1 + 2 | "اهم المشاريع العقارية في مصر": vertical cards with green outline, "مشروع" pill, name + heart, summary, location, age, developer | missing | **added** |
| 7 | 1 | "المزيد" drawer: back chevron, Egypt flag selector, profile (avatar, name, city), 10 menu tiles, badges 2/5, red logout | missing | **added** |
| 8 | 2 → 3 | **Section order**: cities → banner → apartments → villas → **duplex → news** | duplex + news were *first* | **reordered** |
| 9 | 1–3 | "تواصل الآن" button is compact (~80×23 dp) | stretched across the banner (`Container` + `alignment` expands) | **fixed** (affects hero and office banner) |
| 10 | 1 | Rent price format "… ج.م شهريا" (muted period) | "… ج.م / شهرياً" | **changed** |
| 11 | 2–3 | City cards, banner, apartments, villas, duplex, news, bottom nav | match the new screenshots | **kept unchanged** |

Checklist results:
- Every new screenshot was inspected in its own crops: header, hero, featured, projects, drawer top and bottom, cities/banner, apartments/villas, duplex/news, nav.
- Colours were sampled from pixels: featured `#FFC700`, project `#34A851`, search field `#EEEEEF`, drawer `#FCFCFC`, tiles `#F8F8F8`, divider `#EAEAEA`, badge `#E74335`, logo `#005879` / `#01425A`.
- Positions were measured in dp from row/column profiles.

## 3. Missing elements added

All of the following sit on the same scroll view, in screenshot order.

1. **`HomeHeader`**: `BrandLogo` (SVG mark + Cairo word mark "امـــتلك" + tagline), city selector, and chat, bell and menu buttons with `CountBadge`s. The badges sit at the icons' bottom-right, as in the design. The row layout reproduces the design's asymmetry: the city sits about 6 dp from the right edge, and the icon group ends 72/375 of the width from the left.
2. **`HomeSearchBar`**: 37 dp grey field with 6 dp radius, magnifier on the start side, a clear button, and the keyboard search action.
3. **Hero carousel**: the existing `PromoBannerCarousel` with `HomeContent.heroSlides`. Dots, swipe and the "تواصل الآن" contact form all work as on the office banner. The design's arrows were later removed on request (§12).
4. **`FeaturedPropertiesSection` / `FeaturedPropertyCard`**: 198×268 dp, 24 dp radius, gold 1.2 dp outline, 131 dp photo, "★ مميز" pill, gold purpose tag (43% of the width, teal text), price/title/specs/location/age/developer, heart, horizontal list with 15 dp gaps and the next card peeking in.
5. **`ProjectsSection` / `ProjectCard`**: same footprint as the featured card, green outline, 140 dp photo, "مشروع" pill with a building icon, name + heart, one-line summary, location/age/developer.
6. **`HomeDrawer`** (232/375 of the width; since §12 it is `Scaffold.endDrawer` and opens from the left in RTL, next to the menu button). The order shown here is the **current** one, changed in §12 from the design's order:
   - profile header first: 50 dp avatar with teal ring, name, city, `‹` chevron
   - divider
   - "المزيد" section title with the white country pill (round Egyptian flag) beside it
   - The design's back chevron next to "المزيد" was removed in §12.
   - ten 45 dp tiles: عقاراتي المفضلة, الإشعارات **(2)**, الدردشة **(5)**, أضف عقارك, شراء باقات (crown SVG), أحدث المشاريع, مركز المساعده, خدمة العملاء, إنضم إلينا, تسجيل الخروج (red)
7. **New assets**:
   - `assets/icons/logo_mark.svg`, `chat_bubbles.svg`, `crown.svg`
   - `assets/images/hero_1-4.jpg`, `featured_1-4.jpg`, `project_1-4.jpg`, `avatar.jpg`: Unsplash photos re-encoded through PIL, 8–122 KB each. Source IDs: hero `1600121848594`, `1616486338812`, `1567767292278`, `1505691938895`; featured `1560448204`, `1617806118233`, `1583847268964`, `1484101403633`; projects `1574958269340`, `1582407947304`, `1580041065738`, `1554435493`; avatar `1507003211169`.
8. **Content** (`HomeContent`): 4 featured listings and 4 projects, plus hero slides, the drawer profile and the unread counts. The first two featured cards and the first project carry the design's exact copy and numbers.

## 4. Existing elements modified

| Element | Change | Why |
|---|---|---|
| `HomeFeed` | New order header → search → hero → featured → projects → cities → banner → apartments → villas → duplex → news. `header` and `onSearch` are injected. | Exact order of the new screenshots |
| `HomeSectionKeys` | 11 keys, now **`PageStorageKey`s** | Fixes the carousel bug in §6 |
| `_CtaButton` (`promo_banner_carousel.dart`) | Sized to its label: min 80×23 dp, no `alignment` | Design shows a compact button; it was full-width |
| `PropertyListing` | `isFeatured`; `priceLabel` is now the amount only, plus `pricePeriodLabel` ("شهريا") and `fullPriceLabel` | New rent format |
| `property_card.dart` | `_ListingDetails` became public `ListingDetails` with padding and flex parameters. Added `ListingPrice` (muted period) and `ListingFooter` (location/age + developer). | Reused by the featured and project cards; no visual change to the horizontal card |
| `property_listing_section.dart` | `_EmptyFilterResult` became public `EmptyFilterResult(height:)` | Reused by the featured section |
| `contact_request_sheet.dart` | `showContactRequestSheet(context, subject:, description:, title:)` instead of a `PromoSlide` | Shared by the hero, the banner and three drawer items |
| `property_details_sheet.dart` | Shows the "مميز" pill for featured listings and the rent period | Consistency |
| `HomeScreen` | `Scaffold` key + drawer, city state, search, and drawer/header action routing. `NavDestinationEmptyView.message` now reuses `UnavailableContent.message`. | New interactions |
| Theme | New colour tokens and text styles (logo, header city, search, badges, project title, drawer, profile, price period) | New components |
| `test/helpers/test_app.dart` | Default test surface 393×4200 → 393×5200 | The page is longer |

## 5. Files changed

**New (lib):**
- `models/project.dart`, `models/user_profile.dart`, `models/search_results.dart`
- `presentation/widgets/`: `brand_logo.dart`, `count_badge.dart`, `home_header.dart`, `home_search_bar.dart`, `featured_property_card.dart`, `featured_properties_section.dart`, `project_card.dart`, `projects_section.dart`, `home_drawer.dart`
- `presentation/sheets/`: `choice_sheet.dart`, `projects_sheet.dart`, `search_results_sheet.dart`, `results_list.dart`, `favorites_sheet.dart`, `unavailable_sheet.dart`

**Modified (lib):**
- `core/constants/app_assets.dart`, `core/theme/app_colors.dart`, `core/theme/app_text_styles.dart`, `core/utils/formatters.dart` (adds `normalizeArabic`)
- `data/home_content.dart`, `models/property_listing.dart`
- `presentation/home_feed.dart`, `presentation/home_screen.dart`
- `widgets/property_card.dart`, `widgets/property_listing_section.dart`, `widgets/promo_banner_carousel.dart`
- `sheets/contact_request_sheet.dart`, `sheets/property_details_sheet.dart`

**Tests:** `test/home_page_test.dart`, `test/unit_test.dart`, `test/helpers/test_app.dart`

**Assets:** 3 SVGs in `assets/icons/` and 13 JPEGs in `assets/images/`. `pubspec.yaml` was unchanged because the asset folders were already declared.

**Docs:** this report and `docs/ui-update/` (7 comparison images, 47–200 KB each)

No dependencies were added.

## 6. Functionality added or updated

| Control | Behaviour |
|---|---|
| City picker "القاهرة ⌄" | Choice sheet of the cities with their sale/rent counts. The selection updates the header label. |
| Search field | Under 2 characters shows the snackbar "اكتب حرفين على الأقل للبحث". Otherwise a results sheet lists matching listings, then projects (tap to open details). Every word must match. Matching ignores case, harakat, tatweel, and أ/إ/آ, ة/ه, ى/ي variants. It covers title, location, purpose, project name, summary and developer. The title wraps the query in Unicode isolates so Latin queries don't scramble the Arabic line. |
| Hero / banner "تواصل الآن" | Validated contact form (name, Egyptian mobile `01[0125]xxxxxxxx`). The request is kept in memory and confirmed with a snackbar. |
| Featured tabs | الكل / للبيع / للإيجار filter, list resets to the start, empty state when nothing matches |
| Featured / project cards | Tap opens the details sheet. The heart toggles the shared favourites. |
| "مشاهدة الكل" (featured, projects) | Full listings sheet / project grid sheet |
| Menu button | Opens the drawer. Its back chevron closes it, and so do the system Back key and a scrim tap. |
| Drawer → عقاراتي المفضلة | Live list of favourited listings and projects; removing a heart updates it immediately |
| Drawer → أحدث المشاريع | All projects sheet |
| Drawer → أضف عقارك / خدمة العملاء / إنضم إلينا | Contact form titled with the item |
| Drawer → country pill | Choice sheet with "مصر", the only market the data covers |
| Header chat / bell; drawer → الإشعارات, الدردشة, شراء باقات, مركز المساعده, profile, تسجيل الخروج | These need a backend that doesn't exist. They open an honest empty state ("لا يوجد محتوى متاح في هذا القسم حالياً"; logout explains that there is no account system). No mock notifications, chats or packages were invented. |

**Bugs fixed in the existing code:**
1. **Carousels opened on their last page.** Any carousel built after the page had scrolled (office banner, apartments, villas, duplex) opened on its last card. Cause: the only `PageStorageKey` was the feed's, so every nested horizontal scrollable shared the feed's storage slot and restored the feed's offset. Fix: a `PageStorageKey` per section. A regression test proves it: without the fix the duplex carousel opens at page 2.96; with it, page 0.
2. **Stretched CTA.** "تواصل الآن" stretched across the whole banner. Fix: the button is sized to its label.

## 7. Test results (actual counts)

Commands from the testing cycle, run in this order on the final code. Logs were captured.

| Command | Result |
|---|---|
| `flutter clean` | OK |
| `flutter pub get` | OK. 15 packages have newer, constraint-incompatible versions; nothing changed. |
| `dart format .` | 52 files, 0 changed |
| `flutter analyze` | **No issues found** |
| `flutter test` | **50 passed, 0 failed** |

Test breakdown:
- `unit_test.dart`: 16 tests (was 8). New: rent price/period labels, `normalizeArabic`, search by words / variants / developer / purpose, featured data, unique listing + project ids, initial favourites exist, design copy of the first featured card, project and hero.
- `widget_test.dart`: 1 test (unchanged).
- `home_page_test.dart`: 33 tests (was 17). New:
  - section order for all 11 sections
  - header: logo, city, badges 2/5, RTL order
  - city picker
  - search validation, results, no-results and clear
  - hero arrows/dots and compact CTA
  - featured content, rent period, filter and details
  - project content, "مشاهدة الكل", details and favourite
  - drawer: items, badges, flag stripes, projects, live favourites, notifications empty state, logout, country, close
  - drawer contact request
  - header chat/bell
  - carousel page-storage regression
  - drawer overflow on 6 screen sizes
  - Updated: end-to-end scroll on 6 sizes, plus text scale 1.6 including the drawer

## 8. Emulator verification

- **Device**: AVD `Pixel_4` (Android 37 x86_64, 1080×2280 @ 440 dpi = 393×829 dp), `emulator-5556`.
- **Emulator setup**:
  - The user's `Pixel34_stable` emulator was hung (adb `offline`) and later exited by itself.
  - `Pixel_4`'s own data partition was 92% full, below Android's install threshold. Rather than delete the apps installed there, it was started with a separate scratch data image: `-data E:\claude-emu-scratch\pixel4-userdata.img`. The AVD's own data is untouched.
- **Runs**:
  - Debug builds (x86_64-only, for install size) after each fix round.
  - The final **release APK**: cold start 5.3 s, `Status: ok`.
- **Logs**: `logcat` showed **0 `E/flutter` or `FATAL EXCEPTION` lines** in the debug runs and in the release run.
- **Whole page**: scrolled top to bottom. Captures were stitched by row registration; the worst seam had a summed-RGB mean difference of 2.8/255. No overflow stripes, clipping or blank images.
- **Interactions verified on the device**, through `uiautomator` with Arabic labels:
  - The drawer opens from the right, and "أحدث المشاريع" closes it and shows "أحدث المشاريع (4)".
  - The favourites sheet lists "العقارات (…)".
  - الإشعارات shows the empty state.
  - The country picker shows "اختر الدولة".
  - The drawer's back chevron closes it.
  - The city picker changes the header to "الجيزة".
  - Search "6" shows the snackbar; search "GG" shows 'نتائج البحث عن "GG" (20)' (16 listings + 4 projects).
  - The featured "للإيجار" filter leaves only the "4,000 ج.م شهريا" card.
  - "تواصل الآن": empty submit shows both errors; "Ahmed / 01012345678" closes the form and shows "تم تسجيل طلب التواصل باسم Ahmed".
  - Back closes sheets; Back on the root page exits.
- **Defects found on the device and fixed**:
  - Both bugs in §6.
  - The Egyptian flag rendered only its eagle: the childless stripes had 0 width in a centred `Column`.
  - The bidi-scrambled search title.
  - A ~4 dp vertical offset in the header block.

## 9. Screenshot comparison results

Each design and app capture are placed side by side at the same dp scale in `docs/ui-update/`:

| Image | Compares |
|---|---|
| `compare_1_header_search_hero.jpg` | Screenshot 1: logo, header row, search, hero, dots |
| `compare_1_featured_projects.jpg` | Screenshot 1: featured and projects cards |
| `compare_2_projects_cities_banner.jpg` | Screenshot 2: projects → cities → office banner |
| `compare_2_apartments_villas.jpg` | Screenshot 2: apartments and villas |
| `compare_3_duplex_news.jpg` | Screenshot 3: duplex and news |
| `compare_drawer.jpg` | Frame 34343 vs the app drawer |
| `app_full_page.jpg` | The whole page as rendered on the emulator |

Measured positions in dp (top block of screenshot 1; design vs app, final release build):

| Element | Design | App |
|---|---|---|
| Logo | 6.2 – 31.2 | 6.2 – 32.7 |
| Header icons row | 68.8 – 95.3 | 68.0 – 92.7 |
| Search field | 96.9 – 132.8 | 97.1 – 133.8 |
| Hero top | 146.9 | 146.9 |
| Projects card top | 815.6 | 816.0 |

Other checks:
- **Featured card:** design 197 dp wide, gap 15, card-relative rows (price +18, specs +65, location +87, age +113 dp below the photo); app 197 dp, gap 16, rows +20, +65, +87, +112.
- **Project card:** 265 vs 266 dp tall, photo 141 vs 139 dp.
- **Section pitch:** apartments → villas 307 vs 310 dp; duplex → news 83 vs 84 dp.
- **Drawer:** tile height 45 dp and pitch 57 dp, matching the frame.

Fix rounds: three capture–compare–fix rounds. Fixes: compact CTA; header spacing (twice); card radius 22 → 24; purpose tag 48% → 43%; kashida word mark; logo height; flag; help-centre icon.

## 10. Debug and release builds

| Command | Result |
|---|---|
| `flutter build apk --debug` | **Built** `build/app/outputs/flutter-apk/app-debug.apk` (150,183,225 bytes; 188,557,630 bytes after the §12 rebuild) |
| `flutter build apk --release` | **Built** `app-release.apk` (**51.0 MB**, 53,453,617 bytes; 53,511,193 bytes after §12) |

The release APK is universal (arm64-v8a, armeabi-v7a, x86_64), and AGP stores native libraries uncompressed. The 21 MB release from the previous session matches a single-ABI x86_64 build. For store distribution, use `--split-per-abi` or an app bundle. The release APK was installed and run on the emulator (§8).

## 11. Remaining issues and notes

1. **Logo**:
   - The design's logo asset isn't in the repo; `assets/logo.png` is an unrelated "Chair Location" logo. The "امتلك" logo is recreated from an SVG mark and Cairo text.
   - The tagline is illegible in the reference; "للتسويق العقاري" is a placeholder.
   - Replace both with the official asset when available.
2. **Photos** are free Unsplash stock chosen to resemble the design (living rooms, a commercial complex, towers). They are not the design's exact images.
3. **No backend**:
   - Notifications, chat, packages, help centre, profile and logout show honest empty states.
   - The badge counts (2, 5) and the profile ("عبدالله محمد", القاهرة) are static design values.
   - Contact requests are kept in memory only.
   - The city picker changes the header city but does not filter content, because there is no per-city feed.
4. **Content choice**: the second featured card is a rental titled "…للإيجار…" where the design's placeholder says "للبيع".
5. **Proportional sizing**: on a 393 dp phone the hero and city cards are ~10 dp taller than the 375 dp design, because they scale with the width as before. Fixed-dp elements match the measured design values.
6. **Existing components kept as-is**:
   - Spec icons (Material bed/bath/area) and the drawn "GG" developer logo differ slightly from the design's custom icons.
   - The hero/banner slide exposes one merged accessibility node that includes the CTA's tap action (unchanged behaviour).
7. **On-device text entry**: `adb input` can't type Arabic, so on-device search used Latin queries. Arabic queries are covered by the widget and unit tests. Gboard's "Try out your stylus" onboarding intercepted `adb input tap` focus; this is emulator system UI and was worked around with touchscreen-source taps.
8. **Concurrent session**: the previous implementation was written by another Claude Code session (`eyad-cc`), which paused while this update was made. Its `E_RAMO_IMPLEMENTATION_REPORT.md` was not modified. Nothing has been committed.
9. **Emulator still running**: `emulator-5556` (Pixel_4 on the scratch data image) is still running. `E:\claude-emu-scratch\` also holds the before/after APKs used for verification.

## 12. Follow-up changes (user feedback)

| Request | Change | Files |
|---|---|---|
| Remove the two carousel arrows | `PromoBannerCarousel` no longer has previous/next arrows. This applies to the hero and the office banner, which are the same component. Slides change by swipe and by tapping the dots. Removed: the `_ArrowButton` class and the three `bannerArrow*` colour tokens. | `widgets/promo_banner_carousel.dart`, `core/theme/app_colors.dart` |
| Replace the native splash image | The Flutter logo is replaced by the "امتلك" logo on the app's page colour `#FCFCFC`. | see below |
| Rename the app on Android and iOS | Android `android:label`, iOS `CFBundleDisplayName` + `CFBundleName`, and `MaterialApp.title` are now **"امتلك"** (the brand in the design). `aapt dump badging` reports `application-label:'امتلك'`. | `android/app/src/main/AndroidManifest.xml`, `ios/Runner/Info.plist`, `lib/main.dart` |
| Replace the app (launcher) icon with the "امتلك" logo | The icon is now the logo's mark: the white glyph on the brand teal `#005879`. The word mark is left out because it is unreadable at icon sizes. Android 8+ gets an **adaptive icon** (`mipmap-anydpi-v26/ic_launcher.xml`: teal background colour, glyph foreground, and the same layer as the Android 13+ **monochrome** themed icon). Older Android versions get the rounded teal tile in `mipmap-*/ic_launcher.png`. **iOS** gets all 19 `AppIcon.appiconset` sizes as opaque full-bleed squares, RGB with no alpha as the App Store requires; iOS applies its own corner mask. | `res/mipmap-*dpi/ic_launcher.png`, `res/mipmap-*dpi/ic_launcher_foreground.png`, `res/mipmap-anydpi-v26/ic_launcher.xml`, `res/values/colors.xml` (`ic_launcher_background`), `ios/Runner/Assets.xcassets/AppIcon.appiconset/*.png`, generator `tool/render_app_icons_test.dart` |
| "المزيد" panel in the wrong place | It slid in from the right while its menu button is on the left of the header. It is now the scaffold's **end drawer**, so in RTL it attaches to the **left** edge, next to the button. Swipe-to-open moves to the left edge. | `presentation/home_screen.dart`, `widgets/home_drawer.dart` |
| "المزيد" title at the top is wrong UX; name and photo should come first | A side menu should open on the user's identity, so the panel now starts with the **profile header** (photo, name, city) right under the status bar. The "المزيد" title moved below it and now titles the list of options, with the country selector kept beside it (the design's pairing). The design's back chevron next to "المزيد" had no meaning there and was removed. The panel closes like any drawer: tap outside, swipe, system Back, or choosing an item. | `widgets/home_drawer.dart`, `test/home_page_test.dart` (asserts the profile → "المزيد" → items order; closes by tapping outside) |

**Splash files changed (no new dependencies):**
- **Images:** rendered from the in-app `BrandLogo` widget by `tool/render_splash_images_test.dart`. It uses Flutter's own text shaping, which Pillow on this machine can't do for Arabic. Regenerate with `flutter test tool/render_splash_images_test.dart`. It sits in `tool/`, outside the normal test run.
- **Logo size:** 175×48 dp everywhere (diagonal 181 dp). That fits the 192 dp circle of the Android 12+ splash icon, and the logo doesn't jump between the system splash, the launch background and Flutter's first frame.
- **Android, all versions:**
  - `res/values/colors.xml` (`splash_background`)
  - `res/drawable/launch_background.xml` and `res/drawable-v21/launch_background.xml` (centred `splash_logo`)
  - `res/drawable-{m,h,xh,xxh,xxxh}dpi/splash_logo.png`
- **Android 12+:**
  - `res/values-v31/styles.xml` and `res/values-night-v31/styles.xml` (`windowSplashScreenBackground` and `windowSplashScreenAnimatedIcon`)
  - `res/drawable-*dpi/splash_icon.png` (288 dp canvas)
  - The splash stays light in dark mode because the app UI is always light.
- **iOS:**
  - `Assets.xcassets/LaunchImage.imageset/LaunchImage{,@2x,@3x}.png` (180×52 pt)
  - `Base.lproj/LaunchScreen.storyboard`: background `#FCFCFC`, image size hint updated

**Verification after the follow-up:**
- `dart format`: no changes.
- `flutter analyze`: no issues (now also covers `tool/`).
- `flutter test`: **50 passed**. The hero/banner tests now page by swipe and dots and assert the arrows are gone; the drawer test asserts the panel's left edge is at x = 0.
- `flutter build apk --debug` and `--release`: both built.
- **Emulator (debug):**
  - Frames captured 0–2 s after a cold launch show the "امتلك" logo splash (Android 12+ system splash) instead of the Flutter logo.
  - The hero shows no arrows.
  - The panel opens on the left.
  - Tapping outside it and choosing "أحدث المشاريع" both close it. Before the profile-first change its back chevron also closed it; the latest layout was re-checked on the emulator: profile header on top, then "المزيد" + flag, then the items. Tapping outside closes it, and "عقاراتي المفضلة" opens the favourites list.
  - logcat shows 0 `E/flutter` or `FATAL EXCEPTION` lines.
- **Launcher icon:**
  - All icons are rendered from `assets/icons/logo_mark.svg`, the same source as the header logo and the splash. Regenerate with `flutter test tool/render_app_icons_test.dart`.
  - Checked: 10 Android PNGs at the right sizes for each density, and all 19 iOS sizes as opaque RGB.
  - `aapt` reports `label='امتلك'` with the adaptive icon, in both the debug and release APKs.
  - On the emulator, the system App-info page shows the masked teal icon above "امتلك".
  - Not changed (not requested): web, macOS and Windows icons are still Flutter's defaults.
