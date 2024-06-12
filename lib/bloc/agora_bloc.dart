import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

import 'agora_event.dart';
import 'agora_state.dart';

class AgoraBloc extends Bloc<AgoraEvent, AgoraState> {
  late RtcEngine engine;

  AgoraBloc() : super(AgoraInitial()) {
    on<InitializeAgora>(_onInitializeAgora);
    on<JoinChannel>(_onJoinChannel);
    on<LeaveChannel>(_onLeaveChannel);
    on<UserJoined>(_onUserJoined);
    on<UserOffline>(_onUserOffline);
  }

  Future<void> _onInitializeAgora(
      InitializeAgora event, Emitter<AgoraState> emit) async {
    await [Permission.microphone, Permission.camera].request();

    engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(appId: event.appId));

    engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          add(JoinChannel());
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          add(UserJoined(remoteUid));
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          add(UserOffline(remoteUid));
        },
      ),
    );

    await engine.setClientRole(role: event.role);
    await engine.enableVideo();
    await engine.joinChannel(
      token: event.token,
      channelId: event.channelId,
      uid: event.uid,
      options: const ChannelMediaOptions(),
    );

    emit(AgoraInitialized());
  }

  Future<void> _onJoinChannel(
      JoinChannel event, Emitter<AgoraState> emit) async {
    emit(AgoraInitialized());
  }

  Future<void> _onLeaveChannel(
      LeaveChannel event, Emitter<AgoraState> emit) async {
    await engine.leaveChannel();
    await engine.release();
    emit(AgoraInitial());
  }

  Future<void> _onUserJoined(UserJoined event, Emitter<AgoraState> emit) async {
    emit(AgoraUserJoined(event.uid));
  }

  Future<void> _onUserOffline(
      UserOffline event, Emitter<AgoraState> emit) async {
    emit(AgoraUserOffline(event.uid));
  }
}
