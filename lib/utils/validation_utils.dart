class ValidationUtils {
  static bool isValidParticipantId(String participantId) {
    if (participantId.isEmpty) return false;
    if (participantId.length < 2) return false;
    return RegExp(r'^[a-zA-Z0-9_\-]+$').hasMatch(participantId);
  }

  static bool isValidEventName(String eventName) {
    return eventName.isNotEmpty && eventName.length >= 3;
  }

  static bool isValidEmail(String email) {
    if (email.isEmpty) return true; // Optional field
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  static bool isValidPhone(String phone) {
    if (phone.isEmpty) return true; // Optional field
    return RegExp(r'^[0-9+\-\s()]+$').hasMatch(phone) && phone.length >= 10;
  }

  static String? validateParticipantId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Participant ID is required';
    }
    if (!isValidParticipantId(value)) {
      return 'Invalid Participant ID format';
    }
    return null;
  }

  static String? validateEventName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Event name is required';
    }
    if (!isValidEventName(value)) {
      return 'Event name must be at least 3 characters';
    }
    return null;
  }

  static String? validateCapacity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Capacity is required';
    }
    try {
      final capacity = int.parse(value);
      if (capacity <= 0) {
        return 'Capacity must be greater than 0';
      }
      if (capacity > 100000) {
        return 'Capacity cannot exceed 100,000';
      }
      return null;
    } catch (e) {
      return 'Invalid capacity';
    }
  }
}
