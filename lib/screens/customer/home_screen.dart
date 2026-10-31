import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/service_item.dart';
import '../../data/mock_services.dart';
import '../../data/mock_notifications.dart';

import '../notifications/notifications_screen.dart';
import 'order_screen.dart';
import 'my_orders_screen.dart';
import 'customer_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTab = 0;
  String searchQuery = '';
  String? selectedServiceId;

  final TextEditingController searchController = TextEditingController();

  static const String imagePath = 'assets/images/';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void openNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const NotificationsScreen(role: NotificationRole.customer),
      ),
    );
  }

  void openService(ServiceItem service) {
    if (!MockServices.instance.isActive(service.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Энэ үйлчилгээ одоогоор идэвхгүй байна.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => OrderScreen(service: service)),
    );
  }

  String serviceImage(ServiceItem service) {
    return 'assets/images/services/${service.id}.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _appBar(),
      body: IndexedStack(
        index: selectedTab,
        children: [
          AnimatedBuilder(
            animation: MockServices.instance,
            builder: (_, _) => _homeContent(),
          ),
          const MyOrdersScreen(),
          const CustomerProfileScreen(),
        ],
      ),
      bottomNavigationBar: _bottomNavigation(),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      toolbarHeight: 74,
      titleSpacing: 18,
      title: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.home_work_rounded,
              color: Colors.white,
              size: 25,
            ),
          ),
          const SizedBox(width: 10),
          const Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TusGo',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                    color: AppColors.navy,
                    letterSpacing: -0.7,
                  ),
                ),
                Text(
                  'Таны өдөр тутмын туслах',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10, color: AppColors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        AnimatedBuilder(
          animation: MockNotifications.instance,
          builder: (_, _) {
            final unread = MockNotifications.instance.unreadCount(
              NotificationRole.customer,
            );

            return IconButton(
              tooltip: 'Мэдэгдэл',
              onPressed: openNotifications,
              icon: Badge(
                isLabelVisible: unread > 0,
                label: Text(unread > 99 ? '99+' : '$unread'),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.navy,
                  size: 26,
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 5),
        InkWell(
          onTap: () => setState(() => selectedTab = 2),
          borderRadius: BorderRadius.circular(50),
          child: const CircleAvatar(
            radius: 21,
            backgroundColor: AppColors.primaryLight,
            child: Icon(Icons.person_rounded, color: AppColors.primary),
          ),
        ),
        const SizedBox(width: 17),
      ],
    );
  }

  Widget _homeContent() {
    final services = MockServices.instance.activeServices;

    final filtered = services.where((service) {
      final matchesSearch =
          service.title.toLowerCase().contains(
            searchQuery.toLowerCase().trim(),
          ) ||
          service.description.toLowerCase().contains(
            searchQuery.toLowerCase().trim(),
          );

      final matchesCategory =
          selectedServiceId == null || service.id == selectedServiceId;

      return matchesSearch && matchesCategory;
    }).toList();

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1050),
        child: ListView(
          padding: const EdgeInsets.only(bottom: 30),
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _heroBanner(),
            ),
            const SizedBox(height: 23),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _searchField(),
            ),
            const SizedBox(height: 27),
            _sectionTitle(
              'Үйлчилгээний ангилал',
              subtitle: 'Танд хэрэгтэй бүх үйлчилгээ',
            ),
            const SizedBox(height: 16),
            _categoryList(services),
            const SizedBox(height: 29),
            _sectionTitle(
              'Онцлох үйлчилгээ',
              subtitle: 'Хялбар сонгож, шууд захиалаарай',
            ),
            const SizedBox(height: 16),
            if (filtered.isEmpty)
              _emptyState()
            else
              _featuredServices(filtered),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _trustBanner(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _heroBanner() {
    return Container(
      height: 300,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(27),
        gradient: AppColors.primaryGradient,
        boxShadow: const [
          BoxShadow(
            color: Color(0x24078BD3),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            '${imagePath}hero_worker.png',
            fit: BoxFit.cover,
            alignment: Alignment.centerRight,
            errorBuilder: (_, _, _) => const SizedBox.shrink(),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF0753B6),
                  Color(0xE50972CC),
                  Color(0x000A91DC),
                ],
                stops: [0, 0.48, 1],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(21),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TUSGO SERVICES',
                  style: TextStyle(
                    color: Color(0xFFE0F4FF),
                    fontSize: 11,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                const SizedBox(
                  width: 230,
                  child: Text(
                    'Танд хэрэгтэй\nүйлчилгээ нэг дор',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      height: 1.2,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 9),
                const Text(
                  'Найдвартай үйлчилгээ\nХялбар захиалга',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedServiceId = null;
                      searchQuery = '';
                      searchController.clear();
                    });
                    _showServicePicker();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.navy,
                    minimumSize: const Size(0, 42),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 9,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Үйлчилгээ сонгох',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(width: 7),
                      Icon(Icons.arrow_forward_rounded, size: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showServicePicker() {
    final services = MockServices.instance.activeServices;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Үйлчилгээ сонгох',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 15),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: services.length,
                    itemBuilder: (_, index) {
                      final service = services[index];

                      return ListTile(
                        leading: Icon(service.icon, color: AppColors.primary),
                        title: Text(service.title),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 15,
                        ),
                        onTap: () {
                          Navigator.pop(sheetContext);
                          openService(service);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _searchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        boxShadow: AppColors.cardShadow,
      ),
      child: TextField(
        controller: searchController,
        onChanged: (value) => setState(() => searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Ямар үйлчилгээ хэрэгтэй вэ?',
          hintStyle: const TextStyle(fontSize: 13, color: AppColors.muted),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.primary,
          ),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  tooltip: 'Хайлт арилгах',
                  onPressed: () {
                    searchController.clear();
                    setState(() => searchQuery = '');
                  },
                  icon: const Icon(Icons.close_rounded),
                )
              : const Icon(Icons.tune_rounded, color: AppColors.primary),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(19),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(19),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(19),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, {required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.navy,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                selectedServiceId = null;
                searchQuery = '';
                searchController.clear();
              });
              _showServicePicker();
            },
            child: const Text('Бүгдийг харах', style: TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }

  Widget _categoryList(List<ServiceItem> services) {
    return SizedBox(
      height: 115,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 17),
        scrollDirection: Axis.horizontal,
        itemCount: services.length,
        separatorBuilder: (_, _) => const SizedBox(width: 13),
        itemBuilder: (_, index) {
          final service = services[index];
          final selected = selectedServiceId == service.id;

          const colors = [
            Color(0xFFE7F4FF),
            Color(0xFFFFEEE4),
            Color(0xFFE5F8F3),
            Color(0xFFEDEEFF),
            Color(0xFFFFEDF3),
          ];

          const iconColors = [
            Color(0xFF137EE9),
            Color(0xFFFF743B),
            Color(0xFF13A985),
            Color(0xFF6875E8),
            Color(0xFFE55F91),
          ];

          return SizedBox(
            width: 83,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                setState(() {
                  selectedServiceId = selected ? null : service.id;
                });
              },
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    height: 65,
                    width: 65,
                    decoration: BoxDecoration(
                      color: colors[index % colors.length],
                      borderRadius: BorderRadius.circular(20),
                      border: selected
                          ? Border.all(color: AppColors.primary, width: 2)
                          : null,
                    ),
                    child: Icon(
                      service.icon,
                      color: iconColors[index % iconColors.length],
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    service.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      height: 1.2,
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                      color: selected ? AppColors.primary : AppColors.navy,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _featuredServices(List<ServiceItem> services) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 800
            ? 3
            : constraints.maxWidth >= 570
            ? 2
            : 2;

        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: services.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 13,
            mainAxisSpacing: 13,
            mainAxisExtent: 223,
          ),
          itemBuilder: (_, index) => _serviceCard(services[index]),
        );
      },
    );
  }

  Widget _serviceCard(ServiceItem service) {
    final image = serviceImage(service);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(21),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => openService(service),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _imageFallback(service);
                      },
                    ),

                    const Positioned(
                      right: 9,
                      top: 9,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.arrow_outward_rounded,
                          size: 17,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(11, 10, 11, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.navy,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Row(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.success,
                          size: 13,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Захиалах боломжтой',
                          style: TextStyle(
                            color: AppColors.muted,
                            fontSize: 10,
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
      ),
    );
  }

  Widget _imageFallback(ServiceItem service) {
    return Container(
      color: AppColors.primaryLight,
      child: Icon(service.icon, size: 55, color: AppColors.primary),
    );
  }

  Widget _emptyState() {
    return const Padding(
      padding: EdgeInsets.all(35),
      child: Center(
        child: Text(
          'Үйлчилгээ олдсонгүй.',
          style: TextStyle(color: AppColors.muted),
        ),
      ),
    );
  }

  Widget _trustBanner() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(19),
      ),
      child: const Row(
        children: [
          Icon(Icons.verified_user_rounded, color: AppColors.primary, size: 30),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TusGo — Таны найдвартай туслах',
                  style: TextStyle(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Өдөр тутмын үйлчилгээг нэг дороос.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomNavigation() {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(16, 5, 16, 8),
      child: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: AppColors.cardShadow,
          ),
          child: NavigationBar(
            selectedIndex: selectedTab,
            onDestinationSelected: (index) {
              setState(() => selectedTab = index);
            },
            backgroundColor: Colors.transparent,
            indicatorColor: AppColors.primaryLight,
            elevation: 0,
            height: 67,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(
                  Icons.home_rounded,
                  color: AppColors.primary,
                ),
                label: 'Нүүр',
              ),
              NavigationDestination(
                icon: Icon(Icons.receipt_long_outlined),
                selectedIcon: Icon(
                  Icons.receipt_long_rounded,
                  color: AppColors.primary,
                ),
                label: 'Захиалга',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(
                  Icons.person_rounded,
                  color: AppColors.primary,
                ),
                label: 'Профайл',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
