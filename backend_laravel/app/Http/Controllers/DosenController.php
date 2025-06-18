<?php

namespace App\Http\Controllers;

use App\Models\Dosen;
use Illuminate\Http\Request;

class DosenController extends Controller
{
    public function index()
    {
        $dosens = Dosen::orderBy('id', 'desc')->get();
        return response()->json(['success' => true, 'message' => 'Daftar Data Dosen', 'data' => $dosens]);
    }

    public function store(Request $request)
    {

        $this->validate($request, [
        'nip' => 'required|unique:dosens,nip',
        'nama_lengkap' => 'required|string',
        'no_telepon' => 'required|string',
        'alamat' => 'required|string',
        'email' => 'email|nullable',
    ]);

    $dosen = Dosen::create([
        'nip' => $request->input('nip'),
        'nama_lengkap' => $request->input('nama_lengkap'),
        'no_telepon' => $request->input('no_telepon'),
        'alamat' => $request->input('alamat'),
        'email' => $request->input('email'),
    ]);


    if ($dosen) {
        return response()->json([
            'success' => true,
            'message' => 'Data Dosen Berhasil Ditambahkan!',
            'data' => $dosen
        ], 201);
    }

    return response()->json([
        'success' => false,
        'message' => 'Data Dosen Gagal Ditambahkan.',
    ], 400);
}

    public function show($id)
    {
        $dosen = Dosen::find($id);
        if (!$dosen) {
            return response()->json(['success' => false, 'message' => 'Data tidak ditemukan'], 404);
        }
        return response()->json(['success' => true, 'data' => $dosen]);
    }

    public function update(Request $request, $id)
    {
        $dosen = Dosen::find($id);
        if (!$dosen) {
        return response()->json(['success' => false, 'message' => 'Data tidak ditemukan'], 404);
    }

    // Validasi data yang masuk untuk update
    $validatedData = $this->validate($request, [
        'nip'          => 'required|string|unique:dosens,nip,'.$dosen->id,
        'nama_lengkap' => 'required|string',
        'no_telepon'   => 'required|string',
        'alamat'       => 'required|string',
        'email'        => 'nullable|email'
    ]);


    $dosen->update($validatedData);

    return response()->json([
        'success' => true,
        'message' => 'Data Dosen Berhasil Diperbarui',
        'data'    => $dosen
    ]);
    }

    public function destroy($id)
    {
        $dosen = Dosen::find($id);
        if (!$dosen) {
            return response()->json(['success' => false, 'message' => 'Data tidak ditemukan'], 404);
        }
        $dosen->delete();
        return response()->json(['success' => true, 'message' => 'Data Dosen Berhasil Dihapus']);
    }
}
