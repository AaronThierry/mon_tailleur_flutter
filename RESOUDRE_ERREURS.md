# Résolution des erreurs courantes

## Erreur : MissingPluginException pour shared_preferences

### Symptôme
```
MissingPluginException(No implementation found for method getAll on channel plugins.flutter.io/shared_preferences)
```

### Cause
Les plugins natifs (comme shared_preferences) ne sont pas correctement installés ou l'application n'a pas été reconstruite après l'ajout de nouvelles dépendances.

### Solution

#### Étape 1 : Arrêter l'application
Appuyez sur `Ctrl+C` dans le terminal où l'application tourne.

#### Étape 2 : Nettoyer le projet
```bash
flutter clean
```

#### Étape 3 : Réinstaller les dépendances
```bash
flutter pub get
```

#### Étape 4 : Reconstruire et relancer
```bash
flutter run
```

### Solution alternative (si l'erreur persiste)

#### Pour Android :
```bash
# Nettoyer
flutter clean

# Aller dans le dossier Android
cd android

# Nettoyer le build Gradle
./gradlew clean

# Revenir à la racine
cd ..

# Réinstaller et relancer
flutter pub get
flutter run
```

#### Pour iOS (si vous développez sur Mac) :
```bash
# Nettoyer
flutter clean

# Aller dans le dossier iOS
cd ios

# Réinstaller les pods
pod deintegrate
pod install

# Revenir à la racine
cd ..

# Réinstaller et relancer
flutter pub get
flutter run
```

---

## Autres erreurs courantes

### Erreur : "Connection refused" ou "Failed to connect"

**Symptôme :** L'application ne peut pas se connecter à l'API Laravel.

**Solutions :**

1. **Vérifier que le serveur Laravel fonctionne**
   ```bash
   php artisan serve
   ```

2. **Vérifier l'URL dans .env**

   Pour émulateur Android :
   ```env
   API_BASE_URL=http://10.0.2.2:8000/api
   ```

   Pour appareil physique ou iOS :
   ```env
   API_BASE_URL=http://VOTRE_IP_LOCALE:8000/api
   ```

   Pour trouver votre IP :
   ```bash
   # Windows
   ipconfig

   # Mac/Linux
   ifconfig
   ```

3. **Redémarrer l'application après modification du .env**
   ```bash
   # Arrêter l'app (Ctrl+C)
   flutter run
   ```

### Erreur : "Invalid email or password"

**Cause :** Email ou mot de passe incorrect.

**Solution :** Vérifiez que vous utilisez les bons identifiants. Pour tester, créez un nouveau compte via l'inscription.

### Erreur : Build failed

**Solution :**
```bash
flutter clean
flutter pub get
flutter run
```

### Erreur : Package not found

**Solution :**
```bash
flutter pub get
```

---

## Commandes de dépannage

### Vérifier l'installation Flutter
```bash
flutter doctor
```

### Voir les appareils disponibles
```bash
flutter devices
```

### Analyser le code
```bash
flutter analyze
```

### Voir les logs détaillés
```bash
flutter run -v
```

---

## Problèmes spécifiques

### L'application se ferme immédiatement

1. Vérifiez les logs dans le terminal
2. Vérifiez que le fichier `.env` existe
3. Vérifiez que toutes les dépendances sont installées

### Hot reload ne fonctionne pas

Utilisez Hot Restart au lieu de Hot Reload :
- Appuyez sur `R` (majuscule) dans le terminal

### Erreur de certificat SSL

Si vous utilisez HTTPS et avez des erreurs de certificat, pour le développement vous pouvez temporairement désactiver la vérification (à ne pas faire en production).

---

## Vérifications avant de lancer l'application

- [ ] Le serveur Laravel est démarré (`php artisan serve`)
- [ ] Le fichier `.env` existe avec la bonne URL
- [ ] Les dépendances sont installées (`flutter pub get`)
- [ ] Le projet est nettoyé si nécessaire (`flutter clean`)
- [ ] Un appareil/émulateur est disponible (`flutter devices`)

---

## Obtenir de l'aide

Si le problème persiste :

1. Regardez les logs complets dans le terminal
2. Vérifiez le fichier `storage/logs/laravel.log` dans votre projet Laravel
3. Testez l'API avec Postman pour vérifier qu'elle fonctionne
4. Vérifiez que la base de données est accessible