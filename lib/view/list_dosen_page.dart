import 'package:flutter/material.dart';
import '../service/api_service.dart';
import '../model/dosen_model.dart';
import 'form_dosen_page.dart';

class ListDosenPage extends StatefulWidget {
  const ListDosenPage({super.key});

  @override
  State<ListDosenPage> createState() => _ListDosenPageState();
}

class _ListDosenPageState extends State<ListDosenPage> {
  final ApiService apiService = ApiService();
  late Future<List<Dosen>> _futureDosens;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _futureDosens = apiService.getDosens();
    });
  }

  void _showDeleteDialog(Dosen dosen) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Data'),
          content: Text('Apakah Anda yakin ingin menghapus data "${dosen.namaLengkap}"?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                try {
                  await apiService.deleteDosen(dosen.id);
                  Navigator.of(context).pop();
                  _refreshData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Data berhasil dihapus!')),
                  );
                } catch (e) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menghapus data: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Data Pegawai Dosen', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: FutureBuilder<List<Dosen>>(
        future: _futureDosens,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Error: ${snapshot.error}', textAlign: TextAlign.center),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Tidak ada data dosen.', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            );
          } else {
            List<Dosen> dosens = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: dosens.length,
              itemBuilder: (context, index) {
                Dosen dosen = dosens[index];
                return Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.indigo[100],
                      child: Text(
                        dosen.namaLengkap.isNotEmpty ? dosen.namaLengkap[0] : '?',
                        style: const TextStyle(fontSize: 24, color: Colors.indigo, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(dosen.namaLengkap, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("NIP: ${dosen.nip}"),
                        Text(dosen.email),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue[400]),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => FormDosenPage(dosen: dosen)),
                            );
                            if (result == true) {
                              _refreshData();
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red[400]),
                          onPressed: () => _showDeleteDialog(dosen),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormDosenPage()),
          );
          if (result == true) {
            _refreshData();
          }
        },
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add),
      ),
    );
  }
}