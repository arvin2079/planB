import 'package:planb/src/model/project_model.dart';
import 'package:planb/src/model/user_model.dart';

class Cooperation {
  int id;
  String situation;
  User user;
  Project project;

  Cooperation({this.id, this.situation, this.user, this.project});

  factory Cooperation.fromJson(Map<String, dynamic> map) {
    return Cooperation(
      id: map['id'],
      situation: map['Situation'],
      user: User.fromJson(map['user_ser']),
      project: Project.fromJson(map['project']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['id'] = this.id;
    data['Situation'] = this.situation;
    data['user_ser'] = this.user.toJson();
    data['project'] = this.project.toJson();

    return data;
  }

  @override
  String toString() {
    return 'Cooperation{id: $id, situation: $situation, user: $user, project: $project}';
  }
}
