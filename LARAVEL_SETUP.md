# Guide complet de création de l'API Laravel

Ce guide vous accompagne dans la création complète de l'API Laravel pour votre application Mon Tailleur.

## Table des matières
1. [Installation de Laravel](#1-installation-de-laravel)
2. [Configuration de la base de données](#2-configuration-de-la-base-de-données)
3. [Installation de Laravel Sanctum](#3-installation-de-laravel-sanctum)
4. [Création des migrations](#4-création-des-migrations)
5. [Création du contrôleur d'authentification](#5-création-du-contrôleur-dauthentification)
6. [Configuration des routes](#6-configuration-des-routes)
7. [Configuration CORS](#7-configuration-cors)
8. [Test de l'API](#8-test-de-lapi)
9. [Démarrage du développement](#9-démarrage-du-développement)

---

## 1. Installation de Laravel

### Option A: Installation dans un dossier séparé (recommandé)

```bash
# Créer un dossier pour le backend à côté du projet Flutter
cd C:\Users\aaron\StudioProjects
composer create-project laravel/laravel mon_tailleur_api

# Aller dans le dossier du projet
cd mon_tailleur_api
```

### Option B: Installation dans le même dossier

```bash
# Dans le dossier actuel
cd C:\Users\aaron\StudioProjects\mon_tailleur
mkdir backend
cd backend
composer create-project laravel/laravel .
```

**Pour ce guide, nous utiliserons l'Option A (dossier séparé).**

---

## 2. Configuration de la base de données

### Éditer le fichier `.env`

```bash
cd mon_tailleur_api
code .env  # ou notepad .env
```

Modifiez les lignes suivantes :

```env
APP_NAME="Mon Tailleur API"
APP_URL=http://localhost:8000

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=mon_tailleur
DB_USERNAME=root
DB_PASSWORD=votre_mot_de_passe
```

### Créer la base de données

```bash
# Ouvrir MySQL
mysql -u root -p

# Dans MySQL
CREATE DATABASE mon_tailleur CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
EXIT;
```

Ou via PHPMyAdmin : Créer une nouvelle base de données nommée `mon_tailleur`.

---

## 3. Installation de Laravel Sanctum

Laravel Sanctum permet de gérer l'authentification par token pour les API.

```bash
# Installer Sanctum
composer require laravel/sanctum

# Publier la configuration
php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"

# Exécuter les migrations
php artisan migrate
```

### Configurer Sanctum

Éditer `app/Http/Kernel.php` et ajouter le middleware dans `api` :

```php
'api' => [
    \Laravel\Sanctum\Http\Middleware\EnsureFrontendRequestsAreStateful::class,
    \Illuminate\Routing\Middleware\ThrottleRequests::class.':api',
    \Illuminate\Routing\Middleware\SubstituteBindings::class,
],
```

Éditer `app/Models/User.php` et ajouter le trait :

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    protected $fillable = [
        'name',
        'email',
        'password',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }
}
```

---

## 4. Création des migrations

Les migrations de base de Laravel incluent déjà une table users. Créons des migrations supplémentaires pour votre application de tailleur.

```bash
# Créer des migrations pour votre application
php artisan make:migration create_clients_table
php artisan make:migration create_mesures_table
php artisan make:migration create_commandes_table
```

### Migration clients (database/migrations/xxxx_create_clients_table.php)

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('clients', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->string('nom');
            $table->string('prenom');
            $table->string('telephone');
            $table->string('adresse')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('clients');
    }
};
```

### Migration mesures (database/migrations/xxxx_create_mesures_table.php)

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('mesures', function (Blueprint $table) {
            $table->id();
            $table->foreignId('client_id')->constrained()->onDelete('cascade');
            $table->string('type_vetement'); // Chemise, Pantalon, Veste, etc.
            $table->decimal('longueur', 8, 2)->nullable();
            $table->decimal('largeur_epaule', 8, 2)->nullable();
            $table->decimal('tour_poitrine', 8, 2)->nullable();
            $table->decimal('tour_taille', 8, 2)->nullable();
            $table->decimal('tour_hanche', 8, 2)->nullable();
            $table->decimal('longueur_manche', 8, 2)->nullable();
            $table->decimal('tour_cou', 8, 2)->nullable();
            $table->json('autres_mesures')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('mesures');
    }
};
```

### Migration commandes (database/migrations/xxxx_create_commandes_table.php)

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('commandes', function (Blueprint $table) {
            $table->id();
            $table->foreignId('client_id')->constrained()->onDelete('cascade');
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->string('numero_commande')->unique();
            $table->string('type_vetement');
            $table->text('description')->nullable();
            $table->decimal('prix', 10, 2);
            $table->date('date_prise');
            $table->date('date_livraison_prevue');
            $table->enum('statut', ['en_attente', 'en_cours', 'termine', 'livre', 'annule'])->default('en_attente');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('commandes');
    }
};
```

### Exécuter les migrations

```bash
php artisan migrate
```

---

## 5. Création du contrôleur d'authentification

```bash
php artisan make:controller Api/AuthController
```

Éditer `app/Http/Controllers/Api/AuthController.php` :

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    /**
     * Inscription d'un nouvel utilisateur
     */
    public function register(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8|confirmed',
        ]);

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'user' => $user,
            'token' => $token,
            'message' => 'Inscription réussie'
        ], 201);
    }

    /**
     * Connexion d'un utilisateur
     */
    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        $user = User::where('email', $request->email)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            throw ValidationException::withMessages([
                'email' => ['Les informations d\'identification fournies sont incorrectes.'],
            ]);
        }

        // Révoquer les anciens tokens
        $user->tokens()->delete();

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'user' => $user,
            'token' => $token,
            'message' => 'Connexion réussie'
        ]);
    }

    /**
     * Récupérer l'utilisateur connecté
     */
    public function me(Request $request)
    {
        return response()->json($request->user());
    }

    /**
     * Déconnexion
     */
    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'message' => 'Déconnexion réussie'
        ]);
    }
}
```

---

## 6. Configuration des routes

Éditer `routes/api.php` :

```php
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
    // Route::apiResource('clients', ClientController::class);
    // Route::apiResource('commandes', CommandeController::class);
});
```

---

## 7. Configuration CORS

Éditer `config/cors.php` :

```php
<?php

