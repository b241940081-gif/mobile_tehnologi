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
  // Өмнө байсан 6 үйлчилгээ — ID-г өөрчлөөгүй.
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

  // Шинээр нэмсэн 8 үйлчилгээ.
  ServiceItem(
    id: 'cleaning',
    title: 'Гэр цэвэрлэгээ',
    description: 'Гэр, орон сууцны ерөнхий болон их цэвэрлэгээ',
    imageUrl: '',
    icon: Icons.cleaning_services_rounded,
  ),
  ServiceItem(
    id: 'babysitting',
    title: 'Хүүхэд харах үйлчилгээ',
    description: 'Хүүхэд асрах, харах үйлчилгээ',
    imageUrl: '',
    icon: Icons.child_care_rounded,
  ),
  ServiceItem(
    id: 'plumbing',
    title: 'Сантехникийн үйлчилгээ',
    description: 'Ус, шугам хоолой, крантын засвар үйлчилгээ',
    imageUrl: '',
    icon: Icons.plumbing_rounded,
  ),
  ServiceItem(
    id: 'furniture',
    title: 'Тавилга угсрах, засварлах',
    description: 'Тавилга угсрах, суурилуулах болон засварлах',
    imageUrl: '',
    icon: Icons.chair_alt_rounded,
  ),
  ServiceItem(
    id: 'moving',
    title: 'Ачаа зөөх, нүүлгэлт',
    description: 'Гэр, оффисын ачаа зөөх болон нүүлгэх',
    imageUrl: '',
    icon: Icons.local_shipping_rounded,
  ),
  ServiceItem(
    id: 'window_cleaning',
    title: 'Цонх угаах үйлчилгээ',
    description: 'Гэр, оффисын цонх, шилэн гадаргуу цэвэрлэх',
    imageUrl: '',
    icon: Icons.window_rounded,
  ),
  ServiceItem(
    id: 'yard_cleaning',
    title: 'Хашаа, гадна талбай цэвэрлэх',
    description: 'Хашаа, гадаах орчин, талбай цэвэрлэх',
    imageUrl: '',
    icon: Icons.yard_rounded,
  ),
  ServiceItem(
    id: 'snow_removal',
    title: 'Цас цэвэрлэх үйлчилгээ',
    description: 'Хашаа, явган зам болон гадна талбайн цас цэвэрлэх',
    imageUrl: '',
    icon: Icons.ac_unit_rounded,
  ),
];
