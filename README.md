# 🌌 MilkyWay — Track Your Journey

> A GPS journey tracker for iOS. Record routes in real time, visualize them on the map, and build a personal atlas of everywhere you've been.

![Platform](https://img.shields.io/badge/Platform-iOS%2017%2B-blue?style=flat)
![Swift](https://img.shields.io/badge/Swift-6.0+-orange?style=flat)
![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-purple?style=flat)
![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-green?style=flat)
![Status](https://img.shields.io/badge/Status-In%20Progress-yellow?style=flat)

---

### ✅ Core Infrastructure
- **Clean Architecture** — Domain, Data, and Presentation layers fully separated
- **Custom Coordinator pattern** — type-safe navigation with `NavigationCoordinator` and `ModalCoordinator`
- **Dependency Injection** — FactoryKit container with protocol-based injection
- **SwiftData persistence** — `MapRouteDTO` model with `PersistenceStore`
- **Use Cases** — `MapUseCase` and `MockMapUseCase` for testing
- **Repository pattern** — `MapRepository` with `MapRepositoryProtocol`
- **Network layer** — custom `NetworkService` with `URLSession` + `async/await`
- **ReachabilityService** — network connectivity monitoring
- **LocationService** — `@Observable` wrapper around `CLLocationManager`
- **Custom fonts** — Poppins integrated via SwiftGen
- **Localization** — `Strings+Generated` via SwiftGen

---

## 🛠 Tech Stack

| Layer | Technology |
|-------|------------|
| UI Framework | SwiftUI (iOS 17 native APIs) |
| Maps | MapKit — `Map()`, `MapPolyline`, `Annotation()`, `UserAnnotation()` |
| Location | CoreLocation — `CLLocationManager` wrapped in `@Observable` service |
| Persistence | SwiftData |
| State Management | `@Observable` macro (iOS 17) |
| Navigation | Custom Coordinator pattern (`NavigationCoordinator`, `ModalCoordinator`) |
| Dependency Injection | FactoryKit |
| Networking | Custom `NetworkService` — `URLSession` + `async/await` |
| Code Generation | SwiftGen (Fonts, Icons, Localizable strings) |
| Architecture | Clean Architecture — Domain / Data / Presentation |
| Min Deployment | iOS 17.0 |
| Swift | 6.0+ |

---

## 🏗 Project Structure

```
MilkyWay/
├── Application/
│   ├── AppCoordinator/        # Root app coordinator
│   ├── DIContainer/           # FactoryKit DI container
│   ├── Configuration/         # App configuration
6
│   └── MilkyWayApp.swift      # @main entry, SwiftData container
├── Domain/
│   ├── Entities/              # MapRoute (core domain model)
│   ├── UseCases/              # MapUseCase, MockMapUseCase
│   ├── RepositoryProtocol/    # MapRepositoryProtocol
│   └── UseCaseProtocol/       # MapUseCaseProtocol
├── Data/
│   ├── Repositories/          # MapRepository
│   ├── PersistentStorage/     # SwiftData store, MapRouteDTO
│   └── NetworkExtension/      # API routes, DTOs, network helpers
├── Infrastructure/
│   ├── Coordinators/          # NavigationCoordinator, ModalCoordinator
│   ├── Network/               # NetworkService, URLRequest extensions
│   └── Services/
│       ├── LocationService/   # CLLocationManager wrapper
│       └── ReachabilityService/
├── Presentation/
│   ├── Auth/                  # SignInView + coordinator
│   └── Tabs/
│       ├── Map/               # MapView, MapViewModel, RecordRouteButtonView
│       ├── Routes/            # RoutesView, RoutesViewModel
│       ├── Explore/           # ExploreView (in progress)
│       ├── Profile/           # ProfileView (in progress)
│       └── TabsCoordinator.swift
├── Helpers/
│   ├── Extensions/            # Color, View, Map, LinearGradient extensions
│   ├── Modifiers/             # LoadingModifier
│   └── Logger/                # Log utility
└── Resources/
    ├── Fonts/                 # Poppins (SwiftGen generated)
    ├── Icons/                 # SwiftGen generated
    └── Localizables/          # SwiftGen generated strings
```

---

## 🏛 Architecture

MilkyWay follows **Clean Architecture** with three layers:

```
Presentation → Domain ← Data
```

- **Domain layer** — pure Swift, no framework dependencies. Contains `MapRoute` entity, `MapUseCaseProtocol`, `MapRepositoryProtocol`
- **Data layer** — SwiftData persistence, network DTOs, `MapRepository` implementation
- **Presentation layer** — SwiftUI views, `@Observable` ViewModels, Coordinator-based navigation

Navigation uses a **custom Coordinator pattern** — each tab owns its own flow coordinator, with type-safe routing via associated values.

Dependency injection uses **FactoryKit** — all dependencies registered in `Container+Injection.swift` and injected via `@InjectedObservable` / `@Injected` property wrappers.

---

## 🚀 Getting Started

### Requirements
- Xcode 16+
- iOS 17.0+ device or simulator
- Swift 6.0+

### Setup
```bash
git clone https://github.com/BaidetskyiYurii/MilkyWay.git
cd MilkyWay
open MilkyWay/MilkyWay.xcodeproj
```

> **Note:** Location features require a physical device or a simulated location set in Xcode's Features menu.

---

## 🗺 Roadmap

**Foundation**
- [x] Clean Architecture setup (Domain / Data / Presentation)
- [x] Custom Coordinator navigation pattern
- [x] FactoryKit dependency injection
- [x] SwiftData persistence layer
- [x] Custom NetworkService with async/await
- [x] LocationService with real-time GPS tracking
- [x] ReachabilityService

**Map & Recording**
- [x] Live MapKit map with dark style
- [x] Real-time GPS route recording
- [x] MapPolyline route rendering with glow effect
- [x] Start / end point annotations
- [x] Auto-zoom to saved route
- [x] Error handling with coordinator alerts

**Routes**
- [x] Routes list with SwiftData
- [x] Route cards with delete
- [x] Empty state view
- [ ] Route detail screen with full map preview
- [ ] Route naming and editing
- [ ] Distance and duration stats per route

**Explore & Profile**
- [ ] Explore tab — heatmap, travel stats, countries visited
- [ ] Profile tab — journey count, total distance, settings
- [ ] Cloud sync (iCloud)

**Polish**
- [ ] Photo pin dropping during active recording
- [ ] Animated route rendering
- [ ] Journey story export
- [ ] App Store release

---

## 👨‍💻 Author

**Yurii Baidetskyi** — iOS Engineer  
[LinkedIn](https://linkedin.com/in/yuriibaidetskyi) · [GitHub](https://github.com/BaidetskyiYurii)