return [
    'paths' => ['api/*', 'sanctum/csrf-cookie'],
    'allowed_methods' => ['*'],
    'allowed_origins' => ['*'],
    'allowed_origins_patterns' => [],
    'allowed_headers' => ['*'],
    'exposed_headers' => [],
    'max_age' => 0,
    'supports_credentials' => false,
];
```

**Note:** En production, remplacez `'allowed_origins' => ['*']` par votre domaine spécifique.

---

## 8. Test de l'API

### Démarrer le serveur Laravel

```bash
php artisan serve
```

Le serveur démarre sur `http://localhost:8000`.

### Tester avec Postman ou cURL

#### 1. Test d'inscription

```bash
curl -X POST http://localhost:8000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@example.com",
    "password": "password123",
    "password_confirmation": "password123"
  }'
```

Réponse attendue :
```json
{
  "user": {
    "id": 1,
    "name": "Test User",
    "email": "test@example.com",
    "created_at": "2024-01-01T00:00:00.000000Z",
    "updated_at": "2024-01-01T00:00:00.000000Z"
  },
  "token": "1|abcdefghijklmnopqrstuvwxyz...",
  "message": "Inscription réussie"
}
```

#### 2. Test de connexion

```bash
curl -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

#### 3. Test de récupération de l'utilisateur

```bash
curl -X GET http://localhost:8000/api/auth/me \
  -H "Authorization: Bearer VOTRE_TOKEN_ICI" \
  -H "Accept: application/json"
```

#### 4. Test de déconnexion

```bash
curl -X POST http://localhost:8000/api/auth/logout \
  -H "Authorization: Bearer VOTRE_TOKEN_ICI" \
  -H "Accept: application/json"
