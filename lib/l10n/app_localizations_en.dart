// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Sprints Shop';

  @override
  String get welcomeTitle => 'Welcome to Sprints Shop';

  @override
  String get welcomeSubtitle =>
      'Your one-stop destination for amazing products';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signIn => 'Sign In';

  @override
  String get createAccount => 'Create Account';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get fullName => 'Full Name';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get ourProducts => 'Our Products';

  @override
  String get hotOffers => 'Hot Offers';

  @override
  String get addToCart => 'Add to Cart';

  @override
  String itemAddedToCart(Object item) {
    return '$item added to cart';
  }

  @override
  String get success => 'Success';

  @override
  String get accountCreatedSuccessfully => 'Account created successfully';

  @override
  String get accountSignInSuccessfully => 'Account sign-in successfully';

  @override
  String get close => 'Close';

  @override
  String get pleaseEnterFullName => 'Please enter your full name';

  @override
  String get firstLetterUppercase => 'First letter must be uppercase';

  @override
  String get pleaseEnterEmail => 'Please enter your email';

  @override
  String get emailMustIncludeAt => 'Email must include @';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get pleaseConfirmPassword => 'Please confirm your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';
}
