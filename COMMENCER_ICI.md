# 🚀 COMMENCEZ ICI - Mon Tailleur

Bienvenue! Ce guide vous permet de démarrer en 3 étapes simples.

---

## ✅ Ce qui est déjà fait

Votre projet Flutter est **déjà configuré** avec :

- ✅ Configuration HTTP pour communiquer avec Laravel
- ✅ Service d'authentification complet (login, register, logout)
- ✅ Gestion automatique des tokens
- ✅ Modèle User prêt à l'emploi
- ✅ Fichiers Laravel prêts à copier dans `laravel_files/`

---

## 🎯 3 étapes pour commencer

### Étape 1 : Créer l'API Laravel (15 min)

```bash
# 1. Créer le projet Laravel
cd C:\Users\aaron\StudioProjects
composer create-project laravel/laravel mon_tailleur_api
cd mon_tailleur_api

# 2. Installer Sanctum
composer require laravel/sanctum
php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"

# 3. Créer la base de données MySQL nommée 'mon_tailleur'
# Via MySQL :
mysql -u root -p
CREATE DATABASE mon_tailleur CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
EXIT;

# 4. Configurer .env
# Éditer le fichier .env et mettre à jour :
# DB_DATABASE=mon_tailleur
# DB_USERNAME=root
# DB_PASSWORD=votre_mot_de_passe
```

**Copier les fichiers fournis :**

Copiez tous les fichiers du dossier `C:\Users\aaron\StudioProjects\mon_tailleur\laravel_files\` vers votre projet Laravel :

- `app/Http/Controllers/Api/AuthController.php`
- `app/Models/Client.php`, `Mesure.php`, `Commande.php`
- `database/migrations/*.php`
- `routes/api.php`

**Modifier `app/Models/User.php` :**

```php
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;
    // ... reste du code
}
```

**Modifier `app/Http/Kernel.php` :**

Dans le groupe `'api'` :

```php
'api' => [
    \Laravel\Sanctum\Http\Middleware\EnsureFrontendRequestsAreStateful::class,
    \Illuminate\Routing\Middleware\ThrottleRequests::class.':api',
    \Illuminate\Routing\Middleware\SubstituteBindings::class,
],
```

```bash
# 5. Lancer les migrations
php artisan migrate

# 6. Démarrer le serveur
php artisan serve
```

L'API est maintenant disponible sur **http://localhost:8000** ✅

---

### Étape 2 : Tester l'API (5 min)

**Option A : Avec Postman**

1. Ouvrir Postman
2. Créer une requête POST vers `http://localhost:8000/api/auth/register`
3. Body (JSON) :
```json
{
  "name": "Test User",
  "email": "test@example.com",
  "password": "password123",
  "password_confirmation": "password123"
}
```
4. Envoyer la requête
5. Vous devriez recevoir un token ✅

**Option B : Avec cURL**

```bash
curl -X POST http://localhost:8000/api/auth/register \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"Test User\",\"email\":\"test@example.com\",\"password\":\"password123\",\"password_confirmation\":\"password123\"}"
```

---

### Étape 3 : Lancer l'app Flutter (2 min)

```bash
# 1. Aller dans le dossier Flutter
cd C:\Users\aaron\StudioProjects\mon_tailleur

# 2. Les dépendances sont déjà installées, mais si besoin :
flutter pub get

# 3. Lancer l'application
flutter run
```

---

## 🎉 Félicitations !

Votre environnement de développement est prêt!

### Prochaines étapes

1. **Créer les écrans d'authentification**
   - Écran de connexion
   - Écran d'inscription
   - Écran d'accueil

2. **Développer les fonctionnalités**
   - Gestion des clients
   - Prise de mesures
   - Gestion des commandes

---

## 📚 Documentation disponible

| Fichier | Description |
|---------|-------------|
| [QUICK_START.md](QUICK_START.md) | Guide de démarrage rapide détaillé |
| [LARAVEL_SETUP.md](LARAVEL_SETUP.md) | Configuration complète de Laravel |
| [BACKEND.md](BACKEND.md) | Documentation de l'API |
| [laravel_files/README.md](laravel_files/README.md) | Instructions pour les fichiers Laravel |

---

## 🆘 Problèmes courants

### L'API ne répond pas
- Vérifiez que le serveur Laravel est démarré (`php artisan serve`)
- Vérifiez l'URL dans le fichier `.env` de Flutter

### Erreur de connexion sur Android
- Utilisez `http://10.0.2.2:8000/api` au lieu de `http://localhost:8000/api`

### Erreur CORS
- Vérifiez que `config/cors.php` dans Laravel autorise `'*'` pour `allowed_origins`

### Erreur de migration
- Vérifiez que la base de données `mon_tailleur` existe
- Vérifiez les identifiants dans `.env` de Laravel

---

## 💡 Commandes utiles

### Laravel
```bash
php artisan serve              # Démarrer le serveur
php artisan route:list         # Voir toutes les routes
php artisan migrate:fresh      # Réinitialiser la base de données
php artisan tinker            # Console interactive
```

### Flutter
```bash
flutter run                    # Lancer l'app
flutter clean                  # Nettoyer le build
flutter pub get                # Installer les dépendances
r                             # Hot reload (dans le terminal flutter run)
R                             # Hot restart (dans le terminal flutter run)
```

---

## 📞 Besoin d'aide ?

1. Consultez la documentation dans les fichiers MD
2. Vérifiez les logs du serveur Laravel
3. Utilisez `flutter doctor` pour vérifier votre installation Flutter

---

**Bon développement ! 🚀**

*Tout est prêt pour créer votre application de gestion de tailleur!*