# Fichiers Laravel prêts à l'emploi

Ce dossier contient tous les fichiers Laravel dont vous avez besoin pour démarrer rapidement votre API.

## Contenu

### 📁 app/Http/Controllers/Api/
- `AuthController.php` - Contrôleur d'authentification complet (login, register, logout, me)

### 📁 app/Models/
- `Client.php` - Modèle Client avec relations
- `Mesure.php` - Modèle Mesure avec relations
- `Commande.php` - Modèle Commande avec relations et génération de numéro

### 📁 database/migrations/
- `2024_01_01_000001_create_clients_table.php` - Table des clients
- `2024_01_01_000002_create_mesures_table.php` - Table des mesures
- `2024_01_01_000003_create_commandes_table.php` - Table des commandes

### 📁 routes/
- `api.php` - Routes API configurées

## Installation

### 1. Créer votre projet Laravel

```bash
cd C:\Users\aaron\StudioProjects
composer create-project laravel/laravel mon_tailleur_api
cd mon_tailleur_api
```

### 2. Installer Laravel Sanctum

```bash
composer require laravel/sanctum
php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"
```

### 3. Copier les fichiers

Copiez tous les fichiers de ce dossier vers votre projet Laravel en respectant la structure :

**Windows (PowerShell) :**
```powershell
# Depuis le dossier mon_tailleur
Copy-Item -Path "laravel_files\app\*" -Destination "..\mon_tailleur_api\app\" -Recurse -Force
Copy-Item -Path "laravel_files\database\*" -Destination "..\mon_tailleur_api\database\" -Recurse -Force
Copy-Item -Path "laravel_files\routes\api.php" -Destination "..\mon_tailleur_api\routes\api.php" -Force
```

**Ou manuellement :**
- Copiez `app/Http/Controllers/Api/AuthController.php` vers `mon_tailleur_api/app/Http/Controllers/Api/`
- Copiez les modèles vers `mon_tailleur_api/app/Models/`
- Copiez les migrations vers `mon_tailleur_api/database/migrations/`
- Remplacez `routes/api.php`

### 4. Modifier app/Models/User.php

Ajoutez le trait `HasApiTokens` :

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

    // ... reste du code
}
```

### 5. Modifier app/Http/Kernel.php

Dans le tableau `$middlewareGroups`, ajoutez Sanctum au groupe `api` :

```php
'api' => [
    \Laravel\Sanctum\Http\Middleware\EnsureFrontendRequestsAreStateful::class,
    \Illuminate\Routing\Middleware\ThrottleRequests::class.':api',
    \Illuminate\Routing\Middleware\SubstituteBindings::class,
],
```

### 6. Configurer .env

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

### 7. Créer la base de données

```bash
mysql -u root -p
```

```sql
CREATE DATABASE mon_tailleur CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
EXIT;
```

### 8. Exécuter les migrations

```bash
php artisan migrate
```

### 9. Configurer CORS (config/cors.php)

```php
return [
    'paths' => ['api/*', 'sanctum/csrf-cookie'],
    'allowed_methods' => ['*'],
    'allowed_origins' => ['*'],
    'allowed_headers' => ['*'],
    'exposed_headers' => [],
    'max_age' => 0,
    'supports_credentials' => false,
];
```

### 10. Démarrer le serveur

```bash
php artisan serve
```

## Routes disponibles

### Routes publiques
- `POST /api/auth/register` - Inscription
- `POST /api/auth/login` - Connexion

### Routes protégées (Bearer Token requis)
- `GET /api/auth/me` - Utilisateur connecté
- `POST /api/auth/logout` - Déconnexion

## Modèles de base de données

### User (fourni par Laravel)
- id
- name
- email
- password
- email_verified_at
- timestamps

### Client
- id
- user_id (foreign key vers users)
- nom
- prenom
- telephone
- adresse (nullable)
- timestamps

### Mesure
- id
- client_id (foreign key vers clients)
- type_vetement
- longueur
- largeur_epaule
- tour_poitrine
- tour_taille
- tour_hanche
- longueur_manche
- tour_cou
- autres_mesures (JSON)
- timestamps

### Commande
- id
- client_id (foreign key vers clients)
- user_id (foreign key vers users)
- numero_commande (unique)
- type_vetement
- description
- prix
- date_prise
- date_livraison_prevue
- statut (en_attente, en_cours, termine, livre, annule)
- timestamps

## Prochaines étapes

Après avoir copié et configuré ces fichiers :

1. Testez l'authentification avec Postman
2. Créez les contrôleurs pour Client, Mesure, Commande
3. Ajoutez les routes correspondantes
4. Testez depuis votre application Flutter

## Créer les contrôleurs manquants

```bash
# Dans le dossier mon_tailleur_api
php artisan make:controller Api/ClientController --api
php artisan make:controller Api/MesureController --api
php artisan make:controller Api/CommandeController --api
```

Puis ajoutez les routes dans `routes/api.php` :

```php
Route::middleware('auth:sanctum')->group(function () {
    // ... auth routes

    Route::apiResource('clients', ClientController::class);
    Route::apiResource('mesures', MesureController::class);
    Route::apiResource('commandes', CommandeController::class);
});
```

## Aide

Consultez les fichiers suivants pour plus d'informations :
- `LARAVEL_SETUP.md` - Guide complet de configuration
- `QUICK_START.md` - Guide de démarrage rapide
- `BACKEND.md` - Documentation de l'API

Bon développement ! 🚀