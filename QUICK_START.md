# Démarrage rapide - Mon Tailleur

Guide rapide pour démarrer le développement de l'application Mon Tailleur.

## Prérequis

- ✅ PHP 8.1 ou supérieur
- ✅ Composer
- ✅ MySQL ou PostgreSQL
- ✅ Flutter SDK
- ✅ Un éditeur de code (VS Code recommandé)

---

## Étape 1 : Créer l'API Laravel (15 minutes)

### 1.1 Créer le projet Laravel

```bash
cd C:\Users\aaron\StudioProjects
composer create-project laravel/laravel mon_tailleur_api
cd mon_tailleur_api
```

### 1.2 Installer Sanctum

```bash
composer require laravel/sanctum
php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"
```

### 1.3 Configurer la base de données

Créez une base de données MySQL nommée `mon_tailleur`, puis éditez `.env` :

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=mon_tailleur
DB_USERNAME=root
DB_PASSWORD=votre_mot_de_passe
```

### 1.4 Copier les fichiers fournis

Copiez les fichiers suivants depuis le dossier `laravel_files/` du projet Flutter vers votre projet Laravel :

- `app/Http/Controllers/Api/AuthController.php`
- `routes/api.php`
- `app/Http/Kernel.php` (modifier uniquement la partie api middleware)
- Fichiers de migration dans `database/migrations/`

### 1.5 Lancer les migrations

```bash
php artisan migrate
```

### 1.6 Démarrer le serveur

```bash
php artisan serve
```

L'API est maintenant disponible sur `http://localhost:8000`

---

## Étape 2 : Configurer Flutter (5 minutes)

### 2.1 Installer les dépendances

```bash
cd C:\Users\aaron\StudioProjects\mon_tailleur
flutter pub get
```

### 2.2 Vérifier le fichier .env

Le fichier `.env` doit contenir :

```env
API_BASE_URL=http://localhost:8000/api
```

### 2.3 Tester l'application

```bash
flutter run
```

---

## Étape 3 : Premier test (5 minutes)

### 3.1 Créer un utilisateur de test

**Depuis l'application Flutter :**

1. Créez un écran de test ou utilisez Postman
2. Appelez l'endpoint d'inscription

**Ou depuis Postman/cURL :**

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

### 3.2 Tester la connexion depuis Flutter

Modifiez temporairement `lib/main.dart` pour tester :

```dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon Tailleur',
      home: TestAuthScreen(),
    );
  }
}

class TestAuthScreen extends StatefulWidget {
  @override
  State<TestAuthScreen> createState() => _TestAuthScreenState();
}

class _TestAuthScreenState extends State<TestAuthScreen> {
  final authService = AuthService();
  String result = 'Pas encore testé';

  Future<void> testLogin() async {
    try {
      final user = await authService.login('test@example.com', 'password123');
      setState(() {
        result = 'Connexion réussie: ${user.name}';
      });
    } catch (e) {
      setState(() {
        result = 'Erreur: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test API')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(result),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: testLogin,
              child: Text('Tester la connexion'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Étape 4 : Développement

### 4.1 Structure de développement recommandée

```
mon_tailleur/
├── lib/
│   ├── config/          # Configuration
│   ├── models/          # Modèles de données
│   ├── services/        # Services API
│   ├── screens/         # Écrans de l'application
│   │   ├── auth/        # Écrans d'authentification
│   │   ├── clients/     # Écrans de gestion des clients
│   │   ├── mesures/     # Écrans de prise de mesures
│   │   └── commandes/   # Écrans de commandes
│   ├── widgets/         # Widgets réutilisables
│   └── main.dart
```

### 4.2 Prochains écrans à créer

1. **Écrans d'authentification**
   - `screens/auth/login_screen.dart`
   - `screens/auth/register_screen.dart`

2. **Écran d'accueil**
   - `screens/home_screen.dart`

3. **Gestion des clients**
   - `screens/clients/clients_list_screen.dart`
   - `screens/clients/client_detail_screen.dart`
   - `screens/clients/add_client_screen.dart`

4. **Gestion des mesures**
   - `screens/mesures/add_mesure_screen.dart`
   - `screens/mesures/mesure_detail_screen.dart`

5. **Gestion des commandes**
   - `screens/commandes/commandes_list_screen.dart`
   - `screens/commandes/add_commande_screen.dart`
   - `screens/commandes/commande_detail_screen.dart`

### 4.3 Créer les modèles Flutter

Créez les modèles pour Client, Mesure, Commande dans `lib/models/` :

```bash
# Créer les fichiers manuellement ou utilisez votre IDE
```

**Exemple : `lib/models/client.dart`**

```dart
class Client {
  final int id;
  final int userId;
  final String nom;
  final String prenom;
  final String telephone;
  final String? adresse;
  final DateTime createdAt;
  final DateTime updatedAt;

