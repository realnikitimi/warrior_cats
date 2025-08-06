class Endpoints {
  late String origin;

  Endpoints({required this.origin});

  factory Endpoints.from(String origin) {
    String finalOrigin = '$origin/api/v1/';
    return Endpoints(origin: finalOrigin);
  }

  String changeFrame() {
    return '${origin}change-frame/';
  }

  String outputFile() {
    return '${origin}output-file/';
  }

  String frameList() {
    return '${origin}frame-list/';
  }
}
