import 'package:flutter/material.dart';

import '../../models/service_item.dart';
import '../../data/mock_services.dart';

class AdminServicesScreen extends StatefulWidget {
  const AdminServicesScreen({super.key});

  @override
  State<AdminServicesScreen> createState() => _AdminServicesScreenState();
}

class _AdminServicesScreenState extends State<AdminServicesScreen> {
  static const Color blue = Color(0xFF078FD3);
  static const Color navy = Color(0xFF192F54);
  static const Color muted = Color(0xFF7894B0);
  static const Color background = Color(0xFFF1F9FF);

  String searchQuery = '';
  String selectedFilter = 'Бүгд';

  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'Үйлчилгээ удирдах',
          style: TextStyle(color: navy, fontWeight: FontWeight.w800),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
      ),
      body: AnimatedBuilder(
        animation: MockServices.instance,
        builder: (context, _) {
          final activeCount = MockServices.instance.activeCount;
          final inactiveCount = services.length - activeCount;

          final query = searchQuery.trim().toLowerCase();

          final filteredServices = services.where((service) {
            final active = MockServices.instance.isActive(service.id);

            final matchesSearch =
                service.title.toLowerCase().contains(query) ||
                service.description.toLowerCase().contains(query);

            final matchesFilter =
                selectedFilter == 'Бүгд' ||
                (selectedFilter == 'Идэвхтэй' && active) ||
                (selectedFilter == 'Идэвхгүй' && !active);

            return matchesSearch && matchesFilter;
          }).toList();

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _heroBanner(),
                  const SizedBox(height: 26),

                  _sectionHeader(
                    Icons.analytics_outlined,
                    'Үйлчилгээний төлөв',
                    'Системд бүртгэлтэй үйлчилгээний мэдээлэл',
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _statCard(
                          'Нийт',
                          services.length,
                          Icons.grid_view_rounded,
                          blue,
                          const Color(0xFFDDF4FF),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _statCard(
                          'Идэвхтэй',
                          activeCount,
                          Icons.check_circle_outline_rounded,
                          const Color(0xFF0EA65A),
                          const Color(0xFFE5F8EE),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _statCard(
                          'Идэвхгүй',
                          inactiveCount,
                          Icons.block_rounded,
                          const Color(0xFFEF4444),
                          const Color(0xFFFFEAEA),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  _sectionHeader(
                    Icons.settings_suggest_rounded,
                    'Үйлчилгээний жагсаалт',
                    'Үйлчилгээг хайж, төлөвийг удирдаарай',
                  ),

                  const SizedBox(height: 18),

                  _searchField(),

                  const SizedBox(height: 16),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _filterChip('Бүгд'),
                        _filterChip('Идэвхтэй'),
                        _filterChip('Идэвхгүй'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Бүх үйлчилгээ',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: navy,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDDF4FF),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          '${filteredServices.length} үйлчилгээ',
                          style: const TextStyle(
                            color: blue,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  if (filteredServices.isEmpty)
                    _emptyState()
                  else
                    ...filteredServices.map(_serviceCard),

                  const SizedBox(height: 20),

                  _informationBox(),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _heroBanner() {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF13B8EF), Color(0xFF0870B4)],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: blue.withValues(alpha: 0.15),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -50,
            top: -70,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.10),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified_rounded, color: Colors.white, size: 17),
                    SizedBox(width: 8),
                    Text(
                      'TUSGO ADMIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                'Үйлчилгээний\nудирдлага',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  height: 1.15,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Системийн үйлчилгээнүүдийг нэг дороос '
                'идэвхжүүлж, удирдаарай.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.17),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.tune_rounded, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Үйлчилгээний төлөвийг шууд өөрчлөх',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: const Color(0xFFDDF4FF),
            borderRadius: BorderRadius.circular(17),
          ),
          child: Icon(icon, color: blue, size: 27),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: navy,
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(color: muted, fontSize: 12, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statCard(
    String label,
    int count,
    IconData icon,
    Color color,
    Color iconBackground,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: const Color(0xFFD9E9F7)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF15446B).withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 49,
            height: 49,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: color, size: 25),
          ),
          const SizedBox(height: 15),
          Text(
            '$count',
            style: TextStyle(
              color: color,
              fontSize: 29,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: muted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD9E9F7)),
      ),
      child: TextField(
        controller: searchController,
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Үйлчилгээ хайх...',
          hintStyle: const TextStyle(color: muted),
          prefixIcon: const Icon(Icons.search_rounded, color: blue),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  tooltip: 'Хайлтыг цэвэрлэх',
                  onPressed: () {
                    searchController.clear();
                    setState(() {
                      searchQuery = '';
                    });
                  },
                  icon: const Icon(Icons.close_rounded),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 19),
        ),
      ),
    );
  }

  Widget _filterChip(String label) {
    final selected = selectedFilter == label;

    return Padding(
      padding: const EdgeInsets.only(right: 9),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) {
          setState(() {
            selectedFilter = label;
          });
        },
        selectedColor: blue,
        backgroundColor: Colors.white,
        showCheckmark: false,
        side: BorderSide(color: selected ? blue : const Color(0xFFD9E9F7)),
        labelStyle: TextStyle(
          color: selected ? Colors.white : muted,
          fontWeight: FontWeight.w700,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  Widget _serviceCard(ServiceItem service) {
    final active = MockServices.instance.isActive(service.id);

    final statusColor = active
        ? const Color(0xFF0EA65A)
        : const Color(0xFFEF4444);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: const Color(0xFFD9E9F7)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF15446B).withValues(alpha: 0.035),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            child: SizedBox(
              width: double.infinity,
              height: 160,
              child: Image.network(
                service.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFDDF4FF),
                    child: Center(
                      child: Icon(service.icon, size: 56, color: blue),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.title,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  service.description,
                  style: const TextStyle(
                    color: muted,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 15),
                const Divider(color: Color(0xFFE8F0F8), height: 1),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            active
                                ? Icons.check_circle_rounded
                                : Icons.cancel_rounded,
                            color: statusColor,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            active ? 'Идэвхтэй' : 'Идэвхгүй',
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'Идэвхжүүлэх',
                      style: TextStyle(
                        color: muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Switch(
                      value: active,
                      activeThumbColor: blue,
                      onChanged: (value) {
                        MockServices.instance.setActive(service.id, value);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 55),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFD9E9F7)),
      ),
      child: const Column(
        children: [
          Icon(Icons.search_off_rounded, size: 58, color: blue),
          SizedBox(height: 15),
          Text(
            'Үйлчилгээ олдсонгүй',
            style: TextStyle(
              color: navy,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 9),
          Text(
            'Хайлтын үгээ эсвэл шүүлтүүрээ өөрчилнө үү.',
            textAlign: TextAlign.center,
            style: TextStyle(color: muted, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _informationBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFDDF4FF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: blue),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Үйлчилгээг идэвхгүй болгосноор '
              'хэрэглэгчид тухайн үйлчилгээг шинээр '
              'захиалах боломжгүй болно.',
              style: TextStyle(
                color: Color(0xFF426582),
                fontSize: 12,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
