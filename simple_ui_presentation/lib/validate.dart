bool validateEmailAddress(String email) {
  // Simple regex pattern for basic email validation
  final RegExp emailRegex = RegExp(r'^[\w-]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(email);
}
