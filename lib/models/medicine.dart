class Medicine {
  final String name;
  final String dose;
  final String days;

  Medicine({this.name, this.days, this.dose});

  Medicine.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        dose = json['dose'],
        days = json['day'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'dose': dose,
        'day': days,
      };
}
