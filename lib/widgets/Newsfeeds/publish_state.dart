import 'package:rxdart/rxdart.dart';
import 'package:multipart_request/multipart_request.dart' as mp;

class HomepageRefreshState {
  PublishSubject<bool>? _subjectSelect;
  static HomepageRefreshState? _selectBloc;
  bool? _refresh;
  bool? _hideNavbar;
  bool? _refreshStory;
  bool? _refreshShortbuz;

  factory HomepageRefreshState() {
    if (_selectBloc == null) _selectBloc = new HomepageRefreshState._();
    return _selectBloc!;
  }

  HomepageRefreshState._() {
    _refresh = false;
    _hideNavbar = false;
    _refreshStory = false;
    _refreshShortbuz = false;
    _subjectSelect = new PublishSubject<bool>();
  }

  bool get currentSelect => _refresh!;

  bool get currentNavbarState => _hideNavbar!;

  bool get currentRefreshStoryState => _refreshStory!;

  Stream get observableCart => _subjectSelect!.stream;

  void updateRefresh(val) {
    _refresh = val;
    _subjectSelect!.sink.add(_refresh!);
  }

  void updateNavbar(val) {
    _hideNavbar = val;
    _subjectSelect!.sink.add(_hideNavbar!);
  }

  void updateStoryRefresh(val) {
    _refreshStory = val;
    _subjectSelect!.sink.add(_refreshStory!);
  }

  void updateShortbuzRefresh(val) {
    _refreshShortbuz = val;
    _subjectSelect!.sink.add(_refreshShortbuz!);
  }

  dispose() {
    _subjectSelect!.close();
  }
}

class RefreshProfile {
  PublishSubject<bool>? _subjectSelect;
  static RefreshProfile? _selectBloc;
  bool? _refresh;

  factory RefreshProfile() {
    if (_selectBloc == null) _selectBloc = new RefreshProfile._();
    return _selectBloc!;
  }

  RefreshProfile._() {
    _refresh = false;
    _subjectSelect = new PublishSubject<bool>();
  }

  bool get currentSelect => _refresh!;

  Stream<bool> get observableCart => _subjectSelect!.stream;

  void updateRefresh(val) {
    _refresh = val;
    _subjectSelect!.sink.add(_refresh!);
  }

  dispose() {
    _subjectSelect!.close();
  }
}

class RefreshShortbuz {
  PublishSubject<bool>? _subjectSelect;
  static RefreshShortbuz? _selectBloc;
  bool? _refresh;

  factory RefreshShortbuz() {
    if (_selectBloc == null) _selectBloc = new RefreshShortbuz._();
    return _selectBloc!;
  }

  RefreshShortbuz._() {
    _refresh = false;
    _subjectSelect = new PublishSubject<bool>();
  }

  bool get currentSelect => _refresh!;

  Stream<bool> get observableCart => _subjectSelect!.stream;

  void updateRefresh(val) {
    _refresh = val;
    _subjectSelect!.sink.add(_refresh!);
  }

  dispose() {
    _subjectSelect!.close();
  }
}

class RefreshMainVideo {
  PublishSubject<bool>? _subjectSelect;
  static RefreshMainVideo? _selectBloc;
  bool? _refresh;

  factory RefreshMainVideo() {
    if (_selectBloc == null) _selectBloc = new RefreshMainVideo._();
    return _selectBloc!;
  }

  RefreshMainVideo._() {
    _refresh = false;
    _subjectSelect = new PublishSubject<bool>();
  }

  bool get currentSelect => _refresh!;

  Stream<bool> get observableCart => _subjectSelect!.stream;

  void updateRefresh(val) {
    _refresh = val;
    _subjectSelect!.sink.add(_refresh!);
  }

  dispose() {
    _subjectSelect!.close();
  }
}

class RefreshPostContent {
  PublishSubject<bool>? _subjectSelect;
  static RefreshPostContent? _selectBloc;
  bool? _refresh;

  factory RefreshPostContent() {
    if (_selectBloc == null) _selectBloc = new RefreshPostContent._();
    return _selectBloc!;
  }

  RefreshPostContent._() {
    _refresh = false;
    _subjectSelect = new PublishSubject<bool>();
  }

  bool get currentSelect => _refresh!;

  Stream<bool> get observableCart => _subjectSelect!.stream;

  void updatePost(val) {
    _refresh = val;
    _subjectSelect!.sink.add(_refresh!);
  }

  dispose() {
    _subjectSelect!.close();
  }
}
