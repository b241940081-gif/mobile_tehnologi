import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/service_item.dart';
import '../../data/mock_services.dart';
import '../customer/order_screen.dart';

class ProviderServicesScreen extends StatefulWidget {
  final VoidCallback onOpenWork;

  const ProviderServicesScreen({super.key, required this.onOpenWork});

  @override
  State<ProviderServicesScreen> createState() => _ProviderServicesScreenState();
}

class _ProviderServicesScreenState extends State<ProviderServicesScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  String _serviceImage(ServiceItem service) {
    return 'assets/images/services/${service.id}.jpg';
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _openService(ServiceItem service) {
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: MockServices.instance,
      builder: (context, _) {
        final filteredServices = MockServices.instance.activeServices.where((
          service,
        ) {
          final query = searchQuery.toLowerCase().trim();

          return service.title.toLowerCase().contains(query) ||
              service.description.toLowerCase().contains(query);
        }).toList();

        return ColoredBox(
          color: AppColors.background,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1050),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 35),
                children: [
                  _header(),
                  const SizedBox(height: 25),
                  _searchField(),
                  const SizedBox(height: 28),
                  _sectionHeader(filteredServices.length),
                  const SizedBox(height: 18),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;

                      final columns = width >= 850
                          ? 3
                          : width >= 520
                          ? 2
                          : 2;

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredServices.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: 13,
                          mainAxisSpacing: 15,
                          mainAxisExtent: width < 380 ? 240 : 260,
                        ),
                        itemBuilder: (context, index) {
                          return _serviceCard(filteredServices[index]);
                        },
                      );
                    },
                  ),
                  if (filteredServices.isEmpty) _emptyState(),
                  const SizedBox(height: 27),
                  _workShortcut(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _header() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26078BD3),
            blurRadius: 25,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            Positioned(
              top: -55,
              right: -65,
              child: Container(
                width: 210,
                height: 210,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.11),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.17),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified_rounded,
                          color: Colors.white,
                          size: 17,
                        ),
                        SizedBox(width: 7),
                        Text(
                          'TUSGO SERVICES',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 23),
                  const Text(
                    'Танд ямар үйлчилгээ\nхэрэгтэй вэ?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      height: 1.18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Өдөр тутмын хэрэгцээт үйлчилгээг '
                    'нэг дороос хялбар сонгоорой.',
                    style: TextStyle(
                      color: Color(0xFFE5F6FF),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 23),
                  OutlinedButton.icon(
                    onPressed: widget.onOpenWork,
                    icon: const Icon(Icons.work_outline_rounded, size: 19),
                    label: const Text('Миний ажил руу очих'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.75),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 17,
                        vertical: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
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
          hintStyle: const TextStyle(color: AppColors.muted, fontSize: 14),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.primary,
            size: 25,
          ),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    searchController.clear();
                    setState(() {
                      searchQuery = '';
                    });
                    FocusScope.of(context).unfocus();
                  },
                  icon: const Icon(Icons.close_rounded),
                )
              : null,
          filled: false,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 17,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(int count) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Манай үйлчилгээнүүд',
                style: TextStyle(
                  color: AppColors.navy,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Өөрт тохирох үйлчилгээг сонгоорой',
                style: TextStyle(color: AppColors.muted, fontSize: 12),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Text(
            '$count үйлчилгээ',
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _serviceCard(ServiceItem service) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openService(service),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.border),
            boxShadow: AppColors.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 6,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      _serviceImage(service),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.primaryLight,
                          child: Icon(
                            service.icon,
                            color: AppColors.primary,
                            size: 48,
                          ),
                        );
                      },
                    ),
                    Positioned(
                      top: 11,
                      left: 11,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.94),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          service.icon,
                          color: AppColors.primary,
                          size: 19,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 11,
                      right: 11,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.94),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Идэвхтэй',
                          style: TextStyle(
                            color: AppColors.success,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          service.title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.navy,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            height: 1.3,
                          ),
                        ),
                      ),
                      const Row(
                        children: [
                          Text(
                            'Дэлгэрэнгүй',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: AppColors.primary,
                            size: 15,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _workShortcut() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 47,
            height: 47,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.work_history_rounded,
              color: AppColors.primary,
              size: 25,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Өөрийн ажлуудаа удирдах',
                  style: TextStyle(
                    color: AppColors.navy,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Захиалгуудын төлөвийг хянаарай',
                  style: TextStyle(color: AppColors.muted, fontSize: 11),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: widget.onOpenWork,
            icon: const Icon(
              Icons.arrow_forward_rounded,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 45),
      child: Column(
        children: [
          const Icon(
            Icons.search_off_rounded,
            color: AppColors.muted,
            size: 48,
          ),
          const SizedBox(height: 13),
          const Text(
            'Үйлчилгээ олдсонгүй',
            style: TextStyle(
              color: AppColors.navy,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Өөр түлхүүр үгээр хайж үзнэ үү.',
            style: TextStyle(color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}