```

---

## 9. Démarrage du développement

### Créer les modèles et contrôleurs pour votre application

```bash
# Créer le modèle Client avec contrôleur
php artisan make:model Client -c

# Créer le modèle Mesure avec contrôleur
php artisan make:model Mesure -c

# Créer le modèle Commande avec contrôleur
php artisan make:model Commande -c
```

### Structure recommandée pour les contrôleurs API

Créer des contrôleurs dans le namespace API :

```bash
php artisan make:controller Api/ClientController --api
php artisan make:controller Api/MesureController --api
php artisan make:controller Api/CommandeController --api
```

### Exemple de ClientController

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Client;
use Illuminate\Http\Request;

class ClientController extends Controller
{
    public function index()
    {
        $clients = Client::where('user_id', auth()->id())->get();
        return response()->json($clients);
    }

    public function store(Request $request)
    {
        $request->validate([
            'nom' => 'required|string|max:255',
            'prenom' => 'required|string|max:255',
            'telephone' => 'required|string|max:20',
            'adresse' => 'nullable|string',
        ]);

        $client = Client::create([
            'user_id' => auth()->id(),
            'nom' => $request->nom,
            'prenom' => $request->prenom,
            'telephone' => $request->telephone,
            'adresse' => $request->adresse,
        ]);

        return response()->json($client, 201);
    }

    public function show(Client $client)
    {
        // Vérifier que le client appartient à l'utilisateur
        if ($client->user_id !== auth()->id()) {
            return response()->json(['message' => 'Non autorisé'], 403);
        }

        return response()->json($client);
    }

    public function update(Request $request, Client $client)
    {
        if ($client->user_id !== auth()->id()) {
            return response()->json(['message' => 'Non autorisé'], 403);
        }

        $request->validate([
            'nom' => 'sometimes|required|string|max:255',
            'prenom' => 'sometimes|required|string|max:255',
            'telephone' => 'sometimes|required|string|max:20',
            'adresse' => 'nullable|string',
        ]);

        $client->update($request->all());

        return response()->json($client);
    }

    public function destroy(Client $client)
    {
        if ($client->user_id !== auth()->id()) {
            return response()->json(['message' => 'Non autorisé'], 403);
        }

        $client->delete();

        return response()->json(['message' => 'Client supprimé avec succès']);
    }
}
```

### Ajouter les routes dans `routes/api.php`

```php
Route::middleware('auth:sanctum')->group(function () {
    // Auth routes
    Route::prefix('auth')->group(function () {
        Route::get('/me', [AuthController::class, 'me']);
        Route::post('/logout', [AuthController::class, 'logout']);
    });

    // Resource routes
    Route::apiResource('clients', ClientController::class);
    Route::apiResource('mesures', MesureController::class);
    Route::apiResource('commandes', CommandeController::class);
});
```

---

## Commandes utiles

```bash
# Créer un nouveau contrôleur
php artisan make:controller NomController

# Créer un nouveau modèle
php artisan make:model NomModele

# Créer un modèle avec migration
php artisan make:model NomModele -m

# Créer un modèle avec contrôleur et migration
php artisan make:model NomModele -mcr

# Réinitialiser la base de données
php artisan migrate:fresh

# Réinitialiser et lancer les seeders
php artisan migrate:fresh --seed

# Vider le cache
php artisan cache:clear
php artisan config:clear
php artisan route:clear

# Voir toutes les routes
php artisan route:list
```

---

## Prochaines étapes

1. **Tester l'authentification** depuis votre application Flutter
2. **Créer les modèles** Flutter pour Client, Mesure, Commande
3. **Créer les services** Flutter correspondants
4. **Développer les écrans** de votre application
5. **Ajouter la validation** et la gestion des erreurs
6. **Implémenter la pagination** pour les listes
7. **Ajouter des images** (upload de photos de vêtements)
8. **Déployer** en production

---

## Ressources

- [Documentation Laravel](https://laravel.com/docs)
- [Documentation Sanctum](https://laravel.com/docs/sanctum)
- [Documentation Flutter HTTP](https://pub.dev/packages/http)
- [Postman](https://www.postman.com/) pour tester l'API