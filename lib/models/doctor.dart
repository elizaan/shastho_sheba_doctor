class Doctor {
  final String name;
  final String email;
  final String mobileNo;
  final String institution;
  final List<dynamic> specialization;
  final String designation;
  final String registrationNo;
  final String referrer;
  final String image;

  Doctor(
      {this.name,
      this.email,
      this.mobileNo,
      this.institution,
      this.specialization,
      this.designation,
      this.registrationNo,
      this.referrer,
      this.image});

  Doctor.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        mobileNo = json['mobile_no'],
        email = json['email'],
        designation = json['designation'],
        institution = json['institution'],
        specialization = json['specialization'],
        referrer = json['referrer'],
        image = json['image'],
        registrationNo = json['reg_number'];
}
