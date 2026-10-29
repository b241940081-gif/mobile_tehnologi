import 'package:flutter/material.dart';

import '../../data/mock_provider.dart';
import '../../data/mock_services.dart';
import '../../models/service_item.dart';

class ProviderProfileScreen extends StatefulWidget {
  const ProviderProfileScreen({super.key});

  @override
  State<ProviderProfileScreen> createState() => _ProviderProfileScreenState();
}

class _ProviderProfileScreenState extends State<ProviderProfileScreen> {
  final provider = MockProvider.instance;

  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: provider.name);
    phoneController = TextEditingController(text: provider.phone);
    descriptionController = TextEditingController(text: provider.description);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void saveProfile() {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();

    if (name.isEmpty || !RegExp(r'^\d{8}$').hasMatch(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Нэр болон 8 оронтой утасны дугаараа шалгана уу.'),
        ),
      );
      return;
    }

    provider.updateProfile(
      newName: name,
      newPhone: phone,
      newDescription: descriptionController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Профайл амжилттай хадгалагдлаа.'),
        backgroundColor: Color(0xFF16A34A),
      ),
    );
  }

  void toggleProviderService(ServiceItem service) {
    final isActive = MockServices.instance.isActive(service.id);

    if (!isActive) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Энэ үйлчилгээг Admin идэвхгүй болгосон тул '
            'одоогоор сонгох боломжгүй.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    provider.toggleService(service.id);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([provider, MockServices.instance]),
      builder: (context, _) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _header(),
                const SizedBox(height: 24),
                _profileFields(),
                const SizedBox(height: 24),
                _serviceSelection(),
                const SizedBox(height: 24),
                SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: saveProfile,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Профайл хадгалах'),
                  ),
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1D4ED8), Color(0xFF60A5FA)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person_rounded,
              color: Color(0xFF2563EB),
              size: 32,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Миний профайл',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Өөрийн мэдээлэл болон үзүүлэх '
            'үйлчилгээнүүдээ удирдаарай.',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _profileFields() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Хувийн мэдээлэл',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Нэр / Байгууллагын нэр',
              prefixIcon: Icon(Icons.business_outlined),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            maxLength: 8,
            decoration: const InputDecoration(
              labelText: 'Утасны дугаар',
              prefixIcon: Icon(Icons.phone_outlined),
              counterText: '',
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: descriptionController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Товч танилцуулга',
              alignLabelWithHint: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _serviceSelection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Миний үзүүлэх үйлчилгээ',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text(
            'Нэг эсвэл хэд хэдэн үйлчилгээ сонгож болно.',
            style: TextStyle(color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 8),
          const Text(
            'Идэвхгүй үйлчилгээг Admin дахин '
            'идэвхжүүлэх хүртэл сонгох боломжгүй.',
            style: TextStyle(color: Color(0xFFB45309), fontSize: 12),
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 500 ? 3 : 2;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: services.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  mainAxisExtent: 145,
                ),
                itemBuilder: (context, index) {
                  final service = services[index];

                  final selected = provider.provides(service.id);
                  final isActive = MockServices.instance.isActive(service.id);

                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: isActive
                        ? () => toggleProviderService(service)
                        : null,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: !isActive
                            ? const Color(0xFFF1F5F9)
                            : selected
                            ? const Color(0xFFEFF6FF)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: !isActive
                              ? const Color(0xFFCBD5E1)
                              : selected
                              ? const Color(0xFF2563EB)
                              : const Color(0xFFE2E8F0),
                          width: selected && isActive ? 1.8 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                service.icon,
                                color: isActive
                                    ? const Color(0xFF2563EB)
                                    : const Color(0xFF94A3B8),
                              ),
                              Icon(
                                selected
                                    ? Icons.check_circle_rounded
                                    : Icons.radio_button_unchecked,
                                color: !isActive
                                    ? const Color(0xFF94A3B8)
                                    : selected
                                    ? const Color(0xFF2563EB)
                                    : const Color(0xFFCBD5E1),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            service.title,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isActive
                                  ? const Color(0xFF0F172A)
                                  : const Color(0xFF94A3B8),
                            ),
                          ),
                          if (!isActive) ...[
                            const SizedBox(height: 5),
                            Text(
                              selected
                                  ? 'Идэвхгүй • Өмнө сонгосон'
                                  : 'Идэвхгүй',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFFB91C1C),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 14),
          Text(
            '${provider.selectedServiceIds.length} үйлчилгээ сонгосон',
            style: const TextStyle(
              color: Color(0xFF2563EB),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: const Color(0xFFE2E8F0)),
    );
  }
}
