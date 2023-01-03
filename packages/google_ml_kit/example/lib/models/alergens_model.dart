class AlergensModel {
  final List<String> alergens;

  AlergensModel({
    required this.alergens,
  });

  factory AlergensModel.fromJson(List<String> json) {
    return AlergensModel(
      alergens: json,
    );
  }
}
