import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
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

  // Захиалга үүсгэх үндсэн логикийг өөрчлөөгүй.
  void submitOrder() {
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

    if (!formKey.currentState!.validate()) return;

    if (timeToMinutes(endTime) <= timeToMinutes(startTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Дуусах цаг эхлэх цагаас хойш байх ёстой.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

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

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: AppColors.success,
                size: 27,
              ),
              SizedBox(width: 10),
              Expanded(child: Text('Захиалга амжилттай!')),
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

  String? serviceImage() {
    const images = <String, String>{
      'water': 'water.jpg',
      'fuel': 'fuel.jpg',
      'waste': 'waste.jpg',
      'electric': 'electric.jpg',
      'packing': 'packing.jpg',
      'grass': 'grass.jpg',
      'cleaning': 'cleaning.jpg',
      'babysitting': 'babysitting.jpg',
      'plumbing': 'plumbing.jpg',
      'moving': 'moving.jpg',
      'furniture': 'furniture.jpg',
      'snow_removal': 'snow_removal.jpg',
      'window_cleaning': 'window_cleaning.jpg',
      'yard_cleaning': 'yard_cleaning.jpg',
    };

    final fileName = images[widget.service.id];

    if (fileName == null) return null;

    return 'assets/images/services/$fileName';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Үйлчилгээ захиалах'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Form(
            key: formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(17, 15, 17, 30),
              children: [
                _serviceHero(),
                const SizedBox(height: 16),
                _progressStrip(),
                const SizedBox(height: 25),
                _sectionHeading(
                  'Захиалгын мэдээлэл',
                  'Үйлчилгээ авах өдөр, цагаа сонгоорой',
                  Icons.event_note_rounded,
                ),
                const SizedBox(height: 15),
                _scheduleCard(),
                const SizedBox(height: 25),
                _sectionHeading(
                  'Холбоо барих мэдээлэл',
                  'Үйлчилгээ үзүүлэх байршил болон утас',
                  Icons.location_on_outlined,
                ),
                const SizedBox(height: 15),
                _contactCard(),
                const SizedBox(height: 24),
                _noticeCard(),
                const SizedBox(height: 24),
                _submitButton(),
                const SizedBox(height: 12),
                const Text(
                  'Захиалгаа баталгаажуулсны дараа '
                  'Миний захиалга хэсгээс төлөвийг шалгах боломжтой.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 11,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _progressStrip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _stepCircle('1', true),
          const SizedBox(width: 7),
          const Expanded(
            child: Text(
              'Үйлчилгээ',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            size: 16,
            color: AppColors.muted,
          ),
          _stepCircle('2', true),
          const SizedBox(width: 7),
          const Expanded(
            child: Text(
              'Мэдээлэл',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            size: 16,
            color: AppColors.muted,
          ),
          _stepCircle('3', false),
          const SizedBox(width: 7),
          const Expanded(
            child: Text(
              'Баталгаажуулах',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 10, color: AppColors.muted),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepCircle(String number, bool active) {
    return Container(
      width: 25,
      height: 25,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active ? AppColors.primary : AppColors.primaryLight,
        shape: BoxShape.circle,
      ),
      child: Text(
        number,
        style: TextStyle(
          color: active ? Colors.white : AppColors.primary,
          fontWeight: FontWeight.w800,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _serviceHero() {
    final image = serviceImage();

    return Container(
      height: 235,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: AppColors.primaryGradient,
        boxShadow: const [
          BoxShadow(
            color: Color(0x23078BD3),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (image != null)
            Image.asset(
              image,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _heroFallback(),
            )
          else
            _heroFallback(),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x000B2D50),
                  Color(0x330B2D50),
                  Color(0xF008274D),
                ],
                stops: [0, 0.4, 1],
              ),
            ),
          ),
          Positioned(
            left: 19,
            top: 18,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified_rounded,
                    color: AppColors.primary,
                    size: 16,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'TUSGO SERVICE',
                    style: TextStyle(
                      color: AppColors.navy,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 21,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'СОНГОСОН ҮЙЛЧИЛГЭЭ',
                  style: TextStyle(
                    color: Color(0xFFBCEEFF),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.4,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  widget.service.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    height: 1.2,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.service.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFEAF7FF),
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroFallback() {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: Center(
        child: Icon(
          widget.service.icon,
          size: 90,
          color: Colors.white.withValues(alpha: 0.65),
        ),
      ),
    );
  }

  Widget _sectionHeading(String title, String subtitle, IconData icon) {
    return Row(
      children: [
        Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: AppColors.primary, size: 23),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.navy,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: AppColors.muted, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _scheduleCard() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _selectionTile(
            icon: Icons.calendar_month_rounded,
            title: 'Үйлчилгээ авах өдөр',
            value: formatDate(selectedDate),
            onTap: selectDate,
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                child: _selectionTile(
                  icon: Icons.schedule_rounded,
                  title: 'Эхлэх цаг',
                  value: formatTime(startTime),
                  onTap: () => selectTime(isStart: true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _selectionTile(
                  icon: Icons.schedule_rounded,
                  title: 'Дуусах цаг',
                  value: formatTime(endTime),
                  onTap: () => selectTime(isStart: false),
                ),
              ),
            ],
          ),
        ],
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
      color: AppColors.background,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: AppColors.primary, size: 19),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: AppColors.navy,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.primary,
                    size: 19,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contactCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _fieldLabel('Үйлчилгээ авах хаяг'),
          const SizedBox(height: 9),
          TextFormField(
            controller: addressController,
            textInputAction: TextInputAction.next,
            decoration: _inputDecoration(
              hint: 'Дүүрэг, хороо, гудамж, тоот',
              icon: Icons.location_on_outlined,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Хаягаа оруулна уу';
              }
              return null;
            },
          ),
          const SizedBox(height: 18),
          _fieldLabel('Утасны дугаар'),
          const SizedBox(height: 9),
          TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            maxLength: 8,
            textInputAction: TextInputAction.next,
            decoration: _inputDecoration(
              hint: '8 оронтой дугаар',
              icon: Icons.phone_outlined,
            ).copyWith(counterText: ''),
            validator: (value) {
              if (value == null || !RegExp(r'^\d{8}$').hasMatch(value.trim())) {
                return '8 оронтой утасны дугаар оруулна уу';
              }
              return null;
            },
          ),
          const SizedBox(height: 18),
          _fieldLabel('Нэмэлт тайлбар'),
          const SizedBox(height: 9),
          TextFormField(
            controller: noteController,
            maxLines: 3,
            decoration: _inputDecoration(
              hint: 'Үйлчилгээний дэлгэрэнгүй мэдээлэл...',
              icon: Icons.edit_note_rounded,
            ).copyWith(alignLabelWithHint: true),
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.navy,
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.muted, fontSize: 12),
      prefixIcon: Icon(icon, color: AppColors.primary, size: 21),
      filled: true,
      fillColor: AppColors.background,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 17),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(23),
      border: Border.all(color: AppColors.border),
      boxShadow: AppColors.cardShadow,
    );
  }

  Widget _noticeCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(17),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 24),
          SizedBox(width: 11),
          Expanded(
            child: Text(
              'Захиалгын өдөр, цаг болон холбоо барих '
              'мэдээллээ зөв оруулсан эсэхээ шалгаарай.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x30078BD3),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: submitOrder,
          borderRadius: BorderRadius.circular(18),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.white,
                size: 22,
              ),
              SizedBox(width: 10),
              Flexible(
                child: Text(
                  'Захиалга баталгаажуулах',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
