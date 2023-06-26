import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

class AudioService {
  static final FlutterSoundPlayer _player = FlutterSoundPlayer();
  static final FlutterSoundRecorder _recorder = FlutterSoundRecorder();

  static Future<String?> getFilePath() async {
    final directory =
        await getTemporaryDirectory(); // Get the temporary directory
    final filePath = '${directory.path}/recording.wav'; // Set the file path

    // Start recording audio using flutter_sound and filePath

    return filePath; // Return the file path
  }

  static Future<void> disposeAudio() async {
    await _player.closePlayer();
    await _recorder.closeRecorder();
  }

  static Future<void> startRecording(String filePath) async {
    await _recorder.openRecorder();
    await _recorder.startRecorder(toFile: filePath);
  }

  static Future<void> stopRecording() async {
    await _recorder.stopRecorder();
  }

  static Future<void> startPlaying(String filePath) async {
    await _player.openPlayer();
    await _player.startPlayer(fromURI: filePath);
  }

  static Future<void> pausePlaying() async {
    await _player.pausePlayer();
  }

  static Future<void> stopPlaying() async {
    await _player.stopPlayer();
  }
}
