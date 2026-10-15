
import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<Map<String, dynamic>> keranjang = [];
  bool sudahMemuat = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (sudahMemuat) return;
    sudahMemuat = true;

    final data = ModalRoute.of(context)?.settings.arguments;

    if (data is List) {
      keranjang = data
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    } else {
      keranjang = [];
    }
  }

  String formatHarga(int harga) {
    return 'Rp ${harga.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    )}';
  }

  int get totalHarga {
    return keranjang.fold<int>(
      0,
      (total, item) =>
          total +
          (item['price'] as int) * (item['jumlah'] as int),
    );
  }

  void ubahJumlah(int index, int perubahan) {
    setState(() {
      final jumlahBaru =
          (keranjang[index]['jumlah'] as int) + perubahan;

      if (jumlahBaru <= 0) {
        keranjang.removeAt(index);
      } else {
        keranjang[index]['jumlah'] = jumlahBaru;
      }
    });
  }

  void prosesCheckout() {
    if (keranjang.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Keranjang masih kosong!'),
        ),
      );
      return;
    }

    final pesananSelesai = <String, dynamic>{
      'items': keranjang
          .map((item) => Map<String, dynamic>.from(item))
          .toList(),
      'total': totalHarga,
      'tanggal': DateTime.now().toString(),
    };

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 50,
        ),
        title: const Text('Pesanan Berhasil!'),
        content: Text(
          'Pesanan kamu berhasil dibuat.\n'
          'Total pembayaran: ${formatHarga(totalHarga)}',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);

              // Mengirim data pesanan ke halaman menu.
              Navigator.pop(context, pesananSelesai);
            },
            child: const Text('Kembali ke Menu'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F1),
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
        backgroundColor: const Color(0xFFFFF8F1),
        foregroundColor: const Color(0xFF78350F),
      ),
      body: keranjang.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_cart_outlined,
                    size: 75,
                    color: Color(0xFF9A3412),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Keranjang masih kosong',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Pilih Menu'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: keranjang.length,
                    itemBuilder: (context, index) {
                      final item = keranjang[index];
                      final harga = item['price'] as int;
                      final jumlah = item['jumlah'] as int;

                      return Card(
                        color: Colors.white,
                        margin:
                            const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFFFFEDD5),
                            child: Icon(
                              Icons.restaurant,
                              color: Color(0xFF9A3412),
                            ),
                          ),
                          title: Text(
                            item['name'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(formatHarga(harga)),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () =>
                                        ubahJumlah(index, -1),
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                    ),
                                  ),
                                  Text('$jumlah'),
                                  IconButton(
                                    onPressed: () =>
                                        ubahJumlah(index, 1),
                                    icon: const Icon(
                                      Icons.add_circle_outline,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Text(
                            formatHarga(harga * jumlah),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF9A3412),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.fromLTRB(20, 18, 20, 24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(22),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Harga',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              formatHarga(totalHarga),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF9A3412),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: prosesCheckout,
                            icon: const Icon(
                              Icons.shopping_bag_outlined,
                            ),
                            label: const Text('Checkout'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFF9A3412),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
