class Repo {
  final String name;
  final String? language;

  Repo({required this.name, this.language});

  factory Repo.fromJson(Map<String, dynamic> json) {
    return Repo(
      name: json['name'],
      language: json['language'],
    );
  }
}