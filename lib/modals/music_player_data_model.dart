import 'package:just_audio/just_audio.dart';

import '../features/audio/widgets/common.dart';

class MusicPlayerDataModel {
  final SequenceState? sequenceState;
  final PositionData positionData;
  final PlayerState? playerState;
  MusicPlayerDataModel(
      {this.sequenceState, required this.positionData, this.playerState});
}
