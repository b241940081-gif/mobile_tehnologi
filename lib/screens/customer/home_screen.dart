import 'package:flutter/material.dart';

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

  void openNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const NotificationsScreen(role: NotificationRole.customer),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Row(
          children: [
            Icon(Icons.home_work_rounded, color: Color(0xFF2563EB), size: 28),
            SizedBox(width: 8),
            Text(
              'TusGo',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        actions: [
          // Customer-ийн мэдэгдлийн хонх
          AnimatedBuilder(
            animation: MockNotifications.instance,
            builder: (context, _) {
              final unread = MockNotifications.instance.unreadCount(
                NotificationRole.customer,
              );

              return IconButton(
                tooltip: 'Мэдэгдэл',
                onPressed: openNotifications,
                icon: Badge(
                  isLabelVisible: unread > 0,
                  label: Text(unread > 99 ? '99+' : '$unread'),
                  child: const Icon(Icons.notifications_none_rounded),
                ),
              );
            },
          ),

          // Профайл
          IconButton(
            tooltip: 'Профайл',
            icon: const CircleAvatar(
              backgroundColor: Color(0xFFEAF2FF),
              child: Icon(
                Icons.person_outline_rounded,
                color: Color(0xFF2563EB),
              ),
            ),
            onPressed: () {
              setState(() {
                selectedTab = 2;
              });
            },
          ),

          const SizedBox(width: 8),
        ],
      ),

      // Үндсэн 3 дэлгэц
      body: IndexedStack(
        index: selectedTab,
        children: [
          AnimatedBuilder(
            animation: MockServices.instance,
            builder: (context, _) => _homeContent(),
          ),
          const MyOrdersScreen(),
          const CustomerProfileScreen(),
        ],
      ),

      // Bottom Navigation
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedTab,
        onDestinationSelected: (index) {
          setState(() {
            selectedTab = index;
          });
        },
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFEAF2FF),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded, color: Color(0xFF2563EB)),
            label: 'Нүүр',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(
              Icons.receipt_long_rounded,
              color: Color(0xFF2563EB),
            ),
            label: 'Захиалга',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded, color: Color(0xFF2563EB)),
            label: 'Профайл',
          ),
        ],
      ),
    );
  }

  // Үйлчилгээний үндсэн дэлгэц
  Widget _homeContent() {
    final filteredServices = MockServices.instance.activeServices.where((
      service,
    ) {
      final query = searchQuery.toLowerCase().trim();

      return service.title.toLowerCase().contains(query) ||
          service.description.toLowerCase().contains(query);
    }).toList();

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 950),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _heroBanner(),
            const SizedBox(height: 20),

            // Үйлчилгээ хайх
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Ямар үйлчилгээ хэрэгтэй вэ?',
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Color(0xFF64748B),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
            ),

            const SizedBox(height: 26),

            const Text(
              'Манай үйлчилгээнүүд',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'Өөрт хэрэгтэй үйлчилгээгээ сонгоорой.',
              style: TextStyle(color: Color(0xFF64748B)),
            ),

            const SizedBox(height: 18),

            // Үйлчилгээний картууд
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 700 ? 3 : 2;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredServices.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: 195,
                  ),
                  itemBuilder: (context, index) {
                    return _serviceCard(filteredServices[index]);
                  },
                );
              },
            ),

            if (filteredServices.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: Text('Идэвхтэй үйлчилгээ олдсонгүй.')),
              ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Нүүр хуудасны баннер
  Widget _heroBanner() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1D4ED8), Color(0xFF60A5FA)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TUSGO SERVICES',
            style: TextStyle(
              color: Color(0xFFDBEAFE),
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Танд ямар үйлчилгээ хэрэгтэй вэ?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Найдвартай үйлчилгээг хялбархан '
            'сонгож захиалаарай.',
            style: TextStyle(color: Colors.white, height: 1.5),
          ),
        ],
      ),
    );
  }

  // Үйлчилгээний карт
  Widget _serviceCard(ServiceItem service) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // Admin-аас идэвхгүй болгосон үйлчилгээг
          // захиалах боломжгүй.
          if (!MockServices.instance.isActive(service.id)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Энэ үйлчилгээ одоогоор идэвхгүй байна.'),
              ),
            );
            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => OrderScreen(service: service)),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  color: const Color(0xFFEAF2FF),
                  child: Icon(
                    service.icon,
                    color: const Color(0xFF2563EB),
                    size: 44,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      service.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
