import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:video_call_flutter/bloc/agora_bloc.dart';
import 'package:video_call_flutter/bloc/agora_event.dart';
import 'package:video_call_flutter/bloc/agora_state.dart';

class VideoCallScreen extends StatefulWidget {
  final ClientRoleType role;

  const VideoCallScreen({super.key, required this.role});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  int? _remoteUid;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AgoraBloc>(context).add(InitializeAgora(
      appId: 'd74e296601534ac99082d2bf0403c1d5',
      token:
          '007eJxTYGDY1Ptp30p9gasuMndN2Xpv6vy3c1tv5/GyxPrYD/+Y1RsVGFLMTVKNLM3MDAxNjU0Sky0tDSyMUoyS0gxMDIyTDVNMJVdlpjUEMjKc7fvEwAiFID4LQ0lqcQkDAwA6Xx+B',
      channelId: 'test',
      uid: 0,
      role: widget.role,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agora Video Call')),
      body: BlocBuilder<AgoraBloc, AgoraState>(
        builder: (context, state) {
          if (state is AgoraUserJoined) {
            _remoteUid = state.uid;
          } else if (state is AgoraUserOffline) {
            _remoteUid = null;
          }

          return Stack(
            children: [
              Center(child: _remoteVideo()),
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 100,
                  height: 150,
                  child: Center(
                    child: state is AgoraInitialized
                        ? AgoraVideoView(
                            controller: VideoViewController(
                              rtcEngine:
                                  BlocProvider.of<AgoraBloc>(context).engine,
                              canvas: const VideoCanvas(uid: 0),
                            ),
                          )
                        : const CircularProgressIndicator(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: BlocProvider.of<AgoraBloc>(context).engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: const RtcConnection(channelId: 'test'),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}
