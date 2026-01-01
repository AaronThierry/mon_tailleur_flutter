# Curved Navigation Bar - Documentation

Une Bottom Navigation Bar Flutter moderne avec un design curvilinéaire élégant et professionnel.

## 🎨 Caractéristiques

- ✨ Design curvilinéaire avec découpe concave au centre
- 🎯 5 items de navigation avec bouton central surélevé
- 🌈 Bouton central avec gradient personnalisable
- 🎭 Animations fluides (scale, couleur, pulse, wave)
- 📍 Indicateur de sélection (point lumineux)
- 🔔 Support des badges de notification
- 🎨 Thème entièrement personnalisable
- 💫 Effet glassmorphism optionnel
- 📱 Responsive et adaptatif

## 📦 Fichiers

```
lib/widgets/
├── curved_navigation_bar.dart      # Widget principal
├── curved_nav_clipper.dart         # CustomClipper et CustomPainter
├── nav_bar_item.dart               # Items individuels avec animations
└── CURVED_NAVBAR_README.md         # Cette documentation
```

## 🚀 Utilisation de base

### 1. Import

```dart
import 'package:mon_tailleur/widgets/curved_navigation_bar.dart';
```

### 2. Définir les items

```dart
final List<NavBarItemData> navItems = const [
  NavBarItemData(icon: Icons.home_rounded, label: 'Home'),
  NavBarItemData(icon: Icons.search_rounded, label: 'Search'),
  NavBarItemData(icon: Icons.add_rounded, label: 'Add'),
  NavBarItemData(
    icon: Icons.notifications_rounded,
    label: 'Notifications',
    badgeCount: 5, // Badge optionnel
  ),
  NavBarItemData(icon: Icons.person_rounded, label: 'Profile'),
];
```

### 3. Intégrer dans un Scaffold

```dart
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: navItems,
      ),
    );
  }
}
```

## ⚙️ Personnalisation

### Couleurs

```dart
CurvedNavigationBar(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  items: navItems,
  backgroundColor: Colors.white,           // Couleur de fond
  activeColor: Color(0xFF6366F1),         // Couleur active
  inactiveColor: Color(0xFF9CA3AF),       // Couleur inactive
)
```

### Gradient du bouton central

#### Utiliser un preset

```dart
CurvedNavigationBar(
  // ...
  centerButtonGradient: NavBarGradients.purplePink,
)
```

**Gradients disponibles :**
- `NavBarGradients.purplePink` - Violet/Rose (défaut)
- `NavBarGradients.blueCyan` - Bleu/Cyan
- `NavBarGradients.orangeRed` - Orange/Rouge
- `NavBarGradients.emerald` - Vert émeraude
- `NavBarGradients.golden` - Doré
- `NavBarGradients.indigo` - Indigo

#### Gradient personnalisé

```dart
CurvedNavigationBar(
  // ...
  centerButtonGradient: LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFF4ECDC4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
)
```

### Hauteur

```dart
CurvedNavigationBar(
  // ...
  height: 75, // Valeur par défaut: 75
)
```

### Effet Glassmorphism

```dart
CurvedNavigationBar(
  // ...
  enableGlassmorphism: true,
)
```

## 🎯 Exemples d'utilisation

### Exemple complet avec pages

Voir le fichier `lib/screens/curved_navbar_demo_screen.dart` pour un exemple complet avec :
- 5 pages différentes (Home, Search, Add, Notifications, Profile)
- Gestion de l'état
- Design moderne
- Badge de notification

### Lancer la démo

```dart
// Dans main.dart
void main() {
  runApp(MaterialApp(
    home: CurvedNavBarDemoScreen(),
  ));
}
```

## 🎨 Personnalisation avancée

### Modifier la forme de la courbe

Dans `curved_nav_clipper.dart`, ajustez les paramètres :

```dart
final double curveDepth = 30.0;  // Profondeur de la découpe
final double curveWidth = 100.0;  // Largeur de la découpe
```

