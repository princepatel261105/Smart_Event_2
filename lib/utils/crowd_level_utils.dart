import 'package:flutter/material.dart';

class CrowdLevelUtils {
  static String getCrowdLevel(int checkedIn, int maxCapacity) {
    final percentage = (checkedIn / maxCapacity) * 100;

    if (percentage == 0) {
      return 'Empty';
    } else if (percentage <= 50) {
      return 'Safe';
    } else if (percentage <= 80) {
      return 'Moderate';
    } else if (percentage < 100) {
      return 'Crowded';
    } else {
      return 'Full';
    }
  }

  static Color getCrowdLevelColor(int checkedIn, int maxCapacity) {
    final percentage = (checkedIn / maxCapacity) * 100;

    if (percentage == 0) {
      return Colors.grey[300]!;
    } else if (percentage <= 50) {
      return Colors.green;
    } else if (percentage <= 80) {
      return Colors.orange;
    } else if (percentage < 100) {
      return Colors.deepOrange;
    } else {
      return Colors.red;
    }
  }

  static String getCrowdIcon(int checkedIn, int maxCapacity) {
    final percentage = (checkedIn / maxCapacity) * 100;

    if (percentage == 0) {
      return '⭕';
    } else if (percentage <= 50) {
      return '🟢';
    } else if (percentage <= 80) {
      return '🟡';
    } else if (percentage < 100) {
      return '🟠';
    } else {
      return '🔴';
    }
  }

  static double getCrowdPercentage(int checkedIn, int maxCapacity) {
    if (maxCapacity == 0) return 0;
    final percentage = (checkedIn / maxCapacity) * 100;
    return percentage > 100 ? 100 : percentage;
  }
}
