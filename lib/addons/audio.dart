import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

class AudioWidget extends StatefulWidget {
  final String audioUrl;
  final VoidCallback? onPlayPressed;
  final VoidCallback? onPausePressed;
  final VoidCallback? onStopPressed;

  const AudioWidget({
    super.key,
    required this.audioUrl,
    this.onPlayPressed,
    this.onPausePressed,
    this.onStopPressed,
  });

  @override
  _AudioWidgetState createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  FlutterSoundPlayer? _soundPlayer;
  bool _isPlaying = false; // Track the playing state

  // Function to handle the play button press
  void _handlePlayPressed() async {
    if (_isPlaying) return; // If already playing, ignore the press
    await _soundPlayer!
        .startPlayer(fromURI: widget.audioUrl); // Start playing the audio
    setState(() {
      _isPlaying = true; // Update the playing state
    });
    if (widget.onPlayPressed != null) {
      widget.onPlayPressed!(); // Call the provided callback function
    }
  }

  // Function to handle the pause button press
  void _handlePausePressed() async {
    if (!_isPlaying) return; // If not playing, ignore the press
    await _soundPlayer!.pausePlayer(); // Pause the audio
    setState(() {
      _isPlaying = false; // Update the playing state
    });
    if (widget.onPausePressed != null) {
      widget.onPausePressed!(); // Call the provided callback function
    }
  }

  // Seek bar variables
  Duration _seekBarPosition = Duration.zero;
  Duration _seekBarDuration = Duration.zero;

  // Function to get the slider values
  void _getSliderValues() async {
    final progress = await _soundPlayer!.getProgress();
    final position = progress['progress'];
    final duration = progress['duration'];

    setState(() {
      _seekBarPosition = position ?? Duration.zero;
      _seekBarDuration = duration ?? Duration.zero;
    });
  }

  // Function to stop progress tracking
  void _handleStopPressed() async {
    if (!_isPlaying) return; // If not playing, ignore the press
    await _soundPlayer!.stopPlayer(); // Stop the audio
    setState(() {
      _isPlaying = false; // Update the playing state
    });
    if (widget.onStopPressed != null) {
      widget.onStopPressed!(); // Call the provided callback function
    }
  }

  void _startProgressTracking() {
    Timer.periodic(const Duration(milliseconds: 100), (timer) async {
      if (_isPlaying) {
        _getSliderValues();
      }
    });
  }

  buttonDisplayed() {
    if (_isPlaying == false) {
      return Container(
        alignment: Alignment.center,
        child: IconButton(
          icon: const Icon(
            Icons.play_arrow,
            size: 40.0,
            color: Colors.white70,
          ),
          onPressed: () async {
            _handlePlayPressed();
          }, // Use the custom handler
        ),
      );
    } else if (_isPlaying == true) {
      return Container(
        alignment: Alignment.center,
        child: IconButton(
          icon: const Icon(
            Icons.pause,
            size: 40.0,
            color: Colors.white70,
          ),
          onPressed: _handlePausePressed, // Use the custom handler
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _soundPlayer = FlutterSoundPlayer();
    _soundPlayer!.openPlayer().then((value) {
      _soundPlayer!.setSubscriptionDuration(const Duration(milliseconds: 100));
    });
    _startProgressTracking();
  }

  @override
  void dispose() {
    _soundPlayer!.closePlayer();
    _soundPlayer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buttonDisplayed(),
          Slider(
            thumbColor: Colors.blueGrey,
            activeColor: Colors.blueGrey,
            inactiveColor: Colors.white70,
            min: 0,
            max: _seekBarDuration.inMilliseconds.toDouble(),
            value: _seekBarPosition.inMilliseconds.toDouble(),
            onChanged: (value) {
              setState(() {
                _seekBarPosition = Duration(milliseconds: value.toInt());
              });
            },
            onChangeEnd: (value) {
              final seekPosition = Duration(milliseconds: value.toInt());
              _soundPlayer!.seekToPlayer(seekPosition);
            },
          ),
        ],
      ),
    );
  }
}
