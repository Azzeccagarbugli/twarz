import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

class TwarzBot {
  factory TwarzBot() {
    return _instance;
  }

  TwarzBot._internal();

  static const tokenBotEnv = '5068692598:AAFfoHU3VAp8TALf0Tb_Im840eFGQk1PWgE';

  final teledart = TeleDart(
    Telegram(tokenBotEnv),
    Event('Ciao!'),
  );

  Future<void> start() async {
    teledart.start();
  }

  Future<void> send({required dynamic file, required int lines}) async {
    final _users = {
      631070825: 'Tere',
      162104524: 'Fra',
      354933785: 'Mary',
    };

    final _now = DateTime.now().toString().split('.')[0];

    for (final userId in _users.keys) {
      final _msg = '''
🧠  *Twarz Session*

⏰  *Recorded at:* _${_now}_
📊  *Lines in the CVS*: _${lines}_

👋  _Have fun in the analysis ${_users[userId]}!_
    ''';

      await teledart.telegram.sendDocument(
        userId,
        file,
        caption: _msg,
        parse_mode: 'Markdown',
      );
    }
  }

  static final TwarzBot _instance = TwarzBot._internal();
}
