import 'package:flutter/material.dart';

void main() => runApp(const ERamoApp());

class ERamoApp extends StatelessWidget {
  const ERamoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ERamo Task',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF4F3F1),
        fontFamily: 'sans-serif',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedBottomNav = 0;
  int _activeHeroIndex = 0;
  final PageController _heroController = PageController();

  final List<Map<String, String>> heroSlides = const [
    {
      'image':
          'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=1200&q=80',
      'title': 'منزل احلامك متوفر الان ',
      'subtitle': 'تواصل الآن',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1494526585095-c41746248156?auto=format&fit=crop&w=1200&q=80',
      'title': 'مثل أحلامك',
      'subtitle': 'تواصل الآن',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1484154218962-a197022b5858?auto=format&fit=crop&w=1200&q=80',
      'title': 'مثل أحلامك',
      'subtitle': 'تواصل الآن',
    },
  ];

  final List<PropertyItem> featuredProperties = const [
    PropertyItem(
      title: 'شقة عصرية',
      subtitle: 'شقة سكنية صغيرة مفروشة',
      price: '4,000,000 ج.م',
      image:
          'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=900&q=80',
      area: '142 م²',
      city: 'القاهرة',
      rooms: '3 غرف',
      favorite: true,
    ),
    PropertyItem(
      title: 'فيلا عائلية',
      subtitle: 'شقة سكنية صغيرة مفروشة',
      price: '4,000,000 ج.م',
      image:
          'https://images.unsplash.com/photo-1494526585095-c41746248156?auto=format&fit=crop&w=900&q=80',
      area: '162 م²',
      city: 'الجيزة',
      rooms: '4 غرف',
      favorite: true,
    ),
  ];

  final List<PropertyItem> cityProjects = const [
    PropertyItem(
      title: 'مشروع سكني',
      subtitle: 'بناء سعودي حديث في أفضل موقع',
      price: '3,500,000 ج.م',
      image:
          'https://images.unsplash.com/photo-1460317442991-0ec209397118?auto=format&fit=crop&w=900&q=80',
      area: '102 م²',
      city: 'المدينة',
      rooms: '2 غرف',
      favorite: false,
    ),
    PropertyItem(
      title: 'فيلا راقية',
      subtitle: 'فيلا عائلية مع حديقة ومواقف',
      price: '5,800,000 ج.م',
      image:
          'https://images.unsplash.com/photo-1448630360428-65456885c650?auto=format&fit=crop&w=900&q=80',
      area: '120 م²',
      city: 'القاهرة',
      rooms: '3 غرف',
      favorite: true,
    ),
  ];

