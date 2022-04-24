class Doctor {
  final String name;
  final String email;
  final String mobileNo;
  final String institution;
 // final List<dynamic> specialization;
  final String designation;
  final String registrationNo;
  final String referrer;
  final String image;
  final String password;

  Doctor(
      {this.name,
      this.email,
      this.mobileNo,
      this.institution,
      //this.specialization,
      this.designation,
      this.registrationNo,
      this.referrer,
      this.image,
      this.password});

  Doctor.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        mobileNo = json['mobile_no'],
        email = json['email'],
        designation = json['designation'],
        institution = json['institution'],
        //specialization = json['specialization'],
        referrer = json['referrer'],
        password=json['password'],
        image = json['image'],
        registrationNo = json['reg_number'];
  Map<String, dynamic> toJson() => {
    'name': name,
    'mobile_no': mobileNo,
    'password': password,
     'email':email,
     'designation':designation,
    'institution':institution,
    'referrer':referrer,
    'image':image,
    'reg_number':registrationNo
  };
}
