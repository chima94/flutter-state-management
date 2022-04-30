import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AppEvent {
  const AppEvent();
}

@immutable
class AppEventUploadImage implements AppEvent {
  final String filePathToUpload;

  const AppEventUploadImage({required this.filePathToUpload});
}

@immutable
class AppEventDeletAccount implements AppEvent {
  const AppEventDeletAccount();
}

@immutable
class AppEventLogout implements AppEvent {
  const AppEventLogout();
}

@immutable
class AppEventInitializer implements AppEvent {
  const AppEventInitializer();
}

@immutable
class AppEventLogin implements AppEvent {
  final String email;
  final String password;

  const AppEventLogin({required this.email, required this.password});
}

@immutable
class AppEventGoToRegistration implements AppEvent {
  const AppEventGoToRegistration();
}

@immutable
class AppEventGoToLogin implements AppEvent {
  const AppEventGoToLogin();
}

@immutable
class AppEventRegister implements AppEvent {
  final String email;
  final String password;

  const AppEventRegister({required this.email, required this.password});
}
