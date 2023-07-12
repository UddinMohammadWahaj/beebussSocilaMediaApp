import 'package:rxdart/rxdart.dart';

class DirectRefresh {
  late PublishSubject<bool> _subjectSelect;
  static DirectRefresh? _selectBloc;
  late bool _refresh;

  factory DirectRefresh() {
    if (_selectBloc == null) _selectBloc = new DirectRefresh._();
    return _selectBloc!;
  }

  DirectRefresh._() {
    _refresh = false;

    _subjectSelect = new PublishSubject<bool>();
  }

  bool get currentSelect => _refresh;

  Stream<bool> get observableCart => _subjectSelect.stream;

  void updateRefresh(val) {
    _refresh = val;
    _subjectSelect.sink.add(_refresh);
  }

  dispose() {
    _subjectSelect.close();
  }
}

class DetailedDirectRefresh {
  late PublishSubject<bool> _subjectSelect;
  static DetailedDirectRefresh? _selectBloc;
  late bool _refresh;

  factory DetailedDirectRefresh() {
    if (_selectBloc == null) _selectBloc = new DetailedDirectRefresh._();
    return _selectBloc!;
  }

  DetailedDirectRefresh._() {
    _refresh = false;

    _subjectSelect = new PublishSubject<bool>();
  }

  bool get currentSelect => _refresh;

  Stream<bool> get observableCart => _subjectSelect.stream;

  void updateRefresh(val) {
    _refresh = val;
    _subjectSelect.sink.add(_refresh);
  }

  dispose() {
    _subjectSelect.close();
  }
}

class UpdateOnlineStatus {
  late PublishSubject<String> _subjectSelect;
  static late UpdateOnlineStatus _selectBloc;
  late String _status;

  factory UpdateOnlineStatus() {
    if (_selectBloc == null) _selectBloc = new UpdateOnlineStatus._();
    return _selectBloc;
  }

  UpdateOnlineStatus._() {
    _status = "";

    _subjectSelect = new PublishSubject<String>();
  }

  String get currentSelect => _status;

  Stream<String> get observableCart => _subjectSelect.stream;

  void updateRefresh(val) {
    _status = val;
    _subjectSelect.sink.add(_status);
  }

  dispose() {
    _subjectSelect.close();
  }
}

class UpdateTypingStatusGroup {
  late PublishSubject<String> _subjectSelect;
  static late UpdateTypingStatusGroup _selectBloc;
  late String _status;

  factory UpdateTypingStatusGroup() {
    if (_selectBloc == null) _selectBloc = new UpdateTypingStatusGroup._();
    return _selectBloc;
  }

  UpdateTypingStatusGroup._() {
    _status = "";

    _subjectSelect = new PublishSubject<String>();
  }

  String get currentSelect => _status;

  Stream<String> get observableCart => _subjectSelect.stream;

  void updateRefresh(val) {
    _status = val;
    _subjectSelect.sink.add(_status);
  }

  dispose() {
    _subjectSelect.close();
  }
}

class AboutRefresh {
  late PublishSubject<bool> _subjectSelect;
  static late AboutRefresh _selectBloc;
  late bool _refreshAbout;

  factory AboutRefresh() {
    if (_selectBloc == null) _selectBloc = new AboutRefresh._();
    return _selectBloc;
  }

  AboutRefresh._() {
    _refreshAbout = false;

    _subjectSelect = new PublishSubject<bool>();
  }

  bool get currentSelect => _refreshAbout;

  Stream<bool> get observableCart => _subjectSelect.stream;

  void updateRefresh(val) {
    _refreshAbout = val;
    _subjectSelect.sink.add(_refreshAbout);
  }

  dispose() {
    _subjectSelect.close();
  }
}

class ChatsRefresh {
  late PublishSubject<bool> _subjectSelect;
  static late ChatsRefresh _selectBloc;
  late bool _refresh;

  factory ChatsRefresh() {
    if (_selectBloc == null) _selectBloc = new ChatsRefresh._();
    return _selectBloc;
  }

  ChatsRefresh._() {
    _refresh = false;

    _subjectSelect = new PublishSubject<bool>();
  }

  bool get currentSelect => _refresh;

  Stream<bool> get observableCart => _subjectSelect.stream;

  void updateRefresh(val) {
    _refresh = val;
    _subjectSelect.sink.add(_refresh);
  }

  dispose() {
    _subjectSelect.close();
  }
}

class DetailedChatRefresh {
  late PublishSubject<bool> _subjectSelect;
  static late DetailedChatRefresh _selectBloc;
  late bool _refresh;

  factory DetailedChatRefresh() {
    if (_selectBloc == null) _selectBloc = new DetailedChatRefresh._();
    return _selectBloc;
  }

  DetailedChatRefresh._() {
    _refresh = false;

    _subjectSelect = new PublishSubject<bool>();
  }

  bool get currentSelect => _refresh;

  Stream<bool> get observableCart => _subjectSelect.stream;

  void updateRefresh(val) {
    _refresh = val;
    _subjectSelect.sink.add(_refresh);
  }

  dispose() {
    _subjectSelect.close();
  }
}

class StarredMessagesRefresh {
  late PublishSubject<bool> _subjectSelect;
  static late StarredMessagesRefresh _selectBloc;
  late bool _refresh;

  factory StarredMessagesRefresh() {
    if (_selectBloc == null) _selectBloc = new StarredMessagesRefresh._();
    return _selectBloc;
  }

  StarredMessagesRefresh._() {
    _refresh = false;

    _subjectSelect = new PublishSubject<bool>();
  }

  bool get currentSelect => _refresh;

  Stream<bool> get observableCart => _subjectSelect.stream;

  void updateRefresh(val) {
    _refresh = val;
    _subjectSelect.sink.add(_refresh);
  }

  dispose() {
    _subjectSelect.close();
  }
}

class ContactsRefresh {
  late PublishSubject<bool> _subjectSelect;
  static late ContactsRefresh _selectBloc;
  late bool _refresh;

  factory ContactsRefresh() {
    if (_selectBloc == null) _selectBloc = new ContactsRefresh._();
    return _selectBloc;
  }

  ContactsRefresh._() {
    _refresh = false;

    _subjectSelect = new PublishSubject<bool>();
  }

  bool get currentSelect => _refresh;

  Stream<bool> get observableCart => _subjectSelect.stream;

  void updateRefresh(val) {
    _refresh = val;
    _subjectSelect.sink.add(_refresh);
  }

  dispose() {
    _subjectSelect.close();
  }
}

class GroupMembersRefresh {
  late PublishSubject<bool> _subjectSelect;
  static late GroupMembersRefresh _selectBloc;
  late bool _refresh;

  factory GroupMembersRefresh() {
    if (_selectBloc == null) _selectBloc = new GroupMembersRefresh._();
    return _selectBloc;
  }

  GroupMembersRefresh._() {
    _refresh = false;

    _subjectSelect = new PublishSubject<bool>();
  }

  bool get currentSelect => _refresh;

  Stream<bool> get observableCart => _subjectSelect.stream;

  void updateRefresh(val) {
    _refresh = val;
    _subjectSelect.sink.add(_refresh);
  }

  dispose() {
    _subjectSelect.close();
  }
}
