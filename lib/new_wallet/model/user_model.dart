// class UserModel {
//   int _status;
//   List<Record>_record;

//   UserModel({int status, List<Record> record}) {
//     if (status != null) {
//       this._status = status;
//     }
//     if (record != null) {
//       this._record = record;
//     }
//   }

//   int get status => _status;
//   set status(int status) => _status = status;
//   List<Record> get record => _record;
//   set record(List<Record> record) => _record = record;

//   UserModel.fromJson(Map<String, dynamic> json) {
//     _status = json['status'];
//     if (json['record'] != null) {
//       _record = <Record>[];
//       json['record'].forEach((v) {
//         _record.add(new Record.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this._status;
//     if (this._record != null) {
//       data['record'] = this._record.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Record {
//   int _id;
//   String _name;
//   String _username;
//   String _accountType;
//   String _profileImage;
//   String _email;
//   Null _emailVerifiedAt;
//   String _password;
//   String _countryCode;
//   String _mobile;
//   String _gender;
//   String _birthdate;
//   String _relationshipStatus;
//   String _minimalFollowing;
//   String _homePicOfTheDay;
//   String _status;
//   int _verified;
//   String _accessStatus;
//   int _viewCount;
//   String _creator;
//   String _bio;
//   String _designation;
//   String _privateAccount;
//   String _directMessage;
//   int _profileCategoryId;
//   String _categoryDisplay;
//   String _contactDisplay;
//   Null _rememberToken;
//   String _deviceType;
//   String _firebaseToken;
//   String _tradesmenType;
//   String _activatedAt;
//   String _lastLoginAt;
//   String _createdAt;
//   String _updatedAt;
//   int _tradeSubscribe;
//   Null _tradeStartDate;
//   Null _subscriptionId;

//   Record(
//       {int id,
//         String name,
//         String username,
//         String accountType,
//         String profileImage,
//         String email,
//         Null emailVerifiedAt,
//         String password,
//         String countryCode,
//         String mobile,
//         String gender,
//         String birthdate,
//         String relationshipStatus,
//         String minimalFollowing,
//         String homePicOfTheDay,
//         String status,
//         int verified,
//         String accessStatus,
//         int viewCount,
//         String creator,
//         String bio,
//         String designation,
//         String privateAccount,
//         String directMessage,
//         int profileCategoryId,
//         String categoryDisplay,
//         String contactDisplay,
//         Null rememberToken,
//         String deviceType,
//         String firebaseToken,
//         String tradesmenType,
//         String activatedAt,
//         String lastLoginAt,
//         String createdAt,
//         String updatedAt,
//         int tradeSubscribe,
//         Null tradeStartDate,
//         Null subscriptionId}) {
//     if (id != null) {
//       this._id = id;
//     }
//     if (name != null) {
//       this._name = name;
//     }
//     if (username != null) {
//       this._username = username;
//     }
//     if (accountType != null) {
//       this._accountType = accountType;
//     }
//     if (profileImage != null) {
//       this._profileImage = profileImage;
//     }
//     if (email != null) {
//       this._email = email;
//     }
//     if (emailVerifiedAt != null) {
//       this._emailVerifiedAt = emailVerifiedAt;
//     }
//     if (password != null) {
//       this._password = password;
//     }
//     if (countryCode != null) {
//       this._countryCode = countryCode;
//     }
//     if (mobile != null) {
//       this._mobile = mobile;
//     }
//     if (gender != null) {
//       this._gender = gender;
//     }
//     if (birthdate != null) {
//       this._birthdate = birthdate;
//     }
//     if (relationshipStatus != null) {
//       this._relationshipStatus = relationshipStatus;
//     }
//     if (minimalFollowing != null) {
//       this._minimalFollowing = minimalFollowing;
//     }
//     if (homePicOfTheDay != null) {
//       this._homePicOfTheDay = homePicOfTheDay;
//     }
//     if (status != null) {
//       this._status = status;
//     }
//     if (verified != null) {
//       this._verified = verified;
//     }
//     if (accessStatus != null) {
//       this._accessStatus = accessStatus;
//     }
//     if (viewCount != null) {
//       this._viewCount = viewCount;
//     }
//     if (creator != null) {
//       this._creator = creator;
//     }
//     if (bio != null) {
//       this._bio = bio;
//     }
//     if (designation != null) {
//       this._designation = designation;
//     }
//     if (privateAccount != null) {
//       this._privateAccount = privateAccount;
//     }
//     if (directMessage != null) {
//       this._directMessage = directMessage;
//     }
//     if (profileCategoryId != null) {
//       this._profileCategoryId = profileCategoryId;
//     }
//     if (categoryDisplay != null) {
//       this._categoryDisplay = categoryDisplay;
//     }
//     if (contactDisplay != null) {
//       this._contactDisplay = contactDisplay;
//     }
//     if (rememberToken != null) {
//       this._rememberToken = rememberToken;
//     }
//     if (deviceType != null) {
//       this._deviceType = deviceType;
//     }
//     if (firebaseToken != null) {
//       this._firebaseToken = firebaseToken;
//     }
//     if (tradesmenType != null) {
//       this._tradesmenType = tradesmenType;
//     }
//     if (activatedAt != null) {
//       this._activatedAt = activatedAt;
//     }
//     if (lastLoginAt != null) {
//       this._lastLoginAt = lastLoginAt;
//     }
//     if (createdAt != null) {
//       this._createdAt = createdAt;
//     }
//     if (updatedAt != null) {
//       this._updatedAt = updatedAt;
//     }
//     if (tradeSubscribe != null) {
//       this._tradeSubscribe = tradeSubscribe;
//     }
//     if (tradeStartDate != null) {
//       this._tradeStartDate = tradeStartDate;
//     }
//     if (subscriptionId != null) {
//       this._subscriptionId = subscriptionId;
//     }
//   }

