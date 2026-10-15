
import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  String formatHarga(int harga) {
    return 'Rp ${harga.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    )}';
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)?.settings.arguments;

    final List<Map<String, dynamic>> riwayat = data is List
        ? data
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList()
        : [];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F1),
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
        backgroundColor: const Color(0xFFFFF8F1),
        foregroundColor: const Color(0xFF78350F),
      ),
      body: riwayat.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 80,
                    color: Color(0xFF9A3412),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada riwayat pesanan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: riwayat.length,
              itemBuilder: (context, index) {
                final pesanan = riwayat[index];
                final items = (pesanan['items'] as List)
                    .whereType<Map>()
                    .map((item) => Map<String, dynamic>.from(item))
                    .toList();

                return Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pesanan #${index + 1}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...items.map(
                          (item) => Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item['name']} x${item['jumlah']}',
                                  ),
                                ),
                                Text(
                                  formatHarga(
                                    (item['price'] as int) *
                                        (item['jumlah'] as int),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(),
                        Text(
                          'Total: ${formatHarga(pesanan['total'] as int)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF9A3412),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
