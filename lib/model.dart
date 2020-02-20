import 'package:flutter/material.dart';

class Mentee {
  var id = "";
  var lastName = "";
  var firstName = "";
  var cellPhone = "";
  var email = "";
  var activityLog = List<ActivityRecord>();
  var hasFlag = false;

  Mentee(this.id, this.lastName, this.firstName, this.cellPhone, this.email,
      this.activityLog, [this.hasFlag = false]);

  String getField(String fieldName) {
    switch (fieldName){
      case "firstName":
        return firstName;
      case "lastName":
        return lastName;
      case "cellPhone":
        return cellPhone;
      case "email":
        return email;
      default:
        return null;
    }
  }
}

class ActivityRecord {
  String id = _nextId();
  String menteeId;
  DateTime date = DateTime.now();
  int minutesSpent = 30;
  String notes = "";
  bool hasFlag = false;

  ActivityRecord(
      this.id, this.menteeId, this.date, this.minutesSpent, this.notes, [this.hasFlag = false]);

  ActivityRecord.forMentee(String menteeId) : this.menteeId = menteeId;
}

class MenteeModel extends ChangeNotifier {
  var _mentees = <Mentee>[
    Mentee("1", "Doe", "John", "801-555-1212",
        "email@example.com", <ActivityRecord>[
          ActivityRecord("1", "1", DateTime.parse("2020-01-07 12:18:04Z"), 31,
              "John needs to learn some manners"),
          ActivityRecord("2", "1", DateTime.parse("2020-01-08 13:28:14Z"), 15,
              "John thinks the world is his"),
          ActivityRecord("3", "1", DateTime.parse("2020-01-09 14:38:24Z"), 33,
              "I reviewed his resume today"),
          ActivityRecord("4", "1", DateTime.parse("2020-01-10 15:48:34Z"), 45,
              "I want a new mentee", true),
          ActivityRecord("5", "1", DateTime.parse("2020-01-11 16:58:44Z"), 22,
              "I'm so done with John"),
        ]),
    Mentee("2", "Roe", "Mary", "801-555-1212",
        "email@example.com", <ActivityRecord>[
          ActivityRecord("6", "2", DateTime.parse("2020-01-02 08:18:04Z"), 5,
              "Very productive meeting"),
          ActivityRecord("7", "2", DateTime.parse("2020-01-03 09:19:06Z"), 15,
              "Best mentee ever!"),
          ActivityRecord("8", "2", DateTime.parse("2020-01-04 10:20:09Z"), 30,
              "Need to get in touch with relevant members", true),
        ]),
  ];

  get mentees => _mentees;
  get activityRecords => _mentees
      .map((mentee) => mentee.activityLog)
      .reduce((value, element) => value + element);

  Mentee menteeForMenteeId(String menteeId) {
    return _mentees.firstWhere((mentee) => mentee.id == menteeId);
  }

  List<ActivityRecord> activityRecordsForMenteeId(String menteeId) {
    return _mentees.firstWhere((mentee) => mentee.id == menteeId).activityLog;
  }

  void addMentee(Mentee mentee) {
    mentee.id = _nextId();
    _mentees.add(mentee);
    notifyListeners();
  }

  void addActivityRecordForMentee(String menteeId, ActivityRecord record) {
    _mentees
        .firstWhere((mentee) => mentee.id == menteeId)
        .activityLog
        .add(record);
    notifyListeners();
  }

  void editMentee(Mentee mentee) {
    var editedMentee = _mentees.firstWhere((m) => m.id == mentee.id);
    if (editedMentee != null) {
      editedMentee.firstName = mentee.firstName;
      editedMentee.lastName = mentee.lastName;
      editedMentee.cellPhone = mentee.cellPhone;
      editedMentee.email = mentee.email;
    }
    notifyListeners();
  }

  void deleteMentee(Mentee mentee){
    _mentees.removeWhere((m) => m.id == mentee.id);
    notifyListeners();
  }

  void deleteActivityRecord(String menteeId, String recordId) {
    var editedMentee = _mentees.firstWhere((m) => m.id == menteeId);
    if (editedMentee != null){
      editedMentee.activityLog.removeWhere((record) => record.id == recordId);
    }
    notifyListeners();
  }

  void setFlagMentee(Mentee mentee) {
    var editedMentee = _mentees.firstWhere((m) => m.id == mentee.id);
    if (editedMentee != null) {
      if(editedMentee.hasFlag) {
        editedMentee.hasFlag = false;
      } else {
        editedMentee.hasFlag = true;
      }
    }
    notifyListeners();
  }

  void setFlagRecord(String recordId) {
    var allRecords = _mentees.map((mentee) => mentee.activityLog).reduce((value, element) => value + element);
    var recordToEdit = allRecords.firstWhere((record) => record.id == recordId);
    if (recordToEdit != null) {
      if(recordToEdit.hasFlag) {
        recordToEdit.hasFlag = false;
      } else {
        recordToEdit.hasFlag = true;
      }
    }
    notifyListeners();
  }

// static ActivityRecord getSingleRecord(String recordId) {
//   var allRecords = _mentees.map((mentee) => mentee.activityLog).reduce((value, element) => value + element);
//   var result = allRecords.firstWhere((record) => record.id == recordId);
//   return result;
// }

}

class ActivityRecordModel extends ChangeNotifier {

}

// use the following code to avoid duplicate id -> bad practice, just a bandage for this app
int _nextIdValue = 8;
String _nextId() {
  _nextIdValue += 1;

  return _nextIdValue.toString();
}
