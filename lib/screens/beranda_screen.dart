// lib/screens/beranda_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hit_api/providers/app_provider.dart';

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) context.read<AppProvider>().fetchMahasiswa();
    });
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<AppProvider>();

    // Hitung manual agar tidak error (Karena di AppProvider tidak ada variabel ini)
    final int mahasiswaAktif = prov.mahasiswaList
        .where((m) => m.status.toLowerCase() == 'aktif')
        .length;
    final int mahasiswaNonAktif = prov.mahasiswaList
        .where((m) => m.status.toLowerCase() == 'non aktif')
        .length;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 35, width: 35),
            const SizedBox(width: 12),
            const Text(
              'Simpadu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Header Biru Melengkung Ala Figma
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 30,
              top: 10,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF1E3A8A),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, ${prov.loggedInNama ?? "Admin"} 👋',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Selamat datang di dashboard admin',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          // Konten Statistik
          Expanded(
            child: prov.isLoading && prov.mahasiswaList.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF1E3A8A)),
                  )
                : RefreshIndicator(
                    onRefresh: () async => await prov.fetchMahasiswa(),
                    child: ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        const Text(
                          "Ringkasan Data",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 15),
                        _buildStatCard(
                          'Total Mahasiswa',
                          '${prov.mahasiswaList.length}',
                          Icons.school,
                          Colors.blue,
                        ),
                        const SizedBox(height: 15),
                        _buildStatCard(
                          'Mahasiswa Aktif',
                          '$mahasiswaAktif',
                          Icons.person_outline,
                          Colors.green,
                        ),
                        const SizedBox(height: 15),
                        _buildStatCard(
                          'Mahasiswa Non Aktif',
                          '$mahasiswaNonAktif',
                          Icons.person_off_outlined,
                          Colors.red,
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String count,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 35),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                count,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
