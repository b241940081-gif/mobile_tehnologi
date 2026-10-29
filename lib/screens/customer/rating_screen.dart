import 'package:flutter/material.dart';

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
        backgroundColor: Color(0xFF16A34A),
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: AppBar(
        title: const Text('Үйлчилгээ үнэлэх'),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _successBanner(),
              const SizedBox(height: 24),
              _ratingCard(),
              const SizedBox(height: 20),
              _feedbackCard(),
              const SizedBox(height: 24),
              SizedBox(
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: submitRating,
                  icon: const Icon(Icons.send_rounded),
                  label: const Text('Үнэлгээ илгээх'),
                ),
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
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF2563EB),
            size: 60,
          ),
          const SizedBox(height: 14),
          const Text(
            'Үйлчилгээ дууслаа!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            widget.order.service,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 6),
          Text(
            'Захиалга: ${widget.order.id}',
            style: const TextStyle(color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  Widget _ratingCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          const Text(
            'Үйлчилгээний чанарыг үнэлнэ үү',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 18),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 5,
            runSpacing: 8,
            children: List.generate(10, (index) {
              final rating = index + 1;
              final selected = rating <= selectedRating;

              return IconButton(
                tooltip: '$rating оноо',
                onPressed: () {
                  setState(() {
                    selectedRating = rating;
                  });
                },
                icon: Icon(
                  selected ? Icons.star_rounded : Icons.star_border_rounded,
                  color: selected
                      ? const Color(0xFFF59E0B)
                      : const Color(0xFFCBD5E1),
                  size: 28,
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Text(
            '$selectedRating / 10',
            style: const TextStyle(
              color: Color(0xFF2563EB),
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _feedbackCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Санал хүсэлтийн төрөл',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),
          RadioGroup<String>(
            groupValue: selectedFeedbackType,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedFeedbackType = value;
                });
              }
            },
            child: Column(
              children: [
                RadioListTile<String>(
                  title: const Text('Талархал'),
                  value: 'Талархал',
                ),
                RadioListTile<String>(
                  title: const Text('Санал'),
                  value: 'Санал',
                ),
                RadioListTile<String>(
                  title: const Text('Гомдол'),
                  value: 'Гомдол',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: commentController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Сэтгэгдэл',
              hintText: 'Үйлчилгээний талаар сэтгэгдлээ бичнэ үү...',
              alignLabelWithHint: true,
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
