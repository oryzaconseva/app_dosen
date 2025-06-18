import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/dosen_model.dart';

class ApiService {
  final String baseUrl = "http://192.168.1.33:8000/api";

  Future<List<Dosen>> getDosens() async {
    final response = await http.get(Uri.parse('$baseUrl/dosen'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => Dosen.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data dosen');
    }
  }

  Future<bool> createDosen(Dosen dosen) async {
    final response = await http.post(
      Uri.parse('$baseUrl/dosen'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nip': dosen.nip,
        'nama_lengkap': dosen.namaLengkap,
        'no_telepon': dosen.noTelepon,
        'email': dosen.email,
        'alamat': dosen.alamat,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Gagal menambah data dosen. Status code: ${response.statusCode}');
    }
  }

  Future<bool> updateDosen(Dosen dosen) async {
    final response = await http.put(
      Uri.parse('$baseUrl/dosen/${dosen.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nip': dosen.nip,
        'nama_lengkap': dosen.namaLengkap,
        'no_telepon': dosen.noTelepon,
        'email': dosen.email,
        'alamat': dosen.alamat,
      }),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Gagal memperbarui data dosen.');
    }
  }

  Future<bool> deleteDosen(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/dosen/$id'),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Gagal menghapus data dosen.');
    }
  }


}