//   int get id => _id;
//   set id(int id) => _id = id;
//   String get name => _name;
//   set name(String name) => _name = name;
//   String get username => _username;
//   set username(String username) => _username = username;
//   String get accountType => _accountType;
//   set accountType(String accountType) => _accountType = accountType;
//   String get profileImage => _profileImage;
//   set profileImage(String profileImage) => _profileImage = profileImage;
//   String get email => _email;
//   set email(String email) => _email = email;
//   Null get emailVerifiedAt => _emailVerifiedAt;
//   set emailVerifiedAt(Null emailVerifiedAt) =>
//       _emailVerifiedAt = emailVerifiedAt;
//   String get password => _password;
//   set password(String password) => _password = password;
//   String get countryCode => _countryCode;
//   set countryCode(String countryCode) => _countryCode = countryCode;
//   String get mobile => _mobile;
//   set mobile(String mobile) => _mobile = mobile;
//   String get gender => _gender;
//   set gender(String gender) => _gender = gender;
//   String get birthdate => _birthdate;
//   set birthdate(String birthdate) => _birthdate = birthdate;
//   String get relationshipStatus => _relationshipStatus;
//   set relationshipStatus(String relationshipStatus) =>
//       _relationshipStatus = relationshipStatus;
//   String get minimalFollowing => _minimalFollowing;
//   set minimalFollowing(String minimalFollowing) =>
//       _minimalFollowing = minimalFollowing;
//   String get homePicOfTheDay => _homePicOfTheDay;
//   set homePicOfTheDay(String homePicOfTheDay) =>
//       _homePicOfTheDay = homePicOfTheDay;
//   String get status => _status;
//   set status(String status) => _status = status;
//   int get verified => _verified;
//   set verified(int verified) => _verified = verified;
//   String get accessStatus => _accessStatus;
//   set accessStatus(String accessStatus) => _accessStatus = accessStatus;
//   int get viewCount => _viewCount;
//   set viewCount(int viewCount) => _viewCount = viewCount;
//   String get creator => _creator;
//   set creator(String creator) => _creator = creator;
//   String get bio => _bio;
//   set bio(String bio) => _bio = bio;
//   String get designation => _designation;
//   set designation(String designation) => _designation = designation;
//   String get privateAccount => _privateAccount;
//   set privateAccount(String privateAccount) =>
//       _privateAccount = privateAccount;
//   String get directMessage => _directMessage;
//   set directMessage(String directMessage) => _directMessage = directMessage;
//   int get profileCategoryId => _profileCategoryId;
//   set profileCategoryId(int profileCategoryId) =>
//       _profileCategoryId = profileCategoryId;
//   String get categoryDisplay => _categoryDisplay;
//   set categoryDisplay(String categoryDisplay) =>
//       _categoryDisplay = categoryDisplay;
//   String get contactDisplay => _contactDisplay;
//   set contactDisplay(String contactDisplay) =>
//       _contactDisplay = contactDisplay;
//   Null get rememberToken => _rememberToken;
//   set rememberToken(Null rememberToken) => _rememberToken = rememberToken;
//   String get deviceType => _deviceType;
//   set deviceType(String deviceType) => _deviceType = deviceType;
//   String get firebaseToken => _firebaseToken;
//   set firebaseToken(String firebaseToken) => _firebaseToken = firebaseToken;
//   String get tradesmenType => _tradesmenType;
//   set tradesmenType(String tradesmenType) => _tradesmenType = tradesmenType;
//   String get activatedAt => _activatedAt;
//   set activatedAt(String activatedAt) => _activatedAt = activatedAt;
//   String get lastLoginAt => _lastLoginAt;
//   set lastLoginAt(String lastLoginAt) => _lastLoginAt = lastLoginAt;
//   String get createdAt => _createdAt;
//   set createdAt(String createdAt) => _createdAt = createdAt;
//   String get updatedAt => _updatedAt;
//   set updatedAt(String updatedAt) => _updatedAt = updatedAt;
//   int get tradeSubscribe => _tradeSubscribe;
//   set tradeSubscribe(int tradeSubscribe) => _tradeSubscribe = tradeSubscribe;
//   Null get tradeStartDate => _tradeStartDate;
//   set tradeStartDate(Null tradeStartDate) => _tradeStartDate = tradeStartDate;
//   Null get subscriptionId => _subscriptionId;
//   set subscriptionId(Null subscriptionId) => _subscriptionId = subscriptionId;

