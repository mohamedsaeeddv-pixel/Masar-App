class AppValidators {
  static String? email(String? email) {
    if (email == null || email.isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    if (!email.contains('@')) {
      return 'صيغة البريد الإلكتروني غير صحيحة';
    }
    final split = email.split('@');
    if (split.length != 2 || split.contains('')) {
      return 'صيغة البريد الإلكتروني غير صحيحة';
    }
    return null;
  }


  static String? password(String? password) {
    if (password == null || password.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    if (password.length < 6) {
      return 'كلمة المرور يجب أن تكون على الأقل 6 أحرف';
    }

    // لو حبيت تضيف الشروط دي:
    // if (!password.contains(RegExp('[0-9]'))) {
    //   return 'كلمة المرور يجب أن تحتوي على رقم';
    // }
    // if (!password.contains(RegExp('[A-Z]'))) {
    //   return 'كلمة المرور يجب أن تحتوي على حرف كبير';
    // }
    // if (!password.contains(RegExp(r'[!@#$%^&*()_+\-=\[\]{};:"|,.<>\/?' "'" ']'))) {
    //   return 'كلمة المرور يجب أن تحتوي على رمز خاص';
    // }

    return null;
  }
  static String? chatMessage(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'لا يمكن إرسال رسالة فارغة';
  }

  if (value.trim().isEmpty) {
    return 'الرسالة قصيرة جداً';
  }

  return null;
}

  static String? required(String? value) {
    if (value == null || value.isEmpty) {
      return 'هذا الحقل مطلوب';
    }
    return null;
  }

  static String? numbersExactLength(String? value, int length) {
    if (value == null || value.isEmpty) {
      return 'هذا الحقل مطلوب';
    }

    if (value.length != length) {
      return 'يجب أن يكون طول الرقم بالضبط $length رقم';
    }

    return null;
  }

  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'رقم الهاتف مطلوب';
    }

    if (!value.contains(RegExp('^[0-9]*\$')) || value[0] != '0') {
      return 'صيغة رقم الهاتف غير صحيحة';
    }

    if (value.length != 11) {
      return 'رقم الهاتف يجب أن يكون 11 رقم';
    }

    return null;
  }

  static String? identical(String? value, String? other) {
    if (value == null || value.isEmpty) {
      return 'هذا الحقل مطلوب';
    }

    if (value != other) {
      return 'القيمتين غير متطابقتين';
    }

    return null;
  }

  static String? otp(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال رمز التحقق';
    }

    return null;
  }
}
