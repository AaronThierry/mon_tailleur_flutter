# 🏷️ Guide des Labels pour Curved Navigation Bar

## 📚 Styles disponibles

La Curved Navigation Bar propose **5 styles d'affichage** pour les labels d'onglets :

### 1. **alwaysVisible** ✨ (Par défaut)
Labels toujours visibles avec effet fade élégant.

**Caractéristiques** :
- ✅ Tous les labels affichés en permanence
- 📏 Taille plus grande pour l'item actif (11.5px vs 10px)
- 🎨 Effet ombre sur le label actif
- 💪 Police plus grasse pour l'item actif (700 vs 500)
- 🎭 Opacité réduite pour les items inactifs (60%)

**Usage** :
```dart
CurvedNavigationBar(
  // ... autres paramètres
  labelStyle: NavBarLabelStyle.alwaysVisible, // Défaut
)
```

**Aperçu** :
```
[🏠]     [🛍️]     [➕]      [🔔]      [👤]
Accueil Commandes  Ajouter  Notifs   Profil
```

---

### 2. **onlyActive** 🎯
Seul le label de l'item actif est affiché.

**Caractéristiques** :
- ✅ Label apparaît uniquement sur l'item sélectionné
- 🎬 Animation fade in/out au changement
- 🎨 Couleur assortie à l'item actif
- 📏 Police semi-bold (600)
- 🧹 Interface plus minimaliste

**Usage** :
```dart
CurvedNavigationBar(
  labelStyle: NavBarLabelStyle.onlyActive,
)
```

**Aperçu** :
```
[🏠]     [🛍️]     [➕]      [🔔]      [👤]
Accueil    -        -        -         -
```

---

### 3. **chip** 💊
Label dans un badge/chip moderne.

**Caractéristiques** :
- ✅ Label encapsulé dans un chip arrondi
- 🎨 Fond semi-transparent avec la couleur active (15% opacité)
- 🔲 Bordure de 1px avec couleur active (30% opacité)
- 📏 Police extra-bold (700)
- ✨ Style très moderne et tendance

**Usage** :
```dart
CurvedNavigationBar(
  labelStyle: NavBarLabelStyle.chip,
)
```

**Aperçu** :
```
[🏠]        [🛍️]      [➕]       [🔔]       [👤]
┌────────┐    -        -         -          -
│Accueil │
└────────┘
```

---

### 4. **glassmorphism** 🔮
Label avec effet verre dépoli (glassmorphism).

**Caractéristiques** :
- ✅ Fond gradient semi-transparent (verre dépoli)
- ✨ Bordure blanche lumineuse (30% opacité)
- 💎 Ombre colorée avec la couleur active
- 🎨 Texte blanc avec ombre portée
- 🏆 Style ultra-premium

**Usage** :
```dart
CurvedNavigationBar(
  labelStyle: NavBarLabelStyle.glassmorphism,
)
```

**Aperçu** :
```
[🏠]          [🛍️]      [➕]       [🔔]       [👤]
╔═════════╗    -        -         -          -
║ Accueil ║
╚═════════╝
(effet verre)
```

---

### 5. **none** ❌
Aucun label affiché.

**Caractéristiques** :
- ✅ Interface 100% minimaliste
- 🎯 Icônes uniquement
- 📱 Économie d'espace vertical
- 🧹 Design épuré

**Usage** :
```dart
CurvedNavigationBar(
  labelStyle: NavBarLabelStyle.none,
)
```

**Aperçu** :
```
[🏠]  [🛍️]  [➕]  [🔔]  [👤]
```

---

## 🎨 Exemples d'utilisation

### Exemple 1 : Style par défaut (Always Visible)

```dart
CurvedNavigationBar(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  items: const [
    NavBarItemData(icon: Icons.home_rounded, label: 'Accueil'),
    NavBarItemData(icon: Icons.shopping_bag_rounded, label: 'Commandes'),
    NavBarItemData(icon: Icons.add_rounded, label: 'Ajouter'),
    NavBarItemData(icon: Icons.notifications_rounded, label: 'Notifications'),
    NavBarItemData(icon: Icons.person_rounded, label: 'Profil'),
  ],
  // labelStyle par défaut = NavBarLabelStyle.alwaysVisible
)
```

### Exemple 2 : Style Chip moderne

```dart
CurvedNavigationBar(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  items: const [
    NavBarItemData(icon: Icons.home_rounded, label: 'Home'),
    NavBarItemData(icon: Icons.search_rounded, label: 'Search'),
    NavBarItemData(icon: Icons.add_rounded, label: 'Add'),
    NavBarItemData(icon: Icons.notifications_rounded, label: 'Alerts'),
    NavBarItemData(icon: Icons.person_rounded, label: 'Profile'),
  ],
  labelStyle: NavBarLabelStyle.chip,
  activeColor: Color(0xFF6366F1),
)
```

