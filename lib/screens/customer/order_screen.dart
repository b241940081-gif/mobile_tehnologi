import 'package:flutter/material.dart';

import '../../data/mock_orders.dart';
import '../../data/mock_services.dart';
import '../../models/service_item.dart';

class OrderScreen extends StatefulWidget {
  final ServiceItem service;

  const OrderScreen({super.key, required this.service});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final formKey = GlobalKey<FormState>();

  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final noteController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 0);

  TimeOfDay endTime = const TimeOfDay(hour: 12, minute: 0);

  @override
  void dispose() {
    addressController.dispose();
    phoneController.dispose();
    noteController.dispose();
    super.dispose();
  }

  String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  String formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> selectDate() async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate.isBefore(DateTime(now.year, now.month, now.day))
          ? now
          : selectedDate,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 1),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  Future<void> selectTime({required bool isStart}) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: isStart ? startTime : endTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (selected == null) return;

    setState(() {
      if (isStart) {
        startTime = selected;
      } else {
        endTime = selected;
      }
    });
  }

  int timeToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  void submitOrder() {
    // Admin үйлчилгээ идэвхгүй болгосон эсэхийг шалгах
    if (!MockServices.instance.isActive(widget.service.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Энэ үйлчилгээ одоогоор идэвхгүй тул захиалга өгөх боломжгүй.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Формын мэдээллийг шалгах
    if (!formKey.currentState!.validate()) return;

    // Эхлэх болон дуусах цагийг шалгах
    if (timeToMinutes(endTime) <= timeToMinutes(startTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Дуусах цаг эхлэх цагаас хойш байх ёстой.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Захиалга үүсгэх
    final order = MockOrders.instance.createOrder(
      service: widget.service.title,
      icon: widget.service.icon,
      address: addressController.text.trim(),
      phone: phoneController.text.trim(),
      date: selectedDate,
      startTime: formatTime(startTime),
      endTime: formatTime(endTime),
      note: noteController.text.trim(),
    );

    // Амжилттай бүртгэгдсэн мэдэгдэл
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A)),
              SizedBox(width: 10),
              Text('Амжилттай'),
            ],
          ),
          content: Text(
            'Таны ${widget.service.title} үйлчилгээний '
            'захиалга бүртгэгдлээ.\n\n'
            'Захиалгын дугаар: ${order.id}\n'
            'Төлөв: ${order.status.label}',
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pop(context);
              },
              child: const Text('Ойлголоо'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: AppBar(
        title: const Text('Үйлчилгээ захиалах'),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Form(
            key: formKey,
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                _serviceSummary(),
                const SizedBox(height: 20),
                _sectionTitle('Үйлчилгээ авах өдөр'),
                const SizedBox(height: 10),
                _selectionTile(
                  icon: Icons.calendar_month_rounded,
                  title: 'Өдөр сонгох',
                  value: formatDate(selectedDate),
                  onTap: selectDate,
                ),
                const SizedBox(height: 20),
                _sectionTitle('Үйлчилгээ авах цаг'),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _selectionTile(
                        icon: Icons.access_time_rounded,
                        title: 'Эхлэх цаг',
                        value: formatTime(startTime),
                        onTap: () => selectTime(isStart: true),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _selectionTile(
                        icon: Icons.access_time_rounded,
                        title: 'Дуусах цаг',
                        value: formatTime(endTime),
                        onTap: () => selectTime(isStart: false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _sectionTitle('Холбоо барих мэдээлэл'),
                const SizedBox(height: 12),
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Хаяг',
                    hintText: 'Дүүрэг, хороо, гудамж, тоот',
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Хаягаа оруулна уу';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 8,
                  decoration: const InputDecoration(
                    labelText: 'Утасны дугаар',
                    prefixIcon: Icon(Icons.phone_outlined),
                    counterText: '',
                  ),
                  validator: (value) {
                    if (value == null ||
                        !RegExp(r'^\d{8}$').hasMatch(value.trim())) {
                      return '8 оронтой утасны дугаар оруулна уу';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: noteController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Нэмэлт тайлбар',
                    hintText: 'Үйлчилгээний дэлгэрэнгүй...',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 26),
                SizedBox(
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: submitOrder,
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Захиалга баталгаажуулах'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _serviceSummary() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1D4ED8), Color(0xFF60A5FA)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(widget.service.icon, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Сонгосон үйлчилгээ',
                  style: TextStyle(color: Color(0xFFDBEAFE), fontSize: 12),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.service.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w800,
        color: Color(0xFF0F172A),
      ),
    );
  }

  Widget _selectionTile({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: const Color(0xFF2563EB)),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
