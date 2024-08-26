class Tag {
	final int id;
	final String description;
	final String name;
	final String? color;

	const Tag({
		required this.id,
		required this.description,
		required this.name,
		this.color
	});

	factory Tag.fromJson(Map<String, dynamic> json){
		return Tag(
			id: json['id'],
			description: json['description'],
			name: json['name'],
			color: null
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'id': id,
			'name': name,
			'description': description,
			'color': null
		};
	}

}
