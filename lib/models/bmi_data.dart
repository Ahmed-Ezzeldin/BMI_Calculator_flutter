class BmiData {
  int _id;
  String _bmi;
  String _title;
  String _description;
  String _height;
  String _weight;
  String _age;
  String _gender;
  String _date;

  BmiData(
    this._bmi,
    this._title,
    this._description,
    this._height,
    this._weight,
    this._age,
    this._gender,
    this._date,
  );

  int get id => _id;
  String get bmi => _bmi;
  String get title => _title;
  String get description => _description;
  String get height => _height;
  String get weight => _weight;
  String get age => _age;
  String get gender => _gender;
  String get date => _date;

  set bmi(String value) {
    if (value.length < 255) {
      _bmi = value;
    }
  }

  set title(String value) {
    if (value.length < 255) {
      _title = value;
    }
  }

  set description(String value) {
    if (value.length < 255) {
      _description = value;
    }
  }

  set height(String value) {
    if (value.length < 255) {
      _height = value;
    }
  }

  set weight(String value) {
    if (value.length < 255) {
      _weight = value;
    }
  }

  set age(String value) {
    if (value.length < 255) {
      _age = value;
    }
  }

  set gender(String value) {
    if (value.length < 255) {
      _gender = value;
    }
  }

  set date(String value) {
    if (value.length < 255) {
      _date = value;
    }
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = this._id;
    map['bmi'] = this._bmi;
    map['title'] = this._title;
    map['description'] = this._description;
    map['height'] = this._height;
    map['weight'] = this._weight;
    map['age'] = this._age;
    map['gender'] = this._gender;
    map['date'] = this._date;

    return map;
  }

  BmiData.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._bmi = map['bmi'];
    this._title = map['title'];
    this._description = map['description'];
    this._height = map['height'];
    this._weight = map['weight'];
    this._age = map['age'];
    this._gender = map['gender'];
    this._date = map['date'];
  }
}
