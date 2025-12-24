class ProfileModel {
  final String name;
  final String email;
  final String phone;
  final String location;
  final String workingHours;
  final String completedTasks;

  ProfileModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.workingHours,
    required this.completedTasks,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) { // غيرنا الاسم هنا
    return ProfileModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      location: json['location'] ?? '',
      workingHours: json['workingHours'] ?? '0',
      completedTasks: json['completedTasks'] ?? '0',
    );
  }
}