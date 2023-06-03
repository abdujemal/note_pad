
class Note {
  int? id;
  String title;
  String? description;
  String date;
  int priority;

  Note(this.title, this.date, this.priority, [this.description]);

  Note.withId(
    this.title,
    this.date,
    this.priority, [
    this.description,
    this.id,
  ]);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['title'] = title;
    map['description'] = description;
    map['priority'] = priority;
    map['date'] = date;
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  Note.fromMapToObject(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        description = map['description'],
        priority = map['priority'],
        date = map['date'];
}
