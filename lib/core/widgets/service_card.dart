import 'package:flutter/material.dart';

import '../../models/service_item.dart';
import '../theme/app_colors.dart';

class ServiceCard extends StatefulWidget {
  final ServiceItem service;
  final VoidCallback onTap;

  const ServiceCard({super.key, required this.service, required this.onTap});

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: hovered ? AppColors.primary : AppColors.border,
          ),
          boxShadow: hovered
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 135,
              child: Image.network(
                widget.service.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFEFF6FF),
                    child: Icon(
                      widget.service.icon,
                      size: 55,
                      color: AppColors.primary,
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.service.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.service.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.muted,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: widget.onTap,
                        child: const Text('Үйлчилгээ авах'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
