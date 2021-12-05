import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

class TwarzBot {
  factory TwarzBot() {
    return _instance;
  }

  TwarzBot._internal();

  static const tokenBotEnv = '5068692598:AAFfoHU3VAp8TALf0Tb_Im840eFGQk1PWgE';

  static const userAdminEnv = 631070825;

  static const userFounderEnv = 162104524;

  final teledart = TeleDart(
    Telegram(tokenBotEnv),
    Event('Ciao!'),
  );

  Future<void> start() async {
    teledart.start();
  }

  Future<void> send({required dynamic file}) async {
    final _users = [userAdminEnv, userFounderEnv];

    for (final userId in _users) {
      await teledart.telegram.sendDocument(
        userId,
        file,
        caption: 'Twarz session recorded at ${DateTime.now()}. Have fun 👋',
      );
    }
  }

  static final TwarzBot _instance = TwarzBot._internal();
}
