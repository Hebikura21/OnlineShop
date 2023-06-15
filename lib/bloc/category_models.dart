class Category {
  final int id;
  final String name;
  final String status;
  final String? createAt;
  final String? updateAt;

  Category({
    required this.id,
    required this.name,
    required this.status,
    this.createAt,
    this.updateAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] != null ? json['id'] as int : 0,
      name: json['name'] != null ? json['name'] as String : '',
      status: json['status'] != null ? json['status'] as String : '',
      createAt: json['create_at'] != null ? json['create_at'] as String : null,
      updateAt: json['update_at'] != null ? json['update_at'] as String : null,
    );
  }
}
