// lib/screens/mahasiswa_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'detail_mahasiswa_screen.dart';

class MahasiswaScreen extends StatefulWidget {
  const MahasiswaScreen({super.key});

  @override
  State<MahasiswaScreen> createState() => _MahasiswaScreenState();
}

class _MahasiswaScreenState extends State<MahasiswaScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  String? _selectedAngkatan;
  String? _selectedProdi;
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) context.read<AppProvider>().fetchMahasiswa();
    });
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterModal(BuildContext context) {
    String? tempAngkatan = _selectedAngkatan;
    String? tempProdi = _selectedProdi;
    String? tempStatus = _selectedStatus;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Filter Mahasiswa",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Filter Angkatan
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Angkatan",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    value: tempAngkatan,
                    items: ['2020', '2021', '2022', '2023'].map((String val) {
                      return DropdownMenuItem(value: val, child: Text(val));
                    }).toList(),
                    onChanged: (val) => setModalState(() => tempAngkatan = val),
                  ),
                  const SizedBox(height: 15),

                  // Filter Program Studi
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Program Studi",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    value: tempProdi,
                    items:
                        [
                          'Teknologi Informasi',
                          'Sistem Informasi',
                          'Teknik Informatika',
                        ].map((String val) {
                          return DropdownMenuItem(value: val, child: Text(val));
                        }).toList(),
                    onChanged: (val) => setModalState(() => tempProdi = val),
                  ),
                  const SizedBox(height: 15),

                  // Filter Status
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Status",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    value: tempStatus,
                    items: ['Aktif', 'Non Aktif'].map((String val) {
                      return DropdownMenuItem(value: val, child: Text(val));
                    }).toList(),
                    onChanged: (val) => setModalState(() => tempStatus = val),
                  ),
                  const SizedBox(height: 25),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            side: const BorderSide(color: Color(0xFF1E3A8A)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            setModalState(() {
                              tempAngkatan = null;
                              tempProdi = null;
                              tempStatus = null;
                            });
                            setState(() {
                              _selectedAngkatan = null;
                              _selectedProdi = null;
                              _selectedStatus = null;
                            });
                          },
                          child: const Text(
                            "Atur Ulang",
                            style: TextStyle(color: Color(0xFF1E3A8A)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            backgroundColor: const Color(0xFF1E3A8A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedAngkatan = tempAngkatan;
                              _selectedProdi = tempProdi;
                              _selectedStatus = tempStatus;
                            });
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Terapkan",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<AppProvider>();
    final rawData = prov.mahasiswaList;

    final filteredList = rawData.where((mhs) {
      final matchesSearch =
          mhs.nama.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          mhs.nim.toLowerCase().contains(_searchQuery.toLowerCase());
      final angkatan = mhs.nim.length >= 2 ? mhs.nim.substring(0, 2) : '';

      // Ambil 2 digit tahun dari filter (misal "2020" jadi "20") untuk dicocokkan dengan awalan NIM
      final filterAngkatanDigit = _selectedAngkatan != null
          ? _selectedAngkatan!.substring(2, 4)
          : null;
      final matchAngkatan =
          filterAngkatanDigit == null || angkatan == filterAngkatanDigit;

      final matchProdi =
          _selectedProdi == null ||
          mhs.prodi.toLowerCase() == _selectedProdi!.toLowerCase();
      final matchStatus =
          _selectedStatus == null ||
          mhs.status.toLowerCase() == _selectedStatus!.toLowerCase();

      return matchesSearch && matchAngkatan && matchProdi && matchStatus;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        title: const Text(
          "Mahasiswa",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header Search & Filter area
          Container(
            color: const Color(0xFF1E3A8A),
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Cari Nama atau NIM",
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _showFilterModal(context),
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.filter_list,
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // List Mahasiswa
          Expanded(
            child: prov.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF1E3A8A)),
                  )
                : filteredList.isEmpty
                ? const Center(child: Text("Data mahasiswa tidak ditemukan"))
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final mhs = filteredList[index];
                      bool isAktif = mhs.status.toLowerCase() == 'aktif';

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailMahasiswaScreen(
                                mahasiswa:
                                    mhs, // <--- Ini perbaikannya (lempar object utuh)
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CircleAvatar(
                                radius: 25,
                                backgroundImage: AssetImage(
                                  'assets/images/logo.png',
                                ),
                                backgroundColor: Colors.transparent,
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      mhs.nama,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      mhs.nim.isEmpty ? '-' : mhs.nim,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      mhs.prodi.isEmpty ? '-' : mhs.prodi,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: isAktif
                                      ? Colors.green.shade50
                                      : Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isAktif ? Colors.green : Colors.red,
                                    width: 0.5,
                                  ),
                                ),
                                child: Text(
                                  mhs.status,
                                  style: TextStyle(
                                    color: isAktif ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      // FAB untuk tambah mahasiswa (Sekalian saya fix agar langsung mengarah ke form tambah)
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1E3A8A),
        onPressed: () async {
          final res = await Navigator.pushNamed(context, '/tambah-user');
          if (res == true && context.mounted) {
            context.read<AppProvider>().fetchMahasiswa();
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
