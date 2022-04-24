class Medicine {
  final String name;
  final String dose;
  final String days;
  final String timing;

  Medicine({this.name, this.days, this.dose,this.timing});

  Medicine.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        dose = json['dose'],
        days = json['day'],
        timing= json['timing'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'dose': dose,
        'day': days,
        'timing':timing,
      };
}
