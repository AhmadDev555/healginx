import 'package:intl/intl.dart';

extension TimeFormatExtension on String {
  String to12HourFormat() {
    try {
      final parts = split(":");
      if (parts.length != 2) return this;

      final int hour = int.parse(parts[0]);
      final int minute = int.parse(parts[1]);

      final suffix = hour >= 12 ? "PM" : "AM";
      final adjustedHour = hour % 12 == 0 ? 12 : hour % 12;

      return "$adjustedHour:${minute.toString().padLeft(2, '0')} $suffix";
    } catch (_) {
      return this; // return original if parsing fails
    }
  }
}


extension DateTimeExtension on DateTime {
  /// Returns a string representing the time difference from now
  /// Examples: "just now", "2 minutes ago", "3 hours ago", "5 days ago", "2 weeks ago", "3 months ago", "1 year ago"
  String timeAgo() {
    final now = DateTime.now();
    final difference = now.difference(this);

    // Handle future dates (just in case)
    if (difference.isNegative) {
      return "in the future";
    }

    // Less than 10 seconds
    if (difference.inSeconds < 10) {
      return "just now";
    }
    // Less than 60 seconds
    else if (difference.inSeconds < 60) {
      return "${difference.inSeconds} seconds ago";
    }
    // Less than 60 minutes
    else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago";
    }
    // Less than 24 hours
    else if (difference.inHours < 24) {
      return "${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago";
    }
    // Less than 7 days
    else if (difference.inDays < 7) {
      return "${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago";
    }
    // Less than 30 days
    else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return "$weeks ${weeks == 1 ? 'week' : 'weeks'} ago";
    }
    // Less than 365 days
    else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return "$months ${months == 1 ? 'month' : 'months'} ago";
    }
    // More than a year
    else {
      final years = (difference.inDays / 365).floor();
      return "$years ${years == 1 ? 'year' : 'years'} ago";
    }
  }

  /// Returns a formatted date string based on how recent it is
  /// Examples:
  /// - Today: "10:30 AM"
  /// - Yesterday: "Yesterday, 10:30 AM"
  /// - This week: "Monday, 10:30 AM"
  /// - Older: "Dec 15, 2025"
  String toSmartDate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCompare = DateTime(this.year, this.month, this.day);

    if (dateToCompare == today) {
      // Today: show time only
      return DateFormat.jm().format(this); // e.g., "10:30 AM"
    } else if (dateToCompare == yesterday) {
      // Yesterday: show "Yesterday" + time
      return "Yesterday, ${DateFormat.jm().format(this)}";
    } else if (now.difference(this).inDays < 7) {
      // Within last 7 days: show weekday + time
      return "${DateFormat.EEEE().format(this)}, ${DateFormat.jm().format(this)}";
    } else if (now.difference(this).inDays < 365) {
      // Within last year: show month, day + time
      return "${DateFormat.MMMd().format(this)}, ${DateFormat.jm().format(this)}"; // e.g., "Dec 15, 10:30 AM"
    } else {
      // Older than a year: show full date
      return DateFormat.yMMMd().format(this); // e.g., "Dec 15, 2025"
    }
  }

  /// Check if the date is from today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if the date is from yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }
}

extension IsoDateExtension on String {
  String toDDMMYYYY() {
    try {
      final dateTime = DateTime.parse(this);
      return DateFormat("dd-MM-yyyy").format(dateTime);
    } catch (_) {
      return this;
    }
  }
}

extension CustomDateParser on String {
  String toIso8601Format() {
    try {
      final parsedDate = DateFormat('dd-MM-yyyy').parse(this);
      return parsedDate.toIso8601String();
    } catch (e) {
      return this; // fallback if invalid
    }
  }
}