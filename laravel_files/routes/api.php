<?php

use App\Http\Controllers\Api\AuthController;
use Illuminate\Support\Facades\Route;

// Routes publiques
Route::prefix('auth')->group(function () {
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login', [AuthController::class, 'login']);
});

// Routes protégées (nécessitent authentification)
Route::middleware('auth:sanctum')->group(function () {
    Route::prefix('auth')->group(function () {
        Route::get('/me', [AuthController::class, 'me']);
        Route::post('/logout', [AuthController::class, 'logout']);
    });

    // Ajoutez ici vos autres routes protégées
    // Exemple :
    // Route::apiResource('clients', ClientController::class);
    // Route::apiResource('mesures', MesureController::class);
    // Route::apiResource('commandes', CommandeController::class);
});