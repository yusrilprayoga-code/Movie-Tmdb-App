class Credits {
  int? id;
  List<Cast>? cast;
  List<Crew>? crew;

  Credits({this.id, this.cast, this.crew});

  Credits.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['cast'] != null) {
      cast = [];
      json['cast'].forEach((v) {
        cast?.add(new Cast.fromJson(v));
      });
    }
    if (json['crew'] != null) {
      crew = [];
      json['crew'].forEach((v) {
        crew?.add(new Crew.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.cast != null) {
      data['cast'] = this.cast?.map((v) => v.toJson()).toList();
    }
    if (this.crew != null) {
      data['crew'] = this.crew?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cast {
  int? castId;
  String? character;
  String? creditId;
  int? gender;
  int? id;
  String? name;
  int? order;
  String? profilePath;

  Cast(
      {this.castId,
      this.character,
      this.creditId,
      this.gender,
      this.id,
      this.name,
      this.order,
      this.profilePath});

  Cast.fromJson(Map<String, dynamic> json) {
    castId = json['cast_id'] as int?;
    character = json['character'] as String?;
    creditId = json['credit_id'] as String?;
    gender = json['gender'] as int?;
    id = json['id'] as int?;
    name = json['name'] as String?;
    order = json['order'] as int?;
    profilePath = json['profile_path'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cast_id'] = this.castId as int?;
    data['character'] = this.character as String?;
    data['credit_id'] = this.creditId as String?;
    data['gender'] = this.gender as int?;
    data['id'] = this.id as int?;
    data['name'] = this.name as String?;
    data['order'] = this.order as int?;
    data['profile_path'] = this.profilePath as String?;
    return data;
  }
}

class Crew {
  String? creditId;
  String? department;
  int? gender;
  int? id;
  String? job;
  String? name;
  String? profilePath;

  Crew(
      {this.creditId,
      this.department,
      this.gender,
      this.id,
      this.job,
      this.name,
      this.profilePath});

  Crew.fromJson(Map<String, dynamic> json) {
    creditId = json['credit_id'] as String?;
    department = json['department'] as String?;
    gender = json['gender'] as int?;
    id = json['id'] as int?;
    job = json['job'] as String?;
    name = json['name'] as String?;
    profilePath = json['profile_path'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['credit_id'] = this.creditId as String?;
    data['department'] = this.department as String?;
    data['gender'] = this.gender as int?;
    data['id'] = this.id as int?;
    data['job'] = this.job as String?;
    data['name'] = this.name as String?;
    data['profile_path'] = this.profilePath as String?;
    return data;
  }
}
