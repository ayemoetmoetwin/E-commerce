import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'constants.dart';
import 'colors.dart';

class AppHelpers {
  // Format currency
  static String formatCurrency(
    double amount, {
    String symbol = AppConstants.currencySymbol,
  }) {
    final formatter = NumberFormat('#,##0');
    return '${formatter.format(amount)} $symbol';
  }

  // Format date
  static String formatDate(DateTime date, {String pattern = 'MMM dd, yyyy'}) {
    final formatter = DateFormat(pattern);
    return formatter.format(date);
  }

  // Format date and time
  static String formatDateTime(
    DateTime dateTime, {
    String pattern = 'MMM dd, yyyy HH:mm',
  }) {
    final formatter = DateFormat(pattern);
    return formatter.format(dateTime);
  }

  // Format relative time (e.g., "2 hours ago")
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  // Validate email
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // Validate phone number
  static bool isValidPhoneNumber(String phoneNumber) {
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{10,}$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  // Validate password
  static bool isValidPassword(String password) {
    return password.length >= AppConstants.minPasswordLength &&
        password.length <= AppConstants.maxPasswordLength;
  }

  // Validate name
  static bool isValidName(String name) {
    return name.length >= AppConstants.minNameLength &&
        name.length <= AppConstants.maxNameLength &&
        name.trim().isNotEmpty;
  }

  // Capitalize first letter
  static String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // Capitalize each word
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => capitalizeFirst(word)).join(' ');
  }

  // Truncate text
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // Generate random string
  static String generateRandomString(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    final buffer = StringBuffer();

    for (int i = 0; i < length; i++) {
      buffer.write(chars[(random + i) % chars.length]);
    }

    return buffer.toString();
  }

  // Generate unique ID
  static String generateUniqueId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${generateRandomString(8)}';
  }

  // Calculate discount percentage
  static double calculateDiscountPercentage(
    double originalPrice,
    double discountedPrice,
  ) {
    if (originalPrice <= 0) return 0;
    return ((originalPrice - discountedPrice) / originalPrice) * 100;
  }

  // Calculate tax
  static double calculateTax(
    double amount, {
    double taxRate = AppConstants.defaultTaxRate,
  }) {
    return amount * taxRate;
  }

  // Calculate total with tax
  static double calculateTotalWithTax(
    double amount, {
    double taxRate = AppConstants.defaultTaxRate,
  }) {
    return amount + calculateTax(amount, taxRate: taxRate);
  }

  // Show snackbar
  static void showSnackBar(
    BuildContext context,
    String message, {
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
      ),
    );
  }

  // Show success snackbar
  static void showSuccessSnackBar(BuildContext context, String message) {
    showSnackBar(context, message, backgroundColor: AppColors.success);
  }

  // Show error snackbar
  static void showErrorSnackBar(BuildContext context, String message) {
    showSnackBar(context, message, backgroundColor: AppColors.error);
  }

  // Show warning snackbar
  static void showWarningSnackBar(BuildContext context, String message) {
    showSnackBar(context, message, backgroundColor: AppColors.warning);
  }

  // Show info snackbar
  static void showInfoSnackBar(BuildContext context, String message) {
    showSnackBar(context, message, backgroundColor: AppColors.info);
  }

  // Show confirmation dialog
  static Future<bool?> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String content,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: confirmColor),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  // Show loading dialog
  static void showLoadingDialog(
    BuildContext context, {
    String message = 'Loading...',
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Text(message),
          ],
        ),
      ),
    );
  }

  // Hide loading dialog
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  // Get device type
  static String getDeviceType(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    if (mediaQuery.size.width < 600) {
      return 'mobile';
    } else if (mediaQuery.size.width < 900) {
      return 'tablet';
    } else {
      return 'desktop';
    }
  }

  // Check if device is mobile
  static bool isMobile(BuildContext context) {
    return getDeviceType(context) == 'mobile';
  }

  // Check if device is tablet
  static bool isTablet(BuildContext context) {
    return getDeviceType(context) == 'tablet';
  }

  // Check if device is desktop
  static bool isDesktop(BuildContext context) {
    return getDeviceType(context) == 'desktop';
  }

  // Get responsive padding
  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(AppConstants.defaultPadding);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(AppConstants.largePadding);
    } else {
      return const EdgeInsets.all(AppConstants.largePadding * 1.5);
    }
  }

  // Get responsive grid cross axis count
  static int getResponsiveGridCrossAxisCount(BuildContext context) {
    if (isMobile(context)) {
      return 2;
    } else if (isTablet(context)) {
      return 3;
    } else {
      return 4;
    }
  }

  // Debounce function
  static void debounce(Function function, Duration delay) {
    Timer(delay, () => function());
  }

  // Throttle function
  static void throttle(Function function, Duration delay) {
    Timer(delay, () => function());
  }
}

// Extension for String
extension StringExtension on String {
  String get capitalizeFirst => AppHelpers.capitalizeFirst(this);
  String get capitalizeWords => AppHelpers.capitalizeWords(this);
  String truncate(int maxLength) => AppHelpers.truncateText(this, maxLength);
  bool get isValidEmail => AppHelpers.isValidEmail(this);
  bool get isValidPhoneNumber => AppHelpers.isValidPhoneNumber(this);
  bool get isValidPassword => AppHelpers.isValidPassword(this);
  bool get isValidName => AppHelpers.isValidName(this);
}

// Extension for double
extension DoubleExtension on double {
  String get currency => AppHelpers.formatCurrency(this);
  double get tax => AppHelpers.calculateTax(this);
  double get totalWithTax => AppHelpers.calculateTotalWithTax(this);
}

// Extension for DateTime
extension DateTimeExtension on DateTime {
  String get formattedDate => AppHelpers.formatDate(this);
  String get formattedDateTime => AppHelpers.formatDateTime(this);
  String get relativeTime => AppHelpers.formatRelativeTime(this);
}
