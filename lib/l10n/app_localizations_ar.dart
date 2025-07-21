// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'متجر سبرنتس';

  @override
  String get welcomeTitle => 'مرحباً بكم في متجر سبرنتس';

  @override
  String get welcomeSubtitle => 'وجهتكم الوحيدة للمنتجات المذهلة';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get welcomeBack => 'مرحباً بعودتك';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get ourProducts => 'منتجاتنا';

  @override
  String get hotOffers => 'العروض الساخنة';

  @override
  String get addToCart => 'إضافة للسلة';

  @override
  String itemAddedToCart(Object item) {
    return 'تم إضافة $item للسلة';
  }

  @override
  String get success => 'نجح';

  @override
  String get accountCreatedSuccessfully => 'تم إنشاء الحساب بنجاح';

  @override
  String get accountSignInSuccessfully => 'تم تسجيل الدخول بنجاح';

  @override
  String get close => 'إغلاق';

  @override
  String get pleaseEnterFullName => 'يرجى إدخال الاسم الكامل';

  @override
  String get firstLetterUppercase => 'يجب أن يكون الحرف الأول كبيراً';

  @override
  String get pleaseEnterEmail => 'يرجى إدخال البريد الإلكتروني';

  @override
  String get emailMustIncludeAt => 'يجب أن يحتوي البريد الإلكتروني على @';

  @override
  String get pleaseEnterPassword => 'يرجى إدخال كلمة المرور';

  @override
  String get passwordMinLength => 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';

  @override
  String get pleaseConfirmPassword => 'يرجى تأكيد كلمة المرور';

  @override
  String get passwordsDoNotMatch => 'كلمات المرور غير متطابقة';
}
