<?php

namespace App\Http\Controllers;

use Laravel\Lumen\Routing\Controller;

class UserController extends Controller
{
    public function index()
    {
        return response()->json([
            'users' => [
                ['id' => 1, 'name' => 'Afcha'],
                ['id' => 2, 'name' => 'Chaca'],
                ['id' => 3, 'name' => 'Rona'],
                ['id' => 4, 'name' => 'Rahmi'],
                ['id' => 5, 'name' => 'Acim'],
                ['id' => 6, 'name' => 'Suja'],
                ['id' => 7, 'name' => 'Fikri'],
                ['id' => 8, 'name' => 'Sahal'],
                ['id' => 9, 'name' => 'Ira'],
                ['id' => 10, 'name' => 'Felish'],
            ]
            ]);
    }
}
