class TodoModel {
  final String title;
  final String color;
  final int? id;

  TodoModel({
    this.id,
    required this.color,
    required this.title,
  });

  TodoModel copyWith({String? title, String? color, int? id}) {
    return TodoModel(
      id: id ?? this.id,
      color: color ?? this.color,
      title: title ?? this.title,
    );
  }

  static TodoModel initialValue = TodoModel(color: "", title: "");

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      color: json["color"] as String? ?? "",
      id: json["_id"],
      title: json["title"] as String? ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {"title": title, "color": color};
  }
}
