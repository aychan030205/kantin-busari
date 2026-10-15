
import 'package:flutter/material.dart';

class MenuDetailPage extends StatefulWidget {
  const MenuDetailPage({super.key});

  @override
  State<MenuDetailPage> createState() => _MenuDetailPageState();
}

class _MenuDetailPageState extends State<MenuDetailPage> {
  int jumlah = 1;

  String formatHarga(int harga) {
    return 'Rp ${harga.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    )}';
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)?.settings.arguments;

    final Map<String, dynamic> menu = arg is Map
        ? Map<String, dynamic>.from(arg)
        : {
            'name': 'Nasi Goreng',
            'price': 15000,
            'category': 'Makanan',
            'icon': Icons.rice_bowl,
          };

    final nama = menu['name'] as String;
    final harga = menu['price'] as int;
    final kategori = menu['category'] as String;
    final ikon = menu['icon'] is IconData
        ? menu['icon'] as IconData
        : Icons.restaurant;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F1),
      appBar: AppBar(
        title: const Text('Detail Menu'),
        backgroundColor: const Color(0xFFFFF8F1),
        foregroundColor: const Color(0xFF78350F),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE7CB),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Icon(
              ikon,
              size: 80,
              color: const Color(0xFF9A3412),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            kategori,
            style: const TextStyle(
              color: Color(0xFF9A3412),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            nama,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF78350F),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            formatHarga(harga),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF9A3412),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Tentang Menu',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$nama merupakan salah satu pilihan menu '
            'di Kantin Bu Sari dengan harga terjangkau.',
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Jumlah Pesanan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: jumlah > 1
                      ? () => setState(() => jumlah--)
                      : null,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text(
                  '$jumlah',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => jumlah++),
                  icon: const Icon(
                    Icons.add_circle,
                    color: Color(0xFF9A3412),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEDD5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Harga',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  formatHarga(harga * jumlah),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9A3412),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: SizedBox(
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(
                context,
                {
                  'name': nama,
                  'price': harga,
                  'category': kategori,
                  'icon': ikon,
                  'jumlah': jumlah,
                },
              );
            },
            icon: const Icon(Icons.shopping_cart_outlined),
            label: const Text('Tambah ke Keranjang'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9A3412),
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
