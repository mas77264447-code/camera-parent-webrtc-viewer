import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class CameraService {
  static IO.Socket? socket;
  static RTCPeerConnection? pc;

  static Future<void> startWebrtc(String room, MediaStream stream) async {
    socket = IO.io('https://camera-parent-server.onrender.com', {
      'transports': ['websocket']
    });

    pc = await createPeerConnection({
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'}
      ]
    });

    for (final track in stream.getTracks()) {
      await pc!.addTrack(track, stream);
    }

    pc!.onIceCandidate = (candidate) {
      socket!.emit('ice', candidate.toMap());
    };

    socket!.onConnect((_) {
      socket!.emit('join', room);
    });

    socket!.on('answer', (data) async {
      await pc!.setRemoteDescription(
        RTCSessionDescription(data['sdp'], data['type'])
      );
    });

    socket!.on('ice', (data) async {
      await pc!.addCandidate(RTCIceCandidate(
        data['candidate'], data['sdpMid'], data['sdpMLineIndex']
      ));
    });

    final offer = await pc!.createOffer();
    await pc!.setLocalDescription(offer);
    socket!.emit('offer', offer.toMap());
  }

  static Future<void> dispose() async {
    await pc?.close();
    socket?.disconnect();
  }
}
