
import 'package:flutter/material.dart';

class MenuListPage extends StatefulWidget {
  const MenuListPage({super.key});

  @override
  State<MenuListPage> createState() => _MenuListPageState();
}

class _MenuListPageState extends State<MenuListPage> {
  final TextEditingController searchController = TextEditingController();

  String selectedCategory = 'Semua';

  final List<Map<String, dynamic>> menus = [
    {
      'name': 'Nasi Goreng',
      'price': 15000,
      'category': 'Makanan',
      'icon': Icons.rice_bowl,
      'image': 'assets/images/nasi_goreng.jpg',
      'favorite': false,
    },
    {
      'name': 'Mie Ayam',
      'price': 12000,
      'category': 'Makanan',
      'icon': Icons.ramen_dining,
      'image': 'assets/images/mie_ayam.jpg',
      'favorite': false,
    },
    {
      'name': 'Ayam Geprek',
      'price': 18000,
      'category': 'Makanan',
      'icon': Icons.dinner_dining,
      'image': 'assets/images/ayam_geprek.jpg',
      'favorite': false,
    },
    {
      'name': 'Es Teh',
      'price': 5000,
      'category': 'Minuman',
      'icon': Icons.local_cafe,
      'image': 'assets/images/es_teh.jpg',
      'favorite': false,
    },
    {
      'name': 'Jus Alpukat',
      'price': 10000,
      'category': 'Minuman',
      'icon': Icons.local_drink,
      'image': 'assets/images/jus_alpukat.jpg',
      'favorite': false,
    },
    {
      'name': 'Bakso',
      'price': 14000,
      'category': 'Makanan',
      'icon': Icons.soup_kitchen,
      'image': 'assets/images/bakso.jpg',
      'favorite': false,
    },
  ];

  final List<Map<String, dynamic>> keranjang = [];
  final List<Map<String, dynamic>> riwayat = [];

  String formatHarga(int harga) {
    return 'Rp ${harga.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    )}';
  }

  int get jumlahKeranjang {
    return keranjang.fold<int>(
      0,
      (total, item) => total + ((item['jumlah'] as int?) ?? 0),
    );
  }

  Widget gambarMenu(
    Map<String, dynamic> menu, {
    double width = 85,
    double height = 85,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.asset(
        menu['image'] as String,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: const Color(0xFFFFEDD5),
            alignment: Alignment.center,
            child: Icon(
              menu['icon'] as IconData,
              size: 36,
              color: const Color(0xFF9A3412),
            ),
          );
        },
      ),
    );
  }

  Future<void> bukaDetail(Map<String, dynamic> menu) async {
    final hasil = await Navigator.pushNamed(
      context,
      '/detail',
      arguments: menu,
    );

    if (!mounted || hasil is! Map) return;

    final item = Map<String, dynamic>.from(hasil);
    final nama = item['name'] as String;
    final jumlah = item['jumlah'] as int;

    setState(() {
      final index = keranjang.indexWhere(
        (data) => data['name'] == nama,
      );

      if (index >= 0) {
        keranjang[index]['jumlah'] =
            ((keranjang[index]['jumlah'] as int?) ?? 0) + jumlah;
      } else {
        keranjang.add(item);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$nama ditambahkan ke keranjang')),
    );
  }

  Future<void> bukaKeranjang() async {
    final hasil = await Navigator.pushNamed(
      context,
      '/pesan',
      arguments: keranjang,
    );

    if (!mounted) return;

    if (hasil is Map && hasil['items'] is List) {
      final pesanan = Map<String, dynamic>.from(hasil);

      setState(() {
        riwayat.add(pesanan);
        keranjang.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pesanan berhasil masuk ke riwayat!'),
        ),
      );
    } else {
      setState(() {});
    }
  }

  Future<void> bukaRiwayat() async {
    await Navigator.pushNamed(
      context,
      '/riwayat',
      arguments: riwayat,
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredMenus = menus.where((menu) {
      final cocokNama = (menu['name'] as String)
          .toLowerCase()
          .contains(searchController.text.toLowerCase());

      final cocokKategori = selectedCategory == 'Semua' ||
          menu['category'] == selectedCategory;

      return cocokNama && cocokKategori;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8F1),
        foregroundColor: const Color(0xFF78350F),
        title: const Text(
          'Kantin Bu Sari',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Riwayat Pesanan',
            onPressed: bukaRiwayat,
            icon: const Icon(Icons.receipt_long_outlined),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                tooltip: 'Keranjang',
                onPressed: bukaKeranjang,
                icon: const Icon(Icons.shopping_bag_outlined),
              ),
              if (jumlahKeranjang > 0)
                Positioned(
                  right: 5,
                  top: 5,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$jumlahKeranjang',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFF9A3412),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lapar? Yuk, Makan!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Temukan menu favoritmu di Kantin Bu Sari.',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          TextField(
            controller: searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Cari makanan atau minuman...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Kategori Menu',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: ['Semua', 'Makanan', 'Minuman'].map((kategori) {
              return ChoiceChip(
                label: Text(kategori),
                selected: selectedCategory == kategori,
                selectedColor: const Color(0xFFFED7AA),
                onSelected: (_) {
                  setState(() => selectedCategory = kategori);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 22),
          const Text(
            'Menu Pilihan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (filteredMenus.isEmpty)
            const Center(child: Text('Menu tidak ditemukan.')),
          ...filteredMenus.map((menu) {
            return Card(
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    gambarMenu(menu),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            menu['name'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            menu['category'] as String,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            formatHarga(menu['price'] as int),
                            style: const TextStyle(
                              color: Color(0xFF9A3412),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        IconButton(
                          tooltip: 'Favorit',
                          onPressed: () {
                            setState(() {
                              menu['favorite'] = !(menu['favorite'] as bool);
                            });
                          },
                          icon: Icon(
                            menu['favorite'] == true
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: menu['favorite'] == true
                                ? Colors.red
                                : Colors.grey,
                          ),
                        ),
                        IconButton(
                          tooltip: 'Lihat detail',
                          onPressed: () => bukaDetail(menu),
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
