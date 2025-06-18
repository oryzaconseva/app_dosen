<?php

/** @var \Laravel\Lumen\Routing\Router $router */

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It is a breeze. Simply tell Lumen the URIs it should respond to
| and give it the Closure to call when that URI is requested.
|
*/

$router->get('/', function () use ($router) {
    return response()->json(['message' => 'API Ready']);
});

$router->get('/', function () use ($router) {
    return response()->json(['message' => 'Hello, Semua MI2C!']);
});

$router->get('/users', 'UserController@index');

$router->group(['prefix' => 'api'], function () use ($router) {
    //dosen
    $router->get('/dosen', 'DosenController@index');
    $router->post('/dosen', 'DosenController@store');
    $router->get('/dosen/{id}', 'DosenController@show');
    $router->put('/dosen/{id}', 'DosenController@update');
    $router->delete('/dosen/{id}', 'DosenController@destroy');
});
