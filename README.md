# 🛒 Flutter Ecommerce App

A modern, feature-rich ecommerce mobile application built with Flutter, featuring a clean UI, state management with BLoC, and local storage capabilities.

## ✨ Features

### 🏠 Core Features
- **Product Catalog** - Browse products with categories, ratings, and detailed information
- **Shopping Cart** - Add/remove items, quantity management, and cart persistence
- **Favorites** - Save products for later with persistent storage
- **Product Search** - Real-time search functionality with debouncing
- **Product Details** - Comprehensive product information with image galleries
- **Stock Management** - Out-of-stock indicators and validation

### 🎨 UI/UX Features
- **Modern Design** - Clean, intuitive interface with Material Design
- **Responsive Layout** - Optimized for different screen sizes
- **Dark/Light Theme** - System theme support with custom color schemes
- **Smooth Animations** - Polished transitions and micro-interactions
- **Custom Fonts** - Poppins font family for enhanced typography
- **Custom Icons** - Branded app icon with multi-platform support

### 🔧 Technical Features
- **State Management** - BLoC pattern for predictable state management
- **Local Storage** - Hive database for offline data persistence
- **Dependency Injection** - GetIt for service locator pattern
- **API Integration** - HTTP client with error handling and caching
- **Code Generation** - JSON serialization and Hive adapters
- **Share Functionality** - Product sharing across platforms

## 🏗️ Architecture

### State Management (BLoC Pattern)
```
📁 bloc/
├── product/          # Product state management
├── cart/            # Shopping cart state
└── favorites/       # Favorites state
```

### Repository Pattern
```
📁 repositories/
├── product_repository.dart    # Product data access
├── cart_repository.dart       # Cart operations
└── favorites_repository.dart  # Favorites management
```

### Services Layer
```
📁 services/
├── api_service.dart           # HTTP client & API calls
└── local_storage_service.dart # Hive database operations
```

### UI Components
```
📁 screens/          # App screens
📁 widgets/          # Reusable UI components
📁 utils/            # Utilities (colors, themes, helpers)
```

## 📱 Screenshots

### Home Screen
- Product grid with featured items
- Search functionality
- Category navigation
- Quick access to cart and favorites

### Product Details
- High-quality product images
- Detailed specifications
- Rating and reviews
- Add to cart/favorites actions

### Shopping Cart
- Item management
- Quantity controls
- Price calculations
- Checkout process

### Favorites
- Saved products
- Quick add to cart
- Remove from favorites

## 🛠️ Tech Stack

### Core Dependencies
- **Flutter** - UI framework
- **Dart** - Programming language

### State Management
- **flutter_bloc** - BLoC state management
- **bloc** - Core BLoC library

### Data & Storage
- **hive** - Local database
- **hive_flutter** - Flutter integration
- **http** - HTTP client

### Utilities
- **get_it** - Dependency injection
- **json_annotation** - JSON serialization
- **equatable** - Value equality
- **intl** - Internationalization
- **share_plus** - Share functionality
- **google_fonts** - Custom fonts

### Development Tools
- **build_runner** - Code generation
- **hive_generator** - Hive adapters
- **json_serializable** - JSON code generation
- **flutter_launcher_icons** - App icon generation
- **flutter_lints** - Code analysis

## 🎨 Design System

### Color Palette
- **Primary**: Green (#4CAF50)
- **Secondary**: White (#FFFFFF)
- **Accent**: Orange (#FF9800)
- **Text**: Dark Gray (#333333)
- **Background**: Light Gray (#F5F5F5)

### Typography
- **Font Family**: Poppins
- **Headings**: Bold, various sizes
- **Body**: Regular, readable sizes
- **Captions**: Light, smaller sizes

### Components
- **Product Cards** - Consistent product display
- **Buttons** - Primary, secondary, icon buttons
- **Navigation** - Bottom navigation bar
- **Search Bar** - Real-time search input
- **Cart Items** - Shopping cart item display

**Made with ❤️ using Flutter**