### Personnaliser les animations

Dans `nav_bar_item.dart`, modifiez les paramètres d'animation :

```dart
AnimationController(
  duration: const Duration(milliseconds: 200), // Durée
  vsync: this,
);
```

### Changer la taille du bouton central

Dans `nav_bar_item.dart`, classe `CenterFloatingButton` :

```dart
Container(
  width: 65,   // Largeur
  height: 65,  // Hauteur
  // ...
)
```

## 📋 Propriétés

### CurvedNavigationBar

| Propriété | Type | Défaut | Description |
|-----------|------|--------|-------------|
| `currentIndex` | `int` | **Requis** | Index de l'item actif |
| `onTap` | `Function(int)` | **Requis** | Callback au tap |
| `items` | `List<NavBarItemData>` | **Requis** | Liste des 5 items |
| `backgroundColor` | `Color` | `#F8F9FA` | Couleur de fond |
| `activeColor` | `Color` | `#6366F1` | Couleur active |
| `inactiveColor` | `Color` | `#9CA3AF` | Couleur inactive |
| `centerButtonGradient` | `Gradient?` | `purplePink` | Gradient du bouton central |
| `height` | `double` | `75` | Hauteur de la navbar |
| `enableGlassmorphism` | `bool` | `false` | Activer l'effet glassmorphism |

### NavBarItemData

| Propriété | Type | Défaut | Description |
|-----------|------|--------|-------------|
| `icon` | `IconData` | **Requis** | Icône de l'item |
| `label` | `String` | **Requis** | Label de l'item |
| `badgeCount` | `int?` | `null` | Nombre pour le badge |

## 🎭 Animations incluses

1. **Scale Animation** - Les icônes se réduisent légèrement au tap
2. **Color Transition** - Transition fluide entre couleurs active/inactive
3. **Pulse/Bounce** - Le bouton central pulse au tap
4. **Wave Effect** - Vague qui se déplace vers l'item sélectionné
5. **Indicator** - Point lumineux sous l'icône active
6. **Badge** - Animation du badge de notification

## 🔧 Dépendances

Aucune dépendance externe requise ! Utilise uniquement :
- `flutter/material.dart`
- Widgets natifs Flutter

## 💡 Conseils

1. **Performance** : Les animations utilisent `SingleTickerProviderStateMixin` pour optimiser les performances
2. **Accessibilité** : Utilisez des couleurs avec un bon contraste
3. **Responsive** : La navbar s'adapte automatiquement à la largeur de l'écran
4. **État** : Gérez `currentIndex` dans un StatefulWidget parent

## 🐛 Troubleshooting

### La navbar ne s'affiche pas correctement

Assurez-vous que :
- Vous avez exactement 5 items dans la liste
- Le `currentIndex` est entre 0 et 4
- Le widget est dans un Scaffold avec `bottomNavigationBar`

### Les animations sont saccadées

- Vérifiez que vous n'avez pas trop de widgets lourds dans vos pages
- Utilisez `const` constructors quand possible
- Considérez l'utilisation de `RepaintBoundary` pour isoler les animations

### Le bouton central n'apparaît pas

- Vérifiez que l'item au centre (index 2) a bien une icône
- Assurez-vous que le Scaffold n'a pas de `extendBody: false`

## 📱 Screenshots

La navbar fonctionne parfaitement sur :
- iOS (iPhone SE à iPhone 15 Pro Max)
- Android (tous formats)
- Web (responsive)
- Desktop (Windows, macOS, Linux)

## 📄 Licence

Ce composant fait partie du projet Mon Tailleur.
Libre d'utilisation dans le cadre du projet.

## 🙏 Crédits

Inspiré des meilleures pratiques UI/UX modernes et des designs Material 3.

---

**Besoin d'aide ?** Consultez le fichier de démo : `lib/screens/curved_navbar_demo_screen.dart`