  void _goToSlide(int index) {
    final nextIndex = (index + heroSlides.length) % heroSlides.length;
    _heroController.animateToPage(
      nextIndex,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
    setState(() => _activeHeroIndex = nextIndex);
  }

  @override
  void dispose() {
    _heroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F1F0),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildTopBar(),
                    _buildSearchBar(),
                    _buildHeroCarousel(),
                    _buildSectionHeader(
                      title: 'عقارات مميزة في مصر',
                      trailingText: 'مشاهدة الكل',
                    ),
                    _buildGridCards(featuredProperties),
                    _buildSectionHeader(
                      title: 'أهم المشاريع العقارية في مصر',
                      trailingText: 'مشاهدة الكل',
                    ),
                    _buildGridCards(cityProjects),
                    _buildSectionHeader(
                      title: 'أحدث الشقق في مصر',
                      trailingText: 'مشاهدة الكل',
                    ),
                    _buildFeatureCard(
                      PropertyItem(
                        title: 'شقة في القاهرة',
                        subtitle: 'شقة سكنية صغيرة مفروشة',
                        price: '4,000,000 ج.م',
                        image:
                            'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=900&q=80',
                        area: '105 م²',
                        city: 'القاهرة',
                        rooms: '2 غرف',
                        favorite: true,
                      ),
                    ),
                    _buildSectionHeader(
                      title: 'أهم الأخبار',
                      trailingText: 'مشاهدة الكل',
                    ),
                    _buildNewsCards(),
                  ],
                ),
              ),
              _buildBottomNav(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      color: const Color(0xFFF2F2F1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'القاهرة',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E2126),
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF1E2126),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(
                    Icons.notifications_none_rounded,
                    size: 22,
                    color: Color(0xFF1E2126),
                  ),
                  Positioned(
                    right: -4,
                    top: -2,
                    child: Container(
                      width: 18,
                      height: 18,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2E7D32),
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '2',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.favorite_border_rounded,
                size: 22,
                color: Color(0xFF1E2126),
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.shopping_bag_outlined,
                size: 22,
                color: Color(0xFF1E2126),
              ),
            ],
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.menu_rounded,
              size: 30,
              color: Color(0xFF1F2328),
            ),
            splashRadius: 18,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints.tightFor(width: 30, height: 30),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Row(
        children: [
          Icon(Icons.search_rounded, color: Color(0xFF7A7C80), size: 28),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'كيف يمكننا مساعدتك',
              textAlign: TextAlign.right,
              style: TextStyle(color: Color(0xFF8A8D92), fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCarousel() {
    return Column(
      children: [
        Container(
          height: 220,
          child: Stack(
            children: [
              PageView.builder(
                controller: _heroController,
                itemCount: heroSlides.length,
                onPageChanged: (index) =>
                    setState(() => _activeHeroIndex = index),
                itemBuilder: (context, index) {
                  final slide = heroSlides[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          slide['image']!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFB9D4E3),
                                      Color(0xFFD3D0C7),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.home_work_rounded,
                                    size: 48,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.16),
                                Colors.black.withOpacity(0.42),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 150,
                          bottom: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                slide['title']!,
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: const Color(0xFFFFC544),
                                ),
                                child: Text(
                                  slide['subtitle']!,
                                  textDirection: TextDirection.rtl,
                                  style: const TextStyle(
                                    color: Color(0xFF1D1F22),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 12,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: GestureDetector(
                              onTap: () => _goToSlide(_activeHeroIndex - 1),
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.25),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.6),
                                    width: 1,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 12,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: GestureDetector(
                              onTap: () => _goToSlide(_activeHeroIndex + 1),
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.25),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.6),
                                    width: 1,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            heroSlides.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: _activeHeroIndex == index ? 18 : 10,
              height: 10,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: _activeHeroIndex == index
                    ? const Color(0xFF1A7AF6)
                    : const Color(0xFFD2D2D2),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String trailingText,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 18, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                title,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                softWrap: true,
                maxLines: 2,
                style: const TextStyle(
                  color: Color(0xFF1D1F22),
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            trailingText,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              color: Color(0xFF2B2E32),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridCards(List<PropertyItem> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: items
            .map((item) => Expanded(child: _buildPropertyCard(item)))
            .toList(),
      ),
    );
  }

  Widget _buildPropertyCard(PropertyItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFFFC544), width: 3),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Image.network(
                    item.image,
                    width: double.infinity,
                    height: 162,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 162,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFCCD9E5), Color(0xFFD6D1C8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.home_work_rounded,
                          size: 36,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  top: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C2D44),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'مميز',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_rounded,
                      size: 16,
                      color: Color(0xFFFF4D4D),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E2126),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFC544),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'مميز',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1B1F22),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6A6F74),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        size: 14,
                        color: Color(0xFF7A7D80),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.city,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B6E72),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.king_bed_rounded,
                        size: 14,
                        color: Color(0xFF7A7D80),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.rooms,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B6E72),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.square_foot_rounded,
                        size: 14,
                        color: Color(0xFF7A7D80),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.area,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B6E72),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.price,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E2126),
                          ),
                        ),
                      ),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1C2D44),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(PropertyItem item) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF4F4F4),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_rounded,
                          color: Color(0xFFFF5757),
                          size: 20,
                        ),
                      ),
                      Text(
                        item.city,
                        style: const TextStyle(
                          color: Color(0xFF2D3135),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1D1F22),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.price,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1D1F22),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.bed_rounded,
                        size: 18,
                        color: Color(0xFF80858A),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item.rooms,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF5D626A),
                        ),
                      ),
                      const SizedBox(width: 18),
                      const Icon(
                        Icons.square_foot_rounded,
                        size: 18,
                        color: Color(0xFF80858A),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item.area,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF5D626A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(24),
            ),
            child: Image.network(
              item.image,
              width: 170,
              height: 210,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 170,
                height: 210,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFC9D5DE), Color(0xFFAFBAC5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.home, size: 42, color: Colors.white70),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCards() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      child: Row(
        children: [
          Expanded(
            child: _buildNewsCard(
              title: 'أحدث سوق العقارات',
              subtitle: 'الخيارات المتاحة الآن في السوق',
              image:
                  'https://images.unsplash.com/photo-1560518883-ce09059eeffa?auto=format&fit=crop&w=900&q=80',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildNewsCard(
              title: 'شراء الديار',
              subtitle: 'عقارات فاخرة في أفضل المواقع',
              image:
                  'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=900&q=80',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard({
    required String title,
    required String subtitle,
    required String image,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
            child: Image.network(
              image,
              height: 170,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 170,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFCCE1E7), Color(0xFFD8D2C6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.article_rounded,
                    size: 42,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1C1E22),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF5C6066),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      {'label': 'السوق', 'icon': Icons.macro_off},
      {'label': 'المطورون', 'icon': Icons.apartment_rounded},
      {'label': '', 'icon': Icons.home_rounded},
      {'label': 'العروض', 'icon': Icons.local_fire_department_rounded},
      {'label': 'عقاراتي', 'icon': Icons.local_fire_department_rounded},
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final selected = index == _selectedBottomNav;

          if (index == 2) {
            return GestureDetector(
              onTap: () => setState(() => _selectedBottomNav = index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0E6C7A),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0E6C7A).withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.search_rounded,
                      size: 34,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['label'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1B1F22),
                    ),
                  ),
                ],
              ),
            );
          }

          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedBottomNav = index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFFF3F7F8)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      size: 28,
                      color: selected
                          ? const Color(0xFF1B1F22)
                          : const Color(0xFF6D7278),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['label'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? const Color(0xFF1B1F22)
                          : const Color(0xFF6D7278),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class PropertyItem {
  final String title;
  final String subtitle;
  final String price;
  final String image;
  final String area;
  final String city;
  final String rooms;
  final bool favorite;

  const PropertyItem({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.image,
    required this.area,
    required this.city,
    required this.rooms,
    required this.favorite,
  });
}
