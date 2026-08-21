import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../services/camera_service.dart';

class CameraStreamScreen extends StatefulWidget {
  final String sessionId;
  const CameraStreamScreen({super.key, required this.sessionId});
  @override State<CameraStreamScreen> createState()=>_State();
}

class _State extends State<CameraStreamScreen>{
  final RTCVideoRenderer _local=RTCVideoRenderer();
  MediaStream? _stream;
  bool _front=true;

  @override void initState(){super.initState(); _start();}
  Future<void> _start() async{
    await _local.initialize();
    _stream=await navigator.mediaDevices.getUserMedia({'video':{'facingMode':'user'},'audio':true});
    _local.srcObject=_stream;
    await CameraService.startWebrtc(widget.sessionId,_stream!);
    setState((){});
  }

  Future<void> _switchCamera() async{
    final track=_stream?.getVideoTracks().first;
    if(track!=null){ await Helper.switchCamera(track); setState(()=>_front=!_front); }
  }

  @override void dispose(){_local.dispose(); _stream?.dispose(); super.dispose();}
  @override Widget build(BuildContext c)=>Scaffold(
    appBar: AppBar(title:const Text('البث المباشر')),
    body: Column(children:[Expanded(child:RTCVideoView(_local,mirror:_front)),ElevatedButton(onPressed:_switchCamera,child:const Text('تبديل الكاميرا'))])
  );
}
