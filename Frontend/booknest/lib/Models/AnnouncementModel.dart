/// announcementId : 1
/// message : "qqqqqqqq"
/// title : "eeeeeeee"
/// photo : "rrrrrr"
/// startDate : "2023-02-01T18:15:00Z"
/// endDate : "2024-02-02T18:15:00Z"

class AnnouncementModel {
  AnnouncementModel({
      num? announcementId, 
      String? message, 
      String? title, 
      String? photo, 
      String? startDate, 
      String? endDate,}){
    _announcementId = announcementId;
    _message = message;
    _title = title;
    _photo = photo;
    _startDate = startDate;
    _endDate = endDate;
}

  AnnouncementModel.fromJson(dynamic json) {
    _announcementId = json['announcementId'];
    _message = json['message'];
    _title = json['title'];
    _photo = json['photo'];
    _startDate = json['startDate'];
    _endDate = json['endDate'];
  }
  num? _announcementId;
  String? _message;
  String? _title;
  String? _photo;
  String? _startDate;
  String? _endDate;
AnnouncementModel copyWith({  num? announcementId,
  String? message,
  String? title,
  String? photo,
  String? startDate,
  String? endDate,
}) => AnnouncementModel(  announcementId: announcementId ?? _announcementId,
  message: message ?? _message,
  title: title ?? _title,
  photo: photo ?? _photo,
  startDate: startDate ?? _startDate,
  endDate: endDate ?? _endDate,
);
  num? get announcementId => _announcementId;
  String? get message => _message;
  String? get title => _title;
  String? get photo => _photo;
  String? get startDate => _startDate;
  String? get endDate => _endDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['announcementId'] = _announcementId;
    map['message'] = _message;
    map['title'] = _title;
    map['photo'] = _photo;
    map['startDate'] = _startDate;
    map['endDate'] = _endDate;
    return map;
  }

}