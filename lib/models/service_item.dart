import 'package:flutter/material.dart';

class ServiceItem {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final IconData icon;

  const ServiceItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.icon,
  });
}

const services = [
  ServiceItem(
    id: 'water',
    title: 'Ус хүргэлт',
    description: 'Ундны болон ахуйн ус хүргэлт',
    imageUrl:
        'https://images.unsplash.com/photo-1437482078695-73f5ca6c96e2?w=900',
    icon: Icons.water_drop,
  ),
  ServiceItem(
    id: 'fuel',
    title: 'Түлээ болон нүүрс худалдаж авах үйлчилгээ',
    description: 'Түлээ, нүүрс захиалах',
    imageUrl:
        'https://images.unsplash.com/photo-1475738198235-4b30fc083d4c?w=900',
    icon: Icons.local_fire_department,
  ),
  ServiceItem(
    id: 'waste',
    title: 'Хог тээвэр',
    description: 'Ахуйн хог ачуулах',
    imageUrl:
        'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=900',
    icon: Icons.delete_outline,
  ),
  ServiceItem(
    id: 'electric',
    title: 'Цахилгааны үйлчилгээ',
    description: 'Цахилгааны засвар, үйлчилгээ',
    imageUrl:
        'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=900',
    icon: Icons.electrical_services,
  ),
  ServiceItem(
    id: 'packing',
    title: 'Түлээ болон нүүрс савлаж бэлтгэх үйлчилгээ',
    description: 'Түлээ, нүүрс савлах болон бэлтгэх',
    imageUrl:
        'https://images.unsplash.com/photo-1510798831971-661eb04b3739?w=900',
    icon: Icons.inventory_2_outlined,
  ),
  ServiceItem(
    id: 'grass',
    title: 'Өвс хадах үйлчилгээ',
    description: 'Хашаа болон талбайн өвс хадах',
    imageUrl:
        'https://images.unsplash.com/photo-1591857177580-dc82b9ac4e1e?w=900',
    icon: Icons.grass,
  ),
];
