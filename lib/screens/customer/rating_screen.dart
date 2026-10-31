import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/mock_orders.dart';

class RatingScreen extends StatefulWidget {
  final MockOrder order;

  const RatingScreen({super.key, required this.order});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int selectedRating = 0;
  String selectedFeedbackType = 'Талархал';

  final commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  // Үнэлгээ хадгалах логик хэвээр.
  void submitRating() {
    if (widget.order.status != OrderStatus.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Зөвхөн дууссан үйлчилгээг үнэлэх боломжтой.'),
        ),
      );
      return;
    }

    if (widget.order.isRated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Энэ захиалгад аль хэдийн үнэлгээ өгсөн байна.'),
        ),
      );
      return;
    }

    if (selectedRating == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('1–10 одоос сонгоно уу.')));
      return;
    }

    final saved = MockOrders.instance.submitRating(
      order: widget.order,
      rating: selectedRating,
      feedbackType: selectedFeedbackType,
      comment: commentController.text,
    );

    if (!saved) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Үнэлгээ хадгалахад алдаа гарлаа.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Үнэлгээ амжилттай хадгалагдлаа!'),
        backgroundColor: AppColors.success,
      ),
    );

    Navigator.pop(context, true);
  }

  String get ratingMessage {
    if (selectedRating == 0) return 'Та үйлчилгээнд хэдэн оноо өгөх вэ?';
    if (selectedRating <= 3) return 'Сайжруулах шаардлагатай';
    if (selectedRating <= 5) return 'Дундаж үйлчилгээ';
    if (selectedRating <= 7) return 'Сайн үйлчилгээ';
    if (selectedRating <= 9) return 'Маш сайн үйлчилгээ!';
    return 'Гайхалтай үйлчилгээ! 🎉';
  }

  Color get ratingColor {
    if (selectedRating == 0) return AppColors.muted;
    if (selectedRating <= 3) return AppColors.danger;
    if (selectedRating <= 5) return AppColors.pending;
    if (selectedRating <= 7) return AppColors.primary;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        centerTitle: true,
        title: const Text('Үйлчилгээ үнэлэх'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(17, 15, 17, 35),
            children: [
              _successBanner(),
              const SizedBox(height: 22),
              _ratingCard(),
              const SizedBox(height: 22),
              _feedbackCard(),
              const SizedBox(height: 24),
              _submitButton(),
              const SizedBox(height: 13),
              const Text(
                'Таны үнэлгээ үйлчилгээний чанарыг '
                'сайжруулахад тусална.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.muted, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _successBanner() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(27),
        boxShadow: const [
          BoxShadow(
            color: Color(0x23078BD3),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -55,
            top: -70,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.20),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(
                  Icons.verified_rounded,
                  color: Colors.white,
                  size: 39,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Үйлчилгээ амжилттай дууслаа!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                widget.order.service,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFEAF7FF),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Захиалга #${widget.order.id}',
                style: const TextStyle(color: Color(0xFFDDF5FF), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _ratingCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          const Text(
            'Таны үнэлгээ',
            style: TextStyle(
              color: AppColors.navy,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Үйлчилгээний чанарыг 1–10 оноогоор үнэлнэ үү.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted, fontSize: 12),
          ),
          const SizedBox(height: 24),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: ratingColor.withValues(alpha: 0.10),
              shape: BoxShape.circle,
              border: Border.all(
                color: ratingColor.withValues(alpha: 0.20),
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$selectedRating',
                  style: TextStyle(
                    color: ratingColor,
                    fontSize: 39,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const Text(
                  '/ 10',
                  style: TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: Text(
              ratingMessage,
              key: ValueKey(ratingMessage),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ratingColor,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 22),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 5,
            runSpacing: 8,
            children: List.generate(10, (index) {
              final rating = index + 1;
              final selected = rating <= selectedRating;

              return Material(
                color: selected
                    ? const Color(0xFFFFF5DB)
                    : AppColors.background,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedRating = rating;
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 47,
                    height: 48,
                    alignment: Alignment.center,
                    child: Icon(
                      selected ? Icons.star_rounded : Icons.star_border_rounded,
                      color: selected
                          ? const Color(0xFFF59E0B)
                          : const Color(0xFFBAC8D8),
                      size: 28,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 18),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Сайжруулах хэрэгтэй',
                style: TextStyle(color: AppColors.muted, fontSize: 10),
              ),
              Text(
                'Маш сайн',
                style: TextStyle(color: AppColors.muted, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _feedbackCard() {
    return Container(
      padding: const EdgeInsets.all(19),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Санал хүсэлт',
            style: TextStyle(
              color: AppColors.navy,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Үйлчилгээний талаар сэтгэгдлээ хуваалцаарай.',
            style: TextStyle(color: AppColors.muted, fontSize: 12),
          ),
          const SizedBox(height: 20),
          const Text(
            'Санал хүсэлтийн төрөл',
            style: TextStyle(
              color: AppColors.navy,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          _feedbackOption(
            title: 'Талархал',
            subtitle: 'Сэтгэл хангалуун байна',
            icon: Icons.favorite_rounded,
            color: AppColors.success,
          ),
          const SizedBox(height: 10),
          _feedbackOption(
            title: 'Санал',
            subtitle: 'Сайжруулах санал байна',
            icon: Icons.lightbulb_outline_rounded,
            color: AppColors.primary,
          ),
          const SizedBox(height: 10),
          _feedbackOption(
            title: 'Гомдол',
            subtitle: 'Асуудал тулгарсан',
            icon: Icons.report_problem_outlined,
            color: AppColors.danger,
          ),
          const SizedBox(height: 20),
          const Text(
            'Нэмэлт сэтгэгдэл',
            style: TextStyle(
              color: AppColors.navy,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: commentController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Үйлчилгээний талаар сэтгэгдлээ бичнэ үү...',
              hintStyle: const TextStyle(color: AppColors.muted, fontSize: 12),
              filled: true,
              fillColor: AppColors.background,
              contentPadding: const EdgeInsets.all(16),
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
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _feedbackOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    final selected = selectedFeedbackType == title;

    return Material(
      color: selected ? color.withValues(alpha: 0.07) : AppColors.background,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedFeedbackType = title;
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? color : AppColors.border,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: color, size: 22),
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
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                selected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                color: selected ? color : AppColors.muted,
                size: 22,
              ),
            ],
          ),
        ),
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
          onTap: submitRating,
          borderRadius: BorderRadius.circular(18),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.send_rounded, color: Colors.white, size: 20),
              SizedBox(width: 11),
              Text(
                'Үнэлгээ илгээх',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(width: 9),
              Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 19),
            ],
          ),
        ),
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
}