  Client({
    required this.id,
    required this.userId,
    required this.nom,
    required this.prenom,
    required this.telephone,
    this.adresse,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      userId: json['user_id'],
      nom: json['nom'],
      prenom: json['prenom'],
      telephone: json['telephone'],
      adresse: json['adresse'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'prenom': prenom,
      'telephone': telephone,
      'adresse': adresse,
    };
  }

  String get nomComplet => '$prenom $nom';
}
```

### 4.4 Créer les services Flutter

**Exemple : `lib/services/client_service.dart`**

```dart
import 'dart:convert';
import '../models/client.dart';
import 'http_service.dart';

class ClientService {
  final HttpService _httpService = HttpService();

  Future<List<Client>> getClients() async {
    final response = await _httpService.get('/clients');
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Client.fromJson(json)).toList();
  }

  Future<Client> getClient(int id) async {
    final response = await _httpService.get('/clients/$id');
    final data = jsonDecode(response.body);
    return Client.fromJson(data);
  }

  Future<Client> createClient(Map<String, dynamic> clientData) async {
    final response = await _httpService.post('/clients', clientData);
    final data = jsonDecode(response.body);
    return Client.fromJson(data);
  }

  Future<Client> updateClient(int id, Map<String, dynamic> clientData) async {
    final response = await _httpService.put('/clients/$id', clientData);
    final data = jsonDecode(response.body);
    return Client.fromJson(data);
  }

  Future<void> deleteClient(int id) async {
    await _httpService.delete('/clients/$id');
  }
}
```

---

## Étape 5 : Outils de développement

### Outils recommandés

1. **Postman** - Tester l'API Laravel
   - Télécharger : https://www.postman.com/downloads/

2. **VS Code Extensions**
   - Flutter
   - Dart
   - Laravel Extension Pack
   - REST Client

3. **Flutter DevTools**
   ```bash
   flutter pub global activate devtools
   flutter pub global run devtools
   ```

### Commandes utiles

**Laravel :**
```bash
# Voir les routes
php artisan route:list

# Créer un contrôleur
php artisan make:controller Api/NomController --api

# Créer un modèle avec migration
php artisan make:model NomModele -m

# Rafraîchir la base de données
php artisan migrate:fresh
```

**Flutter :**
```bash
# Lancer l'application
flutter run

# Hot reload
r (dans le terminal)

# Hot restart
R (dans le terminal)

# Analyser le code
flutter analyze

# Formater le code
flutter format lib/
```

---

## Résolution des problèmes courants

### Problème : "Connection refused" sur Android

**Solution :** Utilisez `http://10.0.2.2:8000/api` au lieu de `localhost` dans votre `.env`

```env
API_BASE_URL=http://10.0.2.2:8000/api
```

### Problème : Erreur CORS

**Solution :** Vérifiez `config/cors.php` dans Laravel :

```php
'allowed_origins' => ['*'],
```

### Problème : Token non reconnu

**Solution :** Vérifiez que le middleware Sanctum est bien configuré dans `app/Http/Kernel.php`

### Problème : Migrations échouent

**Solution :**
```bash
php artisan migrate:fresh
```

---

## Checklist de démarrage

- [ ] Laravel installé et configuré
- [ ] Base de données créée et migrations exécutées
- [ ] Sanctum installé et configuré
- [ ] Serveur Laravel démarré (`php artisan serve`)
- [ ] Dépendances Flutter installées (`flutter pub get`)
- [ ] Fichier `.env` configuré avec l'URL de l'API
- [ ] Test d'authentification réussi
- [ ] Premier utilisateur créé

---

## Prochaines étapes

1. ✅ Configuration terminée
2. 🔄 Créer les écrans d'authentification
3. ⏳ Créer les modèles et services pour Client, Mesure, Commande
4. ⏳ Développer les écrans de gestion
5. ⏳ Ajouter la navigation
6. ⏳ Implémenter la gestion d'état (Provider, Bloc, ou Riverpod)
7. ⏳ Ajouter les fonctionnalités avancées
8. ⏳ Tests et déploiement

---

## Ressources

- [LARAVEL_SETUP.md](./LARAVEL_SETUP.md) - Guide complet de configuration Laravel
- [BACKEND.md](./BACKEND.md) - Documentation de l'API
- [Documentation Flutter](https://docs.flutter.dev/)
- [Documentation Laravel](https://laravel.com/docs)

**Bon développement ! 🚀**