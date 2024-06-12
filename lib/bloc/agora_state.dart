import 'package:equatable/equatable.dart';

abstract class AgoraState extends Equatable {
  @override
  List<Object> get props => [];
}

class AgoraInitial extends AgoraState {}

class AgoraInitialized extends AgoraState {}

class AgoraUserJoined extends AgoraState {
  final int uid;

  AgoraUserJoined(this.uid);

  @override
  List<Object> get props => [uid];
}

class AgoraUserOffline extends AgoraState {
  final int uid;

  AgoraUserOffline(this.uid);

  @override
  List<Object> get props => [uid];
}

class AgoraError extends AgoraState {
  final String message;

  AgoraError(this.message);

  @override
  List<Object> get props => [message];
}