### Exemple 3 : Style Glassmorphism premium

```dart
CurvedNavigationBar(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  items: const [
    NavBarItemData(icon: Icons.home_rounded, label: 'Accueil'),
    NavBarItemData(icon: Icons.shopping_bag_rounded, label: 'Shop'),
    NavBarItemData(icon: Icons.add_rounded, label: 'Créer'),
    NavBarItemData(icon: Icons.notifications_rounded, label: 'Notifs'),
    NavBarItemData(icon: Icons.person_rounded, label: 'Moi'),
  ],
  labelStyle: NavBarLabelStyle.glassmorphism,
  backgroundColor: Color(0xFF1A1A2E),
  activeColor: Color(0xFF8B5CF6),
)
```

### Exemple 4 : Minimaliste (Only Active)

```dart
CurvedNavigationBar(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  items: const [
    NavBarItemData(icon: Icons.dashboard_rounded, label: 'Dashboard'),
    NavBarItemData(icon: Icons.analytics_rounded, label: 'Analytics'),
    NavBarItemData(icon: Icons.add_circle_rounded, label: 'New'),
    NavBarItemData(icon: Icons.message_rounded, label: 'Messages'),
    NavBarItemData(icon: Icons.settings_rounded, label: 'Settings'),
  ],
  labelStyle: NavBarLabelStyle.onlyActive,
)
```

### Exemple 5 : Sans labels (Icons Only)

```dart
CurvedNavigationBar(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  items: const [
    NavBarItemData(icon: Icons.home_rounded, label: ''), // Label ignoré
    NavBarItemData(icon: Icons.explore_rounded, label: ''),
    NavBarItemData(icon: Icons.add_rounded, label: ''),
    NavBarItemData(icon: Icons.favorite_rounded, label: ''),
    NavBarItemData(icon: Icons.person_rounded, label: ''),
  ],
  labelStyle: NavBarLabelStyle.none,
)
```

---

## 🎯 Recommandations par cas d'usage

| Cas d'usage | Style recommandé | Raison |
|-------------|------------------|--------|
| **App grand public** | `alwaysVisible` | Clarté maximale pour tous les utilisateurs |
| **App professionnelle** | `chip` ou `glassmorphism` | Look moderne et premium |
| **App minimaliste** | `onlyActive` | Interface épurée |
| **App mobile gaming** | `none` | Maximise l'espace pour le contenu |
| **App avec labels courts** | `alwaysVisible` | Tous les labels tiennent bien |
| **App avec labels longs** | `onlyActive` ou `chip` | Évite le chevauchement |

---

## 🎨 Personnalisation avancée

### Couleurs personnalisées

```dart
CurvedNavigationBar(
  labelStyle: NavBarLabelStyle.chip,
  activeColor: Color(0xFFFF6B6B),     // Rouge corail
  inactiveColor: Color(0xFFBDBDBD),   // Gris
  backgroundColor: Color(0xFF2C3E50),  // Bleu foncé
)
```

### Avec gradient personnalisé

```dart
CurvedNavigationBar(
  labelStyle: NavBarLabelStyle.glassmorphism,
  centerButtonGradient: LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFFFE66D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
)
```

---

## 🐛 Troubleshooting

### Les labels ne s'affichent pas ?

1. **Vérifiez que vous passez bien le label** :
   ```dart
   NavBarItemData(
     icon: Icons.home_rounded,
     label: 'Accueil', // ✅ N'oubliez pas le label !
   )
   ```

2. **Vérifiez le style** :
   ```dart
   labelStyle: NavBarLabelStyle.none // ❌ Aucun label ne s'affiche
   labelStyle: NavBarLabelStyle.alwaysVisible // ✅ Labels visibles
   ```

### Les labels sont tronqués ?

- Utilisez des labels plus courts (max 8-10 caractères)
- Passez au style `onlyActive` pour les labels longs
- Réduisez la taille de police si nécessaire (modification dans `nav_bar_item.dart`)

### Les labels chevauchent les icônes ?

- Augmentez la hauteur de la navbar :
  ```dart
  CurvedNavigationBar(
    height: 85, // Au lieu de 75
  )
  ```

---

## 📝 Changelog

### v1.0.0 - 2026-01-01
- ✨ Ajout de 5 styles de labels
- 🎨 Animations fluides pour tous les styles
- 📱 Support complet responsive
- 🎯 Style `alwaysVisible` par défaut

---

**🎉 Profitez de votre navbar stylée et professionnelle !**