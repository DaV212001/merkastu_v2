class ErrorData {
  String title;
  String body;
  String image;
  String? buttonText;

  ErrorData(
      {required this.title,
      required this.body,
      required this.image,
      this.buttonText});
}
