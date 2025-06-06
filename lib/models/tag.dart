class Tag {
  final int id;
  final String description;
  final String name;
  final String? color;

  const Tag(
      {required this.id,
      required this.description,
      required this.name,
      this.color});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
        id: json['id'],
        description: json['description'],
        name: json['name'],
        color: json['color']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'description': description, 'color': color};
  }
}

// class TagRepository {
//   final List<Tag> _tags;
//   late final Map<int, Tag> _tagsById;
//   late final Map<String, Tag> _tagsByName;
//
//   TagRepository(this._tags) {
//     _tagsById = {for (var tag in _tags) tag.id: tag};
//     _tagsByName = {for (var tag in _tags) tag.name: tag};
//   }
//
//   Tag? getById(int id) => _tagsById[id];
//   Tag? getByName(String name) => _tagsByName[name];
//   List<Tag> getAll() => _tags;
// }
// final tagRepo = TagRepository(tags);
// final workTag = tagRepo.getByName('Work');
