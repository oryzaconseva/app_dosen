import 'package:flutter/material.dart';
import '../model/dosen_model.dart';
import '../service/api_service.dart';

class FormDosenPage extends StatefulWidget {
  final Dosen? dosen;
  const FormDosenPage({super.key, this.dosen});

  @override
  State<FormDosenPage> createState() => _FormDosenPageState();
}

class _FormDosenPageState extends State<FormDosenPage> {
  final _formKey = GlobalKey<FormState>();
  final _nipController = TextEditingController();
  final _namaController = TextEditingController();
  final _noTelpController = TextEditingController();
  final _emailController = TextEditingController();
  final _alamatController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.dosen != null) {
      _nipController.text = widget.dosen!.nip;
      _namaController.text = widget.dosen!.namaLengkap;
      _noTelpController.text = widget.dosen!.noTelepon;
      _emailController.text = widget.dosen!.email;
      _alamatController.text = widget.dosen!.alamat;
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final dosenData = Dosen(
        id: widget.dosen?.id ?? 0,
        nip: _nipController.text,
        namaLengkap: _namaController.text,
        noTelepon: _noTelpController.text,
        email: _emailController.text,
        alamat: _alamatController.text,
      );

      try {
        if (widget.dosen == null) {
          await _apiService.createDosen(dosenData);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data berhasil ditambahkan!')));
        } else {
          await _apiService.updateDosen(dosenData);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data berhasil diperbarui!')));
        }
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menyimpan data: $e')));
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dosen == null ? 'Tambah Data Dosen' : 'Edit Data Dosen'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextFormField(_nipController, 'NIP', Icons.badge_outlined),
              const SizedBox(height: 16),
              _buildTextFormField(_namaController, 'Nama Lengkap', Icons.person_outline),
              const SizedBox(height: 16),
              _buildTextFormField(_noTelpController, 'No. Telepon', Icons.phone_outlined, keyboardType: TextInputType.phone),
              const SizedBox(height: 16),
              _buildTextFormField(_emailController, 'Email', Icons.email_outlined, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              _buildTextFormField(_alamatController, 'Alamat', Icons.location_on_outlined),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Simpan', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  TextFormField _buildTextFormField(TextEditingController controller, String label, IconData icon, {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label tidak boleh kosong';
        }
        if (label == 'Email' && value.isNotEmpty && !value.contains('@')) {
          return 'Format email tidak valid';
        }
        return null;
      },
    );
  }
}