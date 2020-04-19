class QuestionData {
  String _question;
  String _option1;
  String _option2;
  String _option3;
  String _option4;
  String _id;
  List _optionVots;
  int _totalVotes;

  QuestionData() {
    _question = "";
    _option1 = '';
    _option2 = '';
    _option3 = '';
    _option4 = '';
    this._optionVots = new List();
    _id = "";
  }

  void updateData(Map data) {
    this._question = data["question"];
    _option1 = data["option1"];
    _option2 = data["option2"];
    _option3 = data["option3"];
    _option4 = data["option4"];
    this._id = data["questionid"];

//    print(_id);
  }

  String get id => _id;
  String get option1 => _option1;
  String get question => _question;

  void updateVoteData(Map data) {
    int temp = 0, votecount = 0;
    this._optionVots = new List();
    temp = data["option1_value"];
    votecount += temp;
    this._optionVots.add(temp);
    temp = data["option2_value"];
    votecount += temp;
    this._optionVots.add(temp);

    temp = data["option3_value"];
    votecount += temp;
    this._optionVots.add(temp);

    temp = data["option4_value"];
    votecount += temp;
    this._optionVots.add(temp);

    this._id = data["questionid"];
    this._totalVotes = votecount;
  }

  int get totalVotes => _totalVotes;

  List get optionVotes => _optionVots;

  String get option2 => _option2;

  String get option3 => _option3;

  String get option4 => _option4;
}
