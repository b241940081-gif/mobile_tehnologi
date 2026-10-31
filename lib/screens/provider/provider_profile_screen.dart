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

  static const blue = Color(0xFF078ED4);
  static const navy = Color(0xFF172E54);
  static const muted = Color(0xFF7892AD);
  static const background = Color(0xFFF2F9FF);
  static const border = Color(0xFFDDEAF5);

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
    if (!MockServices.instance.isActive(service.id)) {
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
        return ColoredBox(
          color: background,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 850),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                children: [
                  _profileHeader(),
                  const SizedBox(height: 24),
                  _sectionHeading(
                    Icons.person_outline_rounded,
                    'Хувийн мэдээлэл',
                    'Мэдээллээ шинэчилж, удирдаарай',
                  ),
                  const SizedBox(height: 14),
                  _profileFields(),
                  const SizedBox(height: 26),
                  _sectionHeading(
                    Icons.grid_view_rounded,
                    'Миний үзүүлэх үйлчилгээ',
                    'Үзүүлэх үйлчилгээнүүдээ сонгоорой',
                  ),
                  const SizedBox(height: 14),
                  _serviceSelection(),
                  const SizedBox(height: 24),
                  Container(
                    height: 58,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF13B6EB), Color(0xFF066BAC)],
                      ),
                      borderRadius: BorderRadius.circular(19),
                      boxShadow: [
                        BoxShadow(
                          color: blue.withValues(alpha: 0.18),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: saveProfile,
                      icon: const Icon(Icons.save_outlined),
                      label: const Text(
                        'Профайл хадгалах',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(19),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'TusGo 2.0 • Таны өдөр тутмын найдвартай туслах',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: muted, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _profileHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF13B6EB), Color(0xFF078ED4), Color(0xFF0668A8)],
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
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.8),
                    width: 3,
                  ),
                ),
                child: const Center(
                  child: CircleAvatar(
                    radius: 47,
                    backgroundColor: Color(0xFFE3F5FF),
                    child: Icon(
                      Icons.engineering_rounded,
                      color: blue,
                      size: 52,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified_rounded,
                    color: blue,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'ҮЙЛЧИЛГЭЭ ҮЗҮҮЛЭГЧ',
            style: TextStyle(
              color: Color(0xFFD6F3FF),
              letterSpacing: 2,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            provider.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            provider.phone,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 17),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              '${provider.selectedServiceIds.length} үйлчилгээ сонгосон',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeading(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFFDDF4FF),
            borderRadius: BorderRadius.circular(17),
          ),
          child: Icon(icon, color: blue, size: 26),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: navy,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: muted, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _profileFields() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('Нэр / Байгууллагын нэр'),
          const SizedBox(height: 10),
          _textField(
            controller: nameController,
            icon: Icons.person_outline_rounded,
            hint: 'Нэрээ оруулна уу',
          ),
          const SizedBox(height: 20),
          _fieldLabel('Утасны дугаар'),
          const SizedBox(height: 10),
          _textField(
            controller: phoneController,
            icon: Icons.phone_outlined,
            hint: '8 оронтой дугаар',
            keyboardType: TextInputType.phone,
            maxLength: 8,
          ),
          const SizedBox(height: 20),
          _fieldLabel('Товч танилцуулга'),
          const SizedBox(height: 10),
          _textField(
            controller: descriptionController,
            icon: Icons.notes_rounded,
            hint: 'Өөрийн үйлчилгээний талаар бичнэ үү',
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F5FF),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline_rounded, color: blue),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Мэдээллээ өөрчилсний дараа хадгалах '
                    'товчийг дараарай.',
                    style: TextStyle(color: Color(0xFF52738E), fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: navy,
        fontSize: 14,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    TextInputType? keyboardType,
    int? maxLength,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: muted),
        prefixIcon: Icon(icon, color: blue),
        counterText: '',
        filled: true,
        fillColor: background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(color: blue, width: 1.5),
        ),
      ),
    );
  }

  Widget _serviceSelection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Үйлчилгээнүүд',
            style: TextStyle(
              color: navy,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Нэг эсвэл хэд хэдэн үйлчилгээ сонгох боломжтой.',
            style: TextStyle(color: muted, fontSize: 12),
          ),
          const SizedBox(height: 10),
          const Text(
            'Admin идэвхгүй болгосон үйлчилгээг сонгох боломжгүй.',
            style: TextStyle(color: Color(0xFFB45309), fontSize: 11),
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 650 ? 3 : 2;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: services.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  mainAxisExtent: 200,
                ),
                itemBuilder: (context, index) {
                  return _serviceCard(services[index]);
                },
              );
            },
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F7FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: blue),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${provider.selectedServiceIds.length} '
                    'үйлчилгээ сонгосон',
                    style: const TextStyle(
                      color: navy,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _serviceCard(ServiceItem service) {
    final selected = provider.provides(service.id);
    final isActive = MockServices.instance.isActive(service.id);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(19),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: isActive ? () => toggleProviderService(service) : null,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(19),
            border: Border.all(
              color: !isActive
                  ? const Color(0xFFCBD5E1)
                  : selected
                  ? blue
                  : border,
              width: selected && isActive ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/services/${service.id}.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFFDDF4FF),
                          child: Icon(service.icon, color: blue, size: 38),
                        );
                      },
                    ),
                    if (!isActive)
                      Container(color: Colors.white.withValues(alpha: 0.55)),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          !isActive
                              ? Icons.lock_outline_rounded
                              : selected
                              ? Icons.check_circle_rounded
                              : Icons.add_circle_outline_rounded,
                          color: !isActive
                              ? Colors.grey
                              : selected
                              ? const Color(0xFF16A34A)
                              : blue,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isActive ? navy : muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      !isActive
                          ? 'Идэвхгүй'
                          : selected
                          ? 'Сонгосон'
                          : 'Сонгох',
                      style: TextStyle(
                        color: !isActive
                            ? const Color(0xFFDC2626)
                            : selected
                            ? const Color(0xFF16A34A)
                            : blue,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
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

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      border: Border.all(color: border),
      boxShadow: [
        BoxShadow(
          color: navy.withValues(alpha: 0.04),
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }
}
