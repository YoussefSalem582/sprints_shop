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
  String get continueAsGuest => 'متابعة كضيف';

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

  @override
  String get cart => 'السلة';

  @override
  String get checkout => 'الدفع';

  @override
  String get total => 'الإجمالي';

  @override
  String get emptyCart => 'السلة فارغة';

  @override
  String get remove => 'إزالة';

  @override
  String get quantity => 'الكمية';

  @override
  String get price => 'السعر';

  @override
  String get subtotal => 'المجموع الفرعي';

  @override
  String get shipping => 'الشحن';

  @override
  String get tax => 'الضريبة';

  @override
  String get home => 'الرئيسية';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get theme => 'المظهر';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get orders => 'الطلبات';

  @override
  String get wishlist => 'المفضلة';

  @override
  String get search => 'البحث';

  @override
  String get searchProducts => 'البحث عن المنتجات...';

  @override
  String get categories => 'الفئات';

  @override
  String get allCategories => 'جميع الفئات';

  @override
  String get electronics => 'الإلكترونيات';

  @override
  String get clothing => 'الملابس';

  @override
  String get home_garden => 'المنزل والحديقة';

  @override
  String get sports => 'الرياضة';

  @override
  String get books => 'الكتب';

  @override
  String get beauty => 'الجمال';

  @override
  String get productDetails => 'تفاصيل المنتج';

  @override
  String get description => 'الوصف';

  @override
  String get reviews => 'التقييمات';

  @override
  String get rating => 'التقييم';

  @override
  String get addToWishlist => 'إضافة للمفضلة';

  @override
  String get removeFromWishlist => 'إزالة من المفضلة';

  @override
  String get buyNow => 'اشترِ الآن';

  @override
  String get selectSize => 'اختر المقاس';

  @override
  String get selectColor => 'اختر اللون';

  @override
  String get inStock => 'متوفر';

  @override
  String get outOfStock => 'غير متوفر';

  @override
  String get orderHistory => 'تاريخ الطلبات';

  @override
  String get orderNumber => 'رقم الطلب';

  @override
  String get orderDate => 'تاريخ الطلب';

  @override
  String get orderStatus => 'حالة الطلب';

  @override
  String get pending => 'قيد الانتظار';

  @override
  String get processing => 'قيد المعالجة';

  @override
  String get shipped => 'تم الشحن';

  @override
  String get delivered => 'تم التوصيل';

  @override
  String get cancelled => 'ملغي';

  @override
  String get track => 'تتبع';

  @override
  String get reorder => 'إعادة طلب';

  @override
  String get paymentMethod => 'طريقة الدفع';

  @override
  String get creditCard => 'بطاقة ائتمان';

  @override
  String get paypal => 'باي بال';

  @override
  String get applePay => 'أبل باي';

  @override
  String get googlePay => 'جوجل باي';

  @override
  String get shippingAddress => 'عنوان الشحن';

  @override
  String get billingAddress => 'عنوان الفواتير';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get aboutUs => 'عنا';

  @override
  String get contactUs => 'اتصل بنا';

  @override
  String get termsOfService => 'شروط الخدمة';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get help => 'المساعدة';

  @override
  String get faq => 'الأسئلة الشائعة';

  @override
  String get customerSupport => 'دعم العملاء';

  @override
  String get version => 'الإصدار';

  @override
  String get darkMode => 'الوضع المظلم';

  @override
  String get lightMode => 'الوضع المضيء';

  @override
  String get pushNotifications => 'الإشعارات المباشرة';

  @override
  String get emailNotifications => 'إشعارات البريد الإلكتروني';

  @override
  String get smsNotifications => 'إشعارات الرسائل النصية';

  @override
  String get currency => 'العملة';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get edit => 'تعديل';

  @override
  String get delete => 'حذف';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get ok => 'موافق';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get error => 'خطأ';

  @override
  String get connectionError => 'خطأ في الاتصال';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get noInternetConnection => 'لا يوجد اتصال بالإنترنت';
}
