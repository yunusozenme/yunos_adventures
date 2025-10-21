import 'package:flame/components.dart';
import 'package:yunos_adventures/dialogue_box.dart';

final _speakerList = [
  '[Yuno]',
  '[Little Bug]',
  '[Little Bug]',
  '[Yuno]',
  '[Little Bug]',
];

final _dialogueList = [
  'Alright,\nI\'ll handle them.',
  'Monsters are coming this way!',
  'There is no time to explain.',
  'What is going on?',
  'Hey Yuno! \nSave..  Save me!',
];

class BugMissionDialogue extends PositionComponent {
  late TextComponent _speakerName;
  late DialogueBox _dialogueBox;
  Function onMissionComplete;

  BugMissionDialogue({
    required Vector2 dialoguePosition,
    required Vector2 size,
    required Vector2 scale,
    required this.onMissionComplete,
  }) : super(position: dialoguePosition, size: size, scale: scale);

  @override
  void onLoad() => _addDialogue();

  void _addDialogue() {
    final nextSpeaker = _speakerList.removeLast();
    final nextDialogue = _dialogueList.removeLast();
    _speakerName = TextComponent(text: nextSpeaker)
      ..anchor = Anchor(0, 1);
    _dialogueBox = DialogueBox(dialogueText: nextDialogue);
    addAll([_speakerName, _dialogueBox]);
    _dialogueBox.onComplete = onDialogueBoxRetired;
  }

  void onDialogueBoxRetired() {
    removeAll([_speakerName, _dialogueBox]);
    if(_speakerList.isNotEmpty && _dialogueList.isNotEmpty) {
      _addDialogue();
    } else {
      onMissionComplete();
    }
  }
}
