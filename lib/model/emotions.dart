import 'package:flutter/material.dart';

enum Emotion {
  anger,
  cringe,
  disgust,
  fear,
  joy,
  sadness,
  surprise,
}

class InformationEmotion {
  String title;
  String subtitle;
  String goTo;
  Color color;
  InformationEmotion({
    required this.title,
    required this.subtitle,
    required this.goTo,
    required this.color,
  });
}

extension EmotionUtilities on Emotion {
  static Map<String, InformationEmotion> conversion() => {
        '0 Anger': InformationEmotion(
          title: 'Anger',
          subtitle:
              'Anger, also known as wrath or rage, is an intense emotional state involving a strong uncomfortable and non-cooperative response to a perceived provocation, hurt or threat',
          goTo: 'Anger',
          color: Colors.red,
        ),
        '1 Cringe': InformationEmotion(
          title: 'Cringe',
          subtitle:
              'To suddenly move away from someone or something because you are frightened',
          goTo: 'Cringe',
          color: Colors.grey,
        ),
        '2 Disgust': InformationEmotion(
          title: 'Disgust',
          subtitle:
              'Disgust (Middle French: desgouster, from Latin gustus, "taste") is an emotional response of rejection or revulsion to something potentially contagious or something considered offensive, distasteful, or unpleasant',
          goTo: 'Disgust',
          color: Colors.green.shade700,
        ),
        '3 Fear': InformationEmotion(
          title: 'Fear',
          subtitle:
              'Fear is an intensely unpleasant emotion in response to perceiving or recognizing a danger or threat. Fear causes physiological changes that may produce behavioral reactions such as mounting an aggressive response or fleeing the threat',
          goTo: 'Fear',
          color: Colors.red.shade700,
        ),
        '4 Joy': InformationEmotion(
          title: 'Joy',
          subtitle:
              'The word joy means the emotion evoked by well-being, success, or good fortune, and is typically associated with feelings of intense, long lasting happiness',
          goTo: 'Joy',
          color: Colors.yellow.shade700,
        ),
        '5 Sadness': InformationEmotion(
          title: 'Sadness',
          subtitle:
              'Sadness is an emotional pain associated with, or characterized by, feelings of disadvantage, loss, despair, grief, helplessness, disappointment and sorrow. An individual experiencing sadness may become quiet or lethargic, and withdraw themselves from others',
          goTo: 'Sadness',
          color: Colors.brown.shade700,
        ),
        '6 Surprise': InformationEmotion(
          title: 'Surprirse',
          subtitle:
              'Surprise is a brief mental and physiological state, a startle response experienced by animals and humans as the result of an unexpected event. Surprise can have any valence; that is, it can be neutral/moderate, pleasant, unpleasant, positive, or negative',
          goTo: 'Surprirse',
          color: Colors.blueAccent.shade700,
        ),
      };
}
