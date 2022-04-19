import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_webrtc/webrtc.dart';
import 'package:shastho_sheba_doctor/models/schedule.dart';

import '../utils.dart';
import '../routes.dart';
import '../blocs/videoCall/callState.dart';
import '../blocs/videoCall/videoCall.dart';
import '../blocs/chamber/messenger.dart';
import '../networking/response.dart';
import '../models/appointment.dart';
import '../widgets/image.dart';

class VideoCallScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    Messenger messenger = args['messenger'];
    Schedule schedule = args['schedule'];
    return ChangeNotifierProvider(
      create: (context) => VideoCallBloc(messenger.signaling, schedule),
      builder: (context, child) {
        VideoCallBloc videoCallBloc = Provider.of<VideoCallBloc>(context);
        return StreamBuilder(
          stream: videoCallBloc.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Response<CallState> response = snapshot.data;
              print('in video call');
              print(response.data);
              switch (response.data) {
                case CallState.Calling:
                  return _CallingScreen(schedule);
                case CallState.Connected:
                  return _VideoCall();
                case CallState.EndCall:
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => Navigator.popUntil(
                        context, ModalRoute.withName(chamberScreen)),
                  );
                  break;
                default:
                  break;
              }
            }
            return Container();
          },
        );
      },
    );
  }
}

class _CallingScreen extends StatelessWidget {
  final patient;

  _CallingScreen(this.patient);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundimage),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 50.0,
                ),
                CircleAvatar(
                  radius: 75.0,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 73,
                    backgroundImage: AssetImage('images/as.png'),
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Text(
                  'You are calling',
                  style: L,
                ),
                Expanded(child: SizedBox()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VideoCall extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    VideoCallBloc videoCallBloc = Provider.of<VideoCallBloc>(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ButtonBar(
        alignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: 50.0,
            width: 50.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: lightBlue,
            ),
            child: FittedBox(
              child: IconButton(
                icon: Icon(
                  videoCallBloc.video ? Icons.videocam : Icons.videocam_off,
                ),
                color: blue,
                onPressed: videoCallBloc.toggleVideo,
              ),
            ),
          ),
          Container(
            height: 50.0,
            width: 50.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: lightMint,
            ),
            child: FittedBox(
              child: IconButton(
                icon: Icon(
                  videoCallBloc.audio ? Icons.mic : Icons.mic_off,
                ),
                color: mint,
                onPressed: videoCallBloc.muteAudio,
              ),
            ),
          ),
          Container(
            height: 50.0,
            width: 50.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: lightRed,
            ),
            child: FittedBox(
              child: IconButton(
                icon: Icon(
                  Icons.call_end,
                ),
                color: red,
                onPressed: videoCallBloc.endCall,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return Container(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 0.0,
                    right: 0.0,
                    top: 0.0,
                    bottom: 0.0,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: RTCVideoView(videoCallBloc.remoteRenderer),
                      decoration: BoxDecoration(color: Colors.black54),
                    ),
                  ),
                  Positioned(
                    left: 20.0,
                    top: 20.0,
                    child: Container(
                      width: orientation == Orientation.portrait ? 90.0 : 120.0,
                      height:
                          orientation == Orientation.portrait ? 120.0 : 90.0,
                      child: RTCVideoView(videoCallBloc.localRenderer),
                      decoration: BoxDecoration(color: Colors.black54),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
