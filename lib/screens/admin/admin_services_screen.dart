import 'package:flutter/material.dart';

import '../../models/service_item.dart';
import '../../data/mock_services.dart';

class AdminServicesScreen extends StatefulWidget {
  const AdminServicesScreen({super.key});

  @override
  State<AdminServicesScreen> createState() => _AdminServicesScreenState();
}

class _AdminServicesScreenState extends State<AdminServicesScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: AppBar(
        title: const Text('Үйлчилгээний удирдлага'),
        backgroundColor: Colors.white,
      ),
      body: AnimatedBuilder(
        animation: MockServices.instance,
        builder: (context, _) {
          final filteredServices = services.where((service) {
            return service.title.toLowerCase().contains(
              searchQuery.toLowerCase().trim(),
            );
          }).toList();

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  const Text(
                    'Үйлчилгээний удирдлага',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Нийт ${services.length} үйлчилгээ • '
                    'Идэвхтэй ${MockServices.instance.activeCount}',
                    style: const TextStyle(color: Color(0xFF64748B)),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Үйлчилгээ хайх...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  if (filteredServices.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(child: Text('Үйлчилгээ олдсонгүй')),
                    )
                  else
                    ...filteredServices.map((service) {
                      final active = MockServices.instance.isActive(service.id);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        color: Colors.white,
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: const Color(0xFFEAF2FF),
                                child: Icon(
                                  service.icon,
                                  color: const Color(0xFF2563EB),
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      service.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),

                                    const SizedBox(height: 5),

                                    Text(
                                      active ? 'Идэвхтэй' : 'Идэвхгүй',
                                      style: TextStyle(
                                        color: active
                                            ? Colors.green
                                            : Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Switch(
                                value: active,
                                activeThumbColor: const Color(0xFF2563EB),
                                onChanged: (value) {
                                  MockServices.instance.setActive(
                                    service.id,
                                    value,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
