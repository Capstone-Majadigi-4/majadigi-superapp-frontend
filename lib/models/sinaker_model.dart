class JobVacancy {
  final String id;
  final String title;
  final String company;
  final String location;
  final String salary;
  final String type;
  final String posted;
  final String match;
  final String? description;
  final List<String>? requirements;

  JobVacancy({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.type,
    required this.posted,
    required this.match,
    this.description,
    this.requirements,
  });

  factory JobVacancy.fromJson(Map<String, dynamic> json) {
    return JobVacancy(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      company: json['company']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      salary: json['salary']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      posted: json['posted']?.toString() ?? '',
      match: json['match']?.toString() ?? '',
      description: json['description']?.toString(),
      requirements: json['requirements'] is List
          ? List<String>.from(json['requirements'] as List)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'location': location,
      'salary': salary,
      'type': type,
      'posted': posted,
      'match': match,
      'description': description,
      'requirements': requirements,
    };
  }
}

class JobApplication {
  final String id;
  final String title;
  final String company;
  final String date;
  final String status;
  final String? statusColor;
  final String? statusTextColor;

  JobApplication({
    required this.id,
    required this.title,
    required this.company,
    required this.date,
    required this.status,
    this.statusColor,
    this.statusTextColor,
  });

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      company: json['company']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      statusColor: json['status_color']?.toString(),
      statusTextColor: json['status_text_color']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'date': date,
      'status': status,
      'status_color': statusColor,
      'status_text_color': statusTextColor,
    };
  }
}

class SinakerProfile {
  final String education;
  final List<String> skills;
  final String experience;

  SinakerProfile({
    required this.education,
    required this.skills,
    required this.experience,
  });

  factory SinakerProfile.fromJson(Map<String, dynamic> json) {
    return SinakerProfile(
      education: json['education']?.toString() ?? '',
      skills: json['skills'] is List
          ? List<String>.from(json['skills'] as List)
          : [],
      experience: json['experience']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'education': education,
      'skills': skills,
      'experience': experience,
    };
  }
}
