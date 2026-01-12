class RepresentativeModel {
  final String id;
  final String email;
  final String nameAr;
  final String phone;

  RepresentativeModel({
    required this.id,
    required this.email,
    required this.nameAr,
    required this.phone,
  });

  factory RepresentativeModel.fromMap(
    Map<String, dynamic> map,
    String docId,
  ) {
    return RepresentativeModel(
      id: docId,
      email: map['email'],
      nameAr: map['nameAr'],
      phone: map['phone'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'nameAr': nameAr,
      'phone': phone,
    };
  }
}
