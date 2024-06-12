import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class AgoraRepository {
  final RtcEngine _engine;

  AgoraRepository(this._engine);

  Future<void> initialize(String appId) async {
    await _engine.initialize(RtcEngineContext(appId: appId));
  }

  Future<void> joinChannel(
      String token, String channelId, int uid, ClientRoleType role) async {
    await _engine.setClientRole(role: role);
    await _engine.enableVideo();
    await _engine.joinChannel(
        token: token,
        channelId: channelId,
        uid: uid,
        options: const ChannelMediaOptions());
  }

  Future<void> leaveChannel() async {
    await _engine.leaveChannel();
    await _engine.release();
  }
}
