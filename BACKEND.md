# Configuration du Backend Laravel

Ce document explique comment configurer et utiliser le backend Laravel avec cette application Flutter.

## Structure du projet

```
lib/
├── config/
│   └── api_config.dart        # Configuration de l'API
├── models/
│   └── user.dart              # Modèle utilisateur
├── services/
│   ├── http_service.dart      # Service HTTP de base
│   └── auth_service.dart      # Service d'authentification
└── main.dart                  # Point d'entrée de l'application
```

## Configuration

### 1. Fichier .env

Le fichier `.env` à la racine du projet contient l'URL de votre backend Laravel :

```env
API_BASE_URL=http://localhost:8000/api
```

Pour un environnement de production, modifiez cette URL pour pointer vers votre serveur :

```env
API_BASE_URL=https://votre-api.com/api
```

### 2. Configuration du backend Laravel

Votre backend Laravel doit avoir les endpoints suivants :

#### Authentification

- **POST** `/api/auth/login` - Connexion
  - Body: `{ "email": "user@example.com", "password": "password" }`
  - Réponse: `{ "token": "...", "user": {...} }`

- **POST** `/api/auth/register` - Inscription
  - Body: `{ "name": "...", "email": "...", "password": "...", "password_confirmation": "..." }`
  - Réponse: `{ "token": "...", "user": {...} }`

- **GET** `/api/auth/me` - Récupérer l'utilisateur connecté (nécessite authentification)
  - Headers: `Authorization: Bearer {token}`
  - Réponse: `{ "id": 1, "name": "...", "email": "...", ... }`

- **POST** `/api/auth/logout` - Déconnexion (nécessite authentification)
  - Headers: `Authorization: Bearer {token}`

### 3. Exemple de routes Laravel (routes/api.php)

```php
use App\Http\Controllers\AuthController;

Route::prefix('auth')->group(function () {
    Route::post('/login', [AuthController::class, 'login']);
    Route::post('/register', [AuthController::class, 'register']);

    Route::middleware('auth:sanctum')->group(function () {
        Route::get('/me', [AuthController::class, 'me']);
        Route::post('/logout', [AuthController::class, 'logout']);
    });
});
```

### 4. Configuration CORS

Dans votre backend Laravel, assurez-vous que CORS est configuré pour accepter les requêtes de votre application Flutter.

Fichier `config/cors.php` :

```php
return [
    'paths' => ['api/*'],
    'allowed_methods' => ['*'],
    'allowed_origins' => ['*'], // En production, spécifiez les origines autorisées
    'allowed_headers' => ['*'],
    'exposed_headers' => [],
    'max_age' => 0,
    'supports_credentials' => false,
];
```

## Utilisation

### 1. Connexion

```dart
import 'package:mon_tailleur/services/auth_service.dart';

final authService = AuthService();

try {
  final user = await authService.login('user@example.com', 'password');
  print('Connecté: ${user.name}');
} catch (e) {
  print('Erreur: $e');
}
```

### 2. Inscription

```dart
try {
  final user = await authService.register(
    name: 'John Doe',
    email: 'john@example.com',
    password: 'password123',
    passwordConfirmation: 'password123',
  );
  print('Inscrit: ${user.name}');
} catch (e) {
  print('Erreur: $e');
}
```

### 3. Récupérer l'utilisateur connecté

```dart
try {
  final user = await authService.getCurrentUser();
  print('Utilisateur: ${user.name}');
} catch (e) {
  print('Erreur: $e');
}
```

### 4. Déconnexion

```dart
try {
  await authService.logout();
  print('Déconnecté');
} catch (e) {
  print('Erreur: $e');
}
```

### 5. Vérifier si l'utilisateur est connecté

```dart
final isLoggedIn = await authService.isLoggedIn();
if (isLoggedIn) {
  print('Utilisateur connecté');
} else {
  print('Utilisateur non connecté');
}
```

## Créer de nouveaux endpoints

### 1. Créer un modèle

Créez un nouveau fichier dans `lib/models/` :

```dart
class Product {
  final int id;
  final String name;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }
}
```

### 2. Créer un service

Créez un nouveau fichier dans `lib/services/` :

```dart
import 'dart:convert';
import '../models/product.dart';
import 'http_service.dart';

class ProductService {
  final HttpService _httpService = HttpService();

  Future<List<Product>> getProducts() async {
    final response = await _httpService.get('/products');
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Product.fromJson(json)).toList();
  }

  Future<Product> getProduct(int id) async {
    final response = await _httpService.get('/products/$id');
    final data = jsonDecode(response.body);
    return Product.fromJson(data);
  }

  Future<Product> createProduct(Map<String, dynamic> productData) async {
    final response = await _httpService.post('/products', productData);
    final data = jsonDecode(response.body);
    return Product.fromJson(data);
  }

  Future<Product> updateProduct(int id, Map<String, dynamic> productData) async {
    final response = await _httpService.put('/products/$id', productData);
    final data = jsonDecode(response.body);
    return Product.fromJson(data);
  }

  Future<void> deleteProduct(int id) async {
    await _httpService.delete('/products/$id');
  }
}
```

## Gestion des erreurs

Le `HttpService` gère automatiquement les erreurs HTTP courantes :

- **401 Unauthorized**: Le token est expiré ou invalide (suppression automatique du token)
- **403 Forbidden**: Accès refusé
- **404 Not Found**: Ressource non trouvée
- **500+ Server Error**: Erreur serveur

Toutes les erreurs sont levées sous forme d'`Exception` avec un message descriptif.

## Tests

Pour tester votre configuration, vous pouvez utiliser un émulateur Android ou un appareil physique. Si vous utilisez `localhost` sur un émulateur Android, utilisez `http://10.0.2.2:8000/api` au lieu de `http://localhost:8000/api`.

Pour iOS Simulator, `localhost` devrait fonctionner correctement.

## Sécurité

- Le fichier `.env` est automatiquement ignoré par Git
- Les tokens sont stockés de manière sécurisée avec `shared_preferences`
- Toutes les requêtes utilisent HTTPS en production
- Les erreurs ne révèlent pas d'informations sensibles

## Débogage

Pour voir les requêtes HTTP dans la console, vous pouvez ajouter des logs dans le `HttpService` :

```dart
Future<http.Response> get(String endpoint) async {
  final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
  print('GET $url'); // Ajoutez cette ligne

  final response = await http.get(url, headers: await _getHeaders());
  print('Response: ${response.statusCode}'); // Ajoutez cette ligne

  return _handleResponse(response);
}
```