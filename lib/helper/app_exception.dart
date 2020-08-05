class AppException implements Exception {
  final String _message;
  final String _prefix;
  final int _statusCode;
  
AppException([this._message, this._prefix,this._statusCode]);

String get message => _message;
int get statusCode => _statusCode;

String toString() {
    return "$_statusCode $_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String message,int statusCode])
      : super(message, "Error During Communication: ",statusCode);
}

class BadRequestException extends AppException {
  BadRequestException([String message,int statusCode]) : super(message, "Invalid Request: ");
}