//   Record.fromJson(Map<String, dynamic> json) {
//     _id = json['id'];
//     _name = json['name'];
//     _username = json['username'];
//     _accountType = json['account_type'];
//     _profileImage = json['profile_image'];
//     _email = json['email'];
//     _emailVerifiedAt = json['email_verified_at'];
//     _password = json['password'];
//     _countryCode = json['country_code'];
//     _mobile = json['mobile'];
//     _gender = json['gender'];
//     _birthdate = json['birthdate'];
//     _relationshipStatus = json['relationship_status'];
//     _minimalFollowing = json['minimal_following'];
//     _homePicOfTheDay = json['home_pic_of_the_day'];
//     _status = json['status'];
//     _verified = json['verified'];
//     _accessStatus = json['access_status'];
//     _viewCount = json['view_count'];
//     _creator = json['creator'];
//     _bio = json['bio'];
//     _designation = json['designation'];
//     _privateAccount = json['private_account'];
//     _directMessage = json['direct_message'];
//     _profileCategoryId = json['profile_category_id'];
//     _categoryDisplay = json['category_display'];
//     _contactDisplay = json['contact_display'];
//     _rememberToken = json['remember_token'];
//     _deviceType = json['device_type'];
//     _firebaseToken = json['firebase_token'];
//     _tradesmenType = json['tradesmen_type'];
//     _activatedAt = json['activated_at'];
//     _lastLoginAt = json['last_login_at'];
//     _createdAt = json['created_at'];
//     _updatedAt = json['updated_at'];
//     _tradeSubscribe = json['trade_subscribe'];
//     _tradeStartDate = json['trade_start_date'];
//     _subscriptionId = json['subscription_id'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this._id;
//     data['name'] = this._name;
//     data['username'] = this._username;
//     data['account_type'] = this._accountType;
//     data['profile_image'] = this._profileImage;
//     data['email'] = this._email;
//     data['email_verified_at'] = this._emailVerifiedAt;
//     data['password'] = this._password;
//     data['country_code'] = this._countryCode;
//     data['mobile'] = this._mobile;
//     data['gender'] = this._gender;
//     data['birthdate'] = this._birthdate;
//     data['relationship_status'] = this._relationshipStatus;
//     data['minimal_following'] = this._minimalFollowing;
//     data['home_pic_of_the_day'] = this._homePicOfTheDay;
//     data['status'] = this._status;
//     data['verified'] = this._verified;
//     data['access_status'] = this._accessStatus;
//     data['view_count'] = this._viewCount;
//     data['creator'] = this._creator;
//     data['bio'] = this._bio;
//     data['designation'] = this._designation;
//     data['private_account'] = this._privateAccount;
//     data['direct_message'] = this._directMessage;
//     data['profile_category_id'] = this._profileCategoryId;
//     data['category_display'] = this._categoryDisplay;
//     data['contact_display'] = this._contactDisplay;
//     data['remember_token'] = this._rememberToken;
//     data['device_type'] = this._deviceType;
//     data['firebase_token'] = this._firebaseToken;
//     data['tradesmen_type'] = this._tradesmenType;
//     data['activated_at'] = this._activatedAt;
//     data['last_login_at'] = this._lastLoginAt;
//     data['created_at'] = this._createdAt;
//     data['updated_at'] = this._updatedAt;
//     data['trade_subscribe'] = this._tradeSubscribe;
//     data['trade_start_date'] = this._tradeStartDate;
//     data['subscription_id'] = this._subscriptionId;
//     return data;
//   }
// }
