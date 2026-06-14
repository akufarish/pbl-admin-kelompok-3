// lib/models/api_models.dart

class LoginResponse {
  final String token;
  final String userId;
  final String nama;
  LoginResponse({
    required this.token,
    required this.userId,
    required this.nama,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? json['access_token'] ?? '',
      userId: json['id']?.toString() ?? json['user_id']?.toString() ?? '',
      nama: json['nama'] ?? json['name'] ?? json['username'] ?? '',
    );
  }
}

// Sub-Model untuk Biodata
class Biodata {
  final String jenisKelamin;
  final String tempatLahir;
  final String tanggalLahir;
  final String agama;
  final String noHp;
  final String emailPribadi;

  Biodata.fromJson(Map<String, dynamic> json)
    : jenisKelamin = json['jenis_kelamin'] ?? '-',
      tempatLahir = json['tempat_lahir'] ?? '-',
      tanggalLahir = json['tanggal_lahir'] ?? '-',
      agama = json['agama'] ?? '-',
      noHp = json['no_hp'] ?? '-',
      emailPribadi = json['email_pribadi'] ?? '-';
}

// Sub-Model untuk Alamat
class Alamat {
  final String alamatDomisili;
  final String rtDomisili;
  final String rwDomisili;
  final String kelurahanDomisili;
  final String kodePosDomisili;

  Alamat.fromJson(Map<String, dynamic> json)
    : alamatDomisili = json['alamat_domisili'] ?? '-',
      rtDomisili = json['rt_domisili'] ?? '-',
      rwDomisili = json['rw_domisili'] ?? '-',
      kelurahanDomisili = json['kelurahan_domisili'] ?? '-',
      kodePosDomisili = json['kode_pos_domisili'] ?? '-';
}

// Sub-Model untuk Orang Tua Wali
class OrangTuaWali {
  final String jenisPeran;
  final String namaLengkap;
  final String pekerjaan;
  final String noTelepon;

  OrangTuaWali.fromJson(Map<String, dynamic> json)
    : jenisPeran = json['jenis_peran'] ?? '-',
      namaLengkap = json['nama_lengkap'] ?? '-',
      pekerjaan = json['pekerjaan'] ?? '-',
      noTelepon = json['no_telepon'] ?? '-';
}

class Mahasiswa {
  final String id;
  final String nim;
  final String nama;
  
  final String prodi; // Nanti mapping dari prodi_id
  final String status;

  // Objek Bersarang (Nested Objects)
  final Biodata? biodata;
  final Alamat? alamat;
  final List<OrangTuaWali> orangTuaWali;

  Mahasiswa({
    required this.id,
    required this.nim,
    required this.nama,
    required this.prodi,
    required this.status,
    this.biodata,
    this.alamat,
    required this.orangTuaWali,
  });

  factory Mahasiswa.fromJson(Map<String, dynamic> json) {
    String rawId =
        json['id_mahasiswa']?.toString() ?? json['id']?.toString() ?? '0';

    // Parsing list orang tua wali
    List<OrangTuaWali> listOrtu = [];
    if (json['orang_tua_wali'] != null && json['orang_tua_wali'] is List) {
      listOrtu = (json['orang_tua_wali'] as List)
          .map((i) => OrangTuaWali.fromJson(i))
          .toList();
    }

    return Mahasiswa(
      id: rawId,
      nim: json['nim'] ?? '',
      nama: json['nama_mahasiswa'] ?? json['nama'] ?? 'Tanpa Nama',
      prodi:
          json['prodi_id']?.toString() ??
          'Teknik Informatika', // Default sementara
      status:
          json['status'] ??
          'Aktif', // Karena status tidak ada di schema JSON kamu, kita set default
      biodata: json['biodata'] != null
          ? Biodata.fromJson(json['biodata'])
          : null,
      alamat: json['alamat'] != null ? Alamat.fromJson(json['alamat']) : null,
      orangTuaWali: listOrtu,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id_mahasiswa": id,
      "nim": nim,
      "nama_mahasiswa": nama,
      "prodi_id": prodi,
      // Field lain bisa disesuaikan untuk post/update
    };
  }
}
