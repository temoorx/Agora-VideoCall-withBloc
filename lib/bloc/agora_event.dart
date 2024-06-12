import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:equatable/equatable.dart';

abstract class AgoraEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class InitializeAgora extends AgoraEvent {
  final String appId;
  final String token;
  final String channelId;
  final int uid;
  final ClientRoleType role;

  InitializeAgora({required this.appId, required this.token, required this.channelId, required this.uid, required this.role});
}

class JoinChannel extends AgoraEvent {}

class LeaveChannel extends AgoraEvent {}

class UserJoined extends AgoraEvent {
  final int uid;

  UserJoined(this.uid);

  @override
  List<Object> get props => [uid];
}

class UserOffline extends AgoraEvent {
  final int uid;

  UserOffline(this.uid);

  @override
  List<Object> get props => [uid];
}
