<?php

use App\Models\User;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    $user = User::query()->first();
    return view('welcome', ['user' => $user]);
});
