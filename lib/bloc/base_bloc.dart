import 'package:base_app/const/const.dart';
import 'package:base_app/const/string_value.dart';
import 'package:base_app/request/base_request.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseBloc<E, S> extends Bloc<E, S> {
  Function(Object error, StackTrace stacktrace) onErrorCallBack;

  BaseBloc(S initialState) : super(initialState);

  void setOnErrorListener(
      Function(Object error, StackTrace stacktrace) onErrorCallBack) {
    this.onErrorCallBack = onErrorCallBack;
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    String errorContent = sErrorConnectFailedStr;
    if (error is DioError && error.type != null) {
      switch (error.type) {
        case DioErrorType.CONNECT_TIMEOUT:
        case DioErrorType.SEND_TIMEOUT:
        case DioErrorType.RECEIVE_TIMEOUT:
          errorContent = sErrorConnectTimeOut;
          BaseRequest.I?.close();
          break;
        case DioErrorType.RESPONSE:
          switch (error.response.statusCode) {
            case error401:
              errorContent = sError401;
              return;
              break;
            case error404:
              errorContent = sError404;
              break;
            case error500:
              errorContent = sErrorInternalServer;
              break;
            case error502:
              errorContent = sError502;
              break;
            case error503:
              errorContent = sError503;
              break;
            default:
              errorContent = sErrorInternalServer;
          }
          break;
        default:
          errorContent = sErrorConnectFailedStr;
      }
    }

    if (onErrorCallBack != null) onErrorCallBack(errorContent, stacktrace);
    super.onError(error, stacktrace);
  }
}
