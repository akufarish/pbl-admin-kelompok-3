// lib/models/user.dart

class UserRequest {
  String nama;
  String email;
  String? password;
  String? nim;
  String? prodi;
  String? status;

  UserRequest({
    required this.nama,
    required this.email,
    this.password,
    this.nim,
    this.prodi,
    this.status,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {"nama": nama, "email": email};
    if (password != null && password!.isNotEmpty) data["password"] = password;
    if (nim != null && nim!.isNotEmpty) data["nim"] = nim;
    if (prodi != null && prodi!.isNotEmpty) data["prodi"] = prodi;
    if (status != null && status!.isNotEmpty) data["status"] = status;
    return data;
  }
}

class UserResponse {
  String id;
  String nama;
  String email;
  String nim;
  String prodi;
  String status;

  UserResponse({
    required this.id,
    required this.nama,
    required this.email,
    required this.nim,
    required this.prodi,
    required this.status,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    // GENERATE DATA SIMULASI JIKA DARI API KELOMPOK 4 NILAINYA KOSONG
    String rawId = json['id']?.toString() ?? '0';

    return UserResponse(
      id: rawId,
      nama: json['nama'] ?? json['name'] ?? 'Tanpa Nama',
      email: json['email'] ?? 'tanpa_email@gmail.com',
      nim:
          json['nim'] ??
          json['username'] ??
          'C0303200$rawId', // Auto-generate NIM berdasarkan ID
      prodi:
          json['prodi'] ??
          json['program_studi'] ??
          'Teknik Informatika', // Default prodi
      status: json['status'] ?? 'Aktif', // Default status aktif
    );
  }
}
