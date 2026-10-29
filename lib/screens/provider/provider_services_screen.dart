import 'package:flutter/material.dart';

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
  String searchQuery = '';

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

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 950),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _header(),
                const SizedBox(height: 22),

                TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Ямар үйлчилгээ хэрэгтэй вэ?',
                    prefixIcon: const Icon(Icons.search_rounded),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Үйлчилгээ сонгох',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Өөрт хэрэгтэй үйлчилгээг сонгож захиалаарай.',
                  style: TextStyle(color: Color(0xFF64748B)),
                ),

                const SizedBox(height: 18),

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
                        mainAxisExtent: 190,
                      ),
                      itemBuilder: (context, index) {
                        return _serviceCard(filteredServices[index]);
                      },
                    );
                  },
                ),

                if (filteredServices.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(30),
                    child: Center(child: Text('Идэвхтэй үйлчилгээ олдсонгүй.')),
                  ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1D4ED8), Color(0xFF60A5FA)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TUSGO',
            style: TextStyle(
              color: Color(0xFFDBEAFE),
              fontSize: 12,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Танд ямар үйлчилгээ хэрэгтэй вэ?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Өөрт хэрэгтэй үйлчилгээгээ захиалах '
            'эсвэл өөрийн ажлуудаа удирдаарай.',
            style: TextStyle(color: Colors.white, height: 1.5),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: widget.onOpenWork,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white),
            ),
            icon: const Icon(Icons.work_outline),
            label: const Text('Миний ажил руу очих'),
          ),
        ],
      ),
    );
  }

  Widget _serviceCard(ServiceItem service) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
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
                    size: 44,
                    color: const Color(0xFF2563EB),
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
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
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
