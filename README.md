# Mon Tailleur

Application mobile de gestion de tailleur développée avec Flutter et Laravel.

## Description

Mon Tailleur est une application mobile permettant aux tailleurs de gérer leurs clients, prendre des mesures et suivre les commandes de vêtements.

## Architecture

- **Frontend** : Flutter (application mobile multi-plateformes)
- **Backend** : Laravel (API REST)
- **Base de données** : MySQL
- **Authentification** : Laravel Sanctum (Bearer Token)

## Fonctionnalités

- Authentification (inscription, connexion, déconnexion)
- Gestion des clients
- Prise de mesures personnalisées
- Gestion des commandes
- Suivi du statut des commandes
- Historique des commandes

## Documentation

### Guides de démarrage

1. **[QUICK_START.md](QUICK_START.md)** - Guide de démarrage rapide (25 minutes)
   - Installation du backend Laravel
   - Configuration de Flutter
   - Premier test de l'API

2. **[LARAVEL_SETUP.md](LARAVEL_SETUP.md)** - Guide complet de configuration Laravel
   - Installation détaillée
   - Configuration de la base de données
   - Création des migrations
   - Configuration de l'authentification
   - Tests de l'API

3. **[BACKEND.md](BACKEND.md)** - Documentation de l'API
   - Utilisation des services
   - Endpoints disponibles
   - Exemples de code
   - Gestion des erreurs

### Fichiers prêts à l'emploi

Le dossier `laravel_files/` contient tous les fichiers Laravel prêts à copier :
- Contrôleur d'authentification
- Modèles (Client, Mesure, Commande)
- Migrations
- Routes API

Voir [laravel_files/README.md](laravel_files/README.md) pour les instructions.

## Structure du projet

```
mon_tailleur/
├── lib/
│   ├── config/
│   │   └── api_config.dart       # Configuration de l'API
│   ├── models/
│   │   └── user.dart             # Modèle utilisateur
│   ├── services/
│   │   ├── http_service.dart     # Service HTTP de base
│   │   └── auth_service.dart     # Service d'authentification
│   └── main.dart
├── laravel_files/                # Fichiers Laravel prêts à l'emploi
├── .env                          # Configuration (ignoré par Git)
├── .env.example                  # Exemple de configuration
├── QUICK_START.md                # Guide de démarrage rapide
├── LARAVEL_SETUP.md              # Guide complet Laravel
└── BACKEND.md                    # Documentation API

```

## Installation rapide

### 1. Backend Laravel

```bash
# Créer le projet Laravel
cd C:\Users\aaron\StudioProjects
composer create-project laravel/laravel mon_tailleur_api

# Installer Sanctum
cd mon_tailleur_api
composer require laravel/sanctum
php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"

# Copier les fichiers depuis laravel_files/
# Configurer .env et créer la base de données

# Lancer les migrations
php artisan migrate

# Démarrer le serveur
php artisan serve
```

### 2. Application Flutter

```bash
# Installer les dépendances
cd C:\Users\aaron\StudioProjects\mon_tailleur
flutter pub get

# Lancer l'application
flutter run
```

## Configuration

### Fichier .env

Créez un fichier `.env` à la racine du projet Flutter :

```env
API_BASE_URL=http://localhost:8000/api
```

Pour Android Emulator, utilisez :
```env
API_BASE_URL=http://10.0.2.2:8000/api
```

### Backend Laravel

Configurez votre fichier `.env` dans le projet Laravel :

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=mon_tailleur
DB_USERNAME=root
DB_PASSWORD=votre_mot_de_passe
```

## Utilisation

### Authentification

```dart
import 'package:mon_tailleur/services/auth_service.dart';

final authService = AuthService();

// Inscription
final user = await authService.register(
  name: 'John Doe',
  email: 'john@example.com',
  password: 'password123',
  passwordConfirmation: 'password123',
);

// Connexion
final user = await authService.login('john@example.com', 'password123');

// Déconnexion
await authService.logout();
```

## État du projet

1. ✅ Configuration initiale terminée
2. ✅ Écrans d'authentification créés (Login, Register)
3. ✅ Écran d'accueil avec menu principal
4. ✅ Gestion de session et persistance
5. ⏳ Créer les modèles et services pour Client, Mesure, Commande
6. ⏳ Développer les écrans de gestion
7. ⏳ Implémenter la gestion d'état (Provider, Bloc, ou Riverpod)
8. ⏳ Tests et déploiement

## Dépendances

### Flutter
- `http: ^1.2.0` - Client HTTP
- `shared_preferences: ^2.2.2` - Stockage local
- `flutter_dotenv: ^5.1.0` - Variables d'environnement

### Laravel
- `laravel/sanctum` - Authentification API

## Commandes utiles

### Flutter
```bash
flutter run                 # Lancer l'application
flutter analyze             # Analyser le code
flutter test                # Lancer les tests
flutter build apk           # Build Android
```

### Laravel
```bash
php artisan serve           # Démarrer le serveur
php artisan migrate         # Lancer les migrations
php artisan route:list      # Voir les routes
php artisan make:controller # Créer un contrôleur
```

## Ressources

- [Documentation Flutter](https://docs.flutter.dev/)
- [Documentation Laravel](https://laravel.com/docs)
- [Documentation Sanctum](https://laravel.com/docs/sanctum)
- [Pub.dev - Packages Flutter](https://pub.dev/)

## Support

Pour toute question ou problème, consultez :
- Les fichiers de documentation dans ce projet
- [Issues GitHub](https://github.com/votre-repo/issues) (si applicable)

## Licence

Ce projet est sous licence MIT.
