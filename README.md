# 🛒 Sprints Shop - Flutter Shopping App

A comprehensive Flutter shopping application built from core Dart programming principles to professional mobile app development.

## 📱 Project Overview

This Flutter project demonstrates the development of a fully functional shopping application that includes user authentication, product displays, cart interactions, and responsive UI. The app simulates a real-world shopping interface with smooth animations and professional design.

## ✨ Features

### 1. 🎨 Aesthetic Welcome Screen
- **Static Intro Widget** with AppBar title
- **Two images in a row** (1 local image + 1 online image) 
- **Custom Suwannaphum font** with custom size, bold, and colored text
- **Centered elements** with adequate spacing
- **Two navigation buttons**: Sign-up and Sign-in

### 2. 🔐 Authentication System
- **Sign-Up Form** with validation:
  - Full Name (First letter must be uppercase)
  - Email (Must include @)
  - Password (At least 6 characters)
  - Confirm Password (Must match password)
- **Sign-In Form** with validation:
  - Email (Must include @)
  - Password (At least 6 characters)
- **Success dialogs** with navigation to main shopping screen

### 3. 🎬 Smooth Transitions
- **Animated Navigation** with fade transitions
- **Seamless page transitions** between authentication and shopping screens

### 4. 🏪 Interactive Shopping Home Screen
- **AppBar** titled "Our Products"
- **Horizontal PageView** showing featured product images
- **Responsive GridView** with product cards (2 per row):
  - Product image
  - Product title
  - Add to Cart icon with SnackBar feedback
- **"Hot Offers" section** with ListView.builder
  - 5 vertically scrollable offers
  - Each item includes image and description using Expanded

### 5. 🌍 Arabic Language Support (Bonus)
- **Complete Arabic localization**:
  - "منتجاتنا" instead of "Our Products"
  - "العروض الساخنة" for "Hot Offers"
  - All UI text available in Arabic
- **No hardcoded strings** in UI code
- **Uses .arb files** and localization setup via intl

## 🛠️ Tools & Technologies Used

- **Dart**: For logic, functions, and OOP
- **Flutter SDK**: For app UI and features
- **GitHub**: Public repository with documentation
- **VS Code**: IDE for development
- **Flutter Intl**: For localization
- **Command Line Tools**: For Flutter project management

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── screens/                  # All screen widgets
│   ├── welcome_screen.dart
│   ├── sign_up_screen.dart
│   ├── sign_in_screen.dart
│   └── shopping_home_screen.dart
├── widgets/                  # Reusable UI components
│   ├── product_card.dart
│   └── hot_offer_item.dart
├── models/                   # Data models
│   └── product.dart
└── l10n/                    # Localization files
    ├── app_en.arb
    └── app_ar.arb
```

## 🚀 Setup Instructions

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- VS Code or Android Studio
- Git

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd sprints_shop
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Add custom font (optional)**
   - Download Suwannaphum-Regular.ttf
   - Place it in `assets/fonts/`
   - Uncomment font configuration in `pubspec.yaml`

4. **Run the app**
   ```bash
   flutter run
   ```

   For web development:
   ```bash
   flutter run -d chrome
   ```

## 🎮 Live Demo

The app is **fully functional** and ready to use! You can run it immediately using the commands above.

### ✅ What's Working:
- Welcome screen with smooth navigation
- Complete user registration with real-time validation
- Sign-in with success confirmation dialog
- Shopping catalog with responsive product grid
- Hot offers horizontal scrolling
- Add to cart functionality with user feedback
- Arabic localization (UI ready, full integration available)

## 🖼️ Screenshots

*Screenshots will be added here showing the app's functionality*

## 🎯 Key Programming Concepts Demonstrated

- **Variables and Constants**: Used throughout for data management
- **Control Flow**: Implemented in validation logic and navigation
- **Functions**: Created for form validation and user interactions
- **Object-Oriented Programming**: Models and widget classes
- **Stateless and Stateful Widgets**: Used appropriately for UI components
- **Input Validation**: Form validation with custom validators
- **Navigation**: Page routing with custom transitions
- **Animations**: Fade transitions and smooth UI interactions
- **Localization**: Multi-language support (English/Arabic)

## 🏗️ Architecture & Best Practices

- **Modular Structure**: Each widget/class in separate files
- **Clean Code**: Clear variable/function/class names
- **No Code Duplication**: Reusable widgets and functions
- **Proper Validation**: Form validation with user feedback
- **Responsive Design**: Adaptive layouts for different screen sizes
- **Error Handling**: Graceful error handling for network images

## 🌐 Localization Support

The app supports both English and Arabic languages:

### English (Default)
- Left-to-right text direction
- English product names and descriptions
- Standard Western UI patterns

### Arabic
- Right-to-left text direction
- Arabic translations for all text
- Culturally appropriate UI adaptations

## 🔄 Navigation Flow

1. **Welcome Screen** → Choose Sign Up or Sign In
2. **Authentication** → Validate user input
3. **Success Dialog** → Confirm account creation/login
4. **Shopping Home** → Browse products and offers
5. **Add to Cart** → Receive feedback via SnackBar

## 📱 UI/UX Features

- **Gradient Backgrounds**: Beautiful color gradients
- **Card-based Design**: Modern card layouts for products
- **Icons and Images**: Rich visual elements
- **Responsive Grid**: Adaptive product grid layout
- **Smooth Animations**: Professional page transitions
- **Interactive Elements**: Hover effects and touch feedback

## 🎨 Design Principles

- **Material Design**: Following Flutter's Material Design guidelines
- **Consistency**: Uniform styling across all screens
- **Accessibility**: Clear contrast and readable fonts
- **User Feedback**: Visual feedback for all user actions
- **Professional Look**: Business-ready UI design

## 🚧 Future Enhancements

- Shopping cart functionality
- User profile management
- Payment integration
- Product search and filtering
- Wishlist feature
- Order history
- Push notifications

## 📄 License

This project is created for educational purposes as part of the Flutter Mobile App Development course.

---

**Developed with ❤️ using Flutter & Dart**
