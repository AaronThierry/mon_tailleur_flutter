# Tester l'Application Mon Tailleur

Votre application est maintenant prête à être testée! 🎉

## Ce qui a été créé

✅ **Écrans d'authentification**
- Écran de connexion avec validation
- Écran d'inscription avec validation des mots de passe
- Gestion des erreurs

✅ **Écran d'accueil**
- Affichage des informations de l'utilisateur
- Menu principal avec 4 sections
- Déconnexion fonctionnelle

✅ **Fonctionnalités**
- Persistance de la session (l'utilisateur reste connecté)
- Splash screen au démarrage
- Navigation fluide entre les écrans

---

## Lancer l'application

### 1. Vérifier que l'API Laravel fonctionne

```bash
# Dans le dossier mon_tailleur_api
php artisan serve
```

L'API doit être accessible sur `http://localhost:8000`

### 2. Lancer l'application Flutter

```bash
# Dans le dossier mon_tailleur
flutter run
```

**Note:** Si vous testez sur un émulateur Android, modifiez le fichier `.env` :

```env
API_BASE_URL=http://10.0.2.2:8000/api
```

---

## Scénarios de test

### Test 1 : Inscription



1. Lancez l'application
2. Cliquez sur "S'inscrire"
3. Remplissez le formulaire :
   - Nom : Votre nom
   - 
   - Email : test2@example.com
   - Mot de passe : password123
   - Confirmer : password123
4. Cliquez sur "S'inscrire"

**Résultat attendu :** Vous êtes redirigé vers l'écran d'accueil avec votre nom affiché

### Test 2 : Déconnexion

1. Sur l'écran d'accueil, cliquez sur l'icône de déconnexion (en haut à droite)
2. Confirmez la déconnexion

**Résultat attendu :** Vous êtes redirigé vers l'écran de connexion

### Test 3 : Connexion

1. Sur l'écran de connexion, entrez :
   - Email : aaron@test.com (ou l'email que vous avez utilisé)
   - Mot de passe : password123
2. Cliquez sur "Se connecter"

**Résultat attendu :** Vous êtes redirigé vers l'écran d'accueil

### Test 4 : Persistance de session

1. Connectez-vous à l'application
2. Fermez complètement l'application (arrêtez-la)
3. Relancez l'application

**Résultat attendu :** Vous êtes automatiquement connecté et redirigé vers l'écran d'accueil

### Test 5 : Validation des formulaires

1. Sur l'écran de connexion, essayez de vous connecter sans remplir les champs
2. Essayez avec un email invalide (sans @)
3. Sur l'écran d'inscription, essayez avec des mots de passe différents

**Résultat attendu :** Messages d'erreur appropriés

### Test 6 : Gestion des erreurs

1. Arrêtez le serveur Laravel (`php artisan serve`)
2. Essayez de vous connecter

**Résultat attendu :** Message d'erreur de connexion affiché

---

## Captures d'écran de l'application

### Écran de connexion
- Logo Mon Tailleur
- Champs Email et Mot de passe
- Bouton "Se connecter"
- Lien vers l'inscription

### Écran d'inscription
- Champs Nom, Email, Mot de passe, Confirmation
- Validation en temps réel
- Bouton "S'inscrire"
- Lien vers la connexion

### Écran d'accueil
- Avatar avec initiale de l'utilisateur
- Nom et email de l'utilisateur
- Menu avec 4 sections :
  - Mes Clients
  - Mesures
  - Commandes
  - Paramètres
- Bouton de déconnexion

---

## Problèmes courants

### L'application ne se connecte pas à l'API

**Solution 1 - Vérifier l'URL dans .env**

Sur émulateur Android :
```env
API_BASE_URL=http://10.0.2.2:8000/api
```

Sur appareil physique ou iOS Simulator :
```env
API_BASE_URL=http://VOTRE_IP_LOCALE:8000/api
```

Pour trouver votre IP locale :
```bash
# Windows
ipconfig

# Mac/Linux
ifconfig
```

**Solution 2 - Vérifier que le serveur Laravel fonctionne**

```bash
php artisan serve
```

**Solution 3 - Vérifier les logs**

Dans le terminal où Flutter tourne, vous verrez les erreurs de connexion.

### Erreur "Session expirée"

1. Déconnectez-vous
2. Reconnectez-vous

Cela générera un nouveau token.

### L'application ne démarre pas

```bash
# Nettoyer et reconstruire
flutter clean
flutter pub get
flutter run
```

---

## Tester avec différents utilisateurs

Vous pouvez créer plusieurs comptes pour tester :

1. **Utilisateur 1** : aaron@test.com (déjà créé)
2. **Utilisateur 2** : Créez-en un nouveau via l'inscription
3. **Utilisateur 3** : Un autre via l'inscription

Chaque utilisateur aura sa propre session indépendante.

---

## Prochaines étapes de développement

Maintenant que l'authentification fonctionne, vous pouvez :

1. **Créer les modèles Flutter** pour Client, Mesure, Commande
2. **Créer les services** correspondants
3. **Développer les écrans de gestion** :
   - Liste des clients
   - Ajout/modification de client
   - Prise de mesures
   - Gestion des commandes

4. **Ajouter des fonctionnalités** :
   - Recherche de clients
   - Filtres sur les commandes
   - Export PDF des mesures
   - Notifications

---

## Commandes utiles

### Flutter
```bash
flutter run                 # Lancer l'application
flutter run -d chrome       # Lancer sur Chrome (web)
flutter run -d android      # Lancer sur Android
flutter run -d ios          # Lancer sur iOS
flutter clean               # Nettoyer le build
flutter pub get             # Installer les dépendances
```

### Laravel
```bash
php artisan serve           # Démarrer le serveur
php artisan route:list      # Voir toutes les routes
php artisan tinker          # Console interactive
php artisan migrate:fresh   # Réinitialiser la base de données
```

---

## Débogage

### Voir les requêtes HTTP

Pour déboguer les requêtes, vous pouvez ajouter des prints dans `lib/services/http_service.dart` :

```dart
Future<http.Response> get(String endpoint) async {
  final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
  print('GET $url'); // Ajoutez cette ligne

  final response = await http.get(url, headers: await _getHeaders());
  print('Response: ${response.statusCode} - ${response.body}'); // Et celle-ci

  return _handleResponse(response);
}
```

### Voir les données utilisateur

Dans la console Flutter, les erreurs et les logs s'affichent automatiquement.

---

## Support

Si vous rencontrez des problèmes :

1. Vérifiez que l'API Laravel fonctionne (testez avec Postman)
2. Vérifiez l'URL dans le fichier `.env`
3. Consultez les logs dans le terminal Flutter
4. Vérifiez les logs Laravel dans `storage/logs/laravel.log`

---

**Félicitations! Votre application Mon Tailleur est opérationnelle! 🎉**

Vous pouvez maintenant :
- Créer des comptes
- Se connecter/déconnecter
- Session persistante

La base est solide pour continuer le développement des autres fonctionnalités!