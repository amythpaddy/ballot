class QuestionData {
  String _question;
  List _optionList;
  String _id;
  List _optionVots;
  int _totalVotes;

  QuestionData() {
    _question = "";
    _optionList = new List();
    this._optionVots = new List();
    _id = "";
  }

  void updateData(Map data) {
    this._question = data["question"];
    this._optionList.add(data["option1"]);
    this._optionList.add(data["option2"]);
    this._optionList.add(data["option3"]);
    this._optionList.add(data["option4"]);
    this._id = data["questionid"];

//    print(_id);
  }

  String get id => _id;
  List get optionList => _optionList;
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
}
