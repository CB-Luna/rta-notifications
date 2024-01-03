import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:io';

void main(List<String> args) {
  testMail();
}

getSmtpServer() {
  final smtpServer = SmtpServer('mail.cbluna.com',
      port: 587,
      username: 'info@cbluna.com',
      password: 'AdminCbluna2021%',
      ignoreBadCertificate: true);
  return smtpServer;
}

testMail() async {
  String tomail = 'vini.gar@gmail.com';
  print(tomail);
  SmtpServer smtpServer = getSmtpServer();

  String msg = "<h1>Test</h1>\n"
      "<p>Test mail....</p>";

  // Create our message.
  final message = Message()
    ..from = Address(smtpServer.username.toString(), 'RTA')
    ..recipients.add(tomail)
    ..subject = 'RTA-Test mail'
    ..html = msg;

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}

/**
 * data: json params
 * template: template file name
 * mailto: receiver mail 
 * subject: mail subject
 * variables: json variables with name and value
 */
Future<dynamic> sendMail(Map data) async {
  Map<String, dynamic> resp = {'code': 0, 'msg': 'success'};

  try {
    //obtener template
    var msg = File('public/templates/emails/${data['template']}.html')
        .readAsStringSync();

    //reemplazar variables
    String varname = '';
    for (var variable in data['variables']) {
      varname = r'${' + variable['name'] + '}';
      msg = msg.replaceAll(varname, variable['value']);
    }

    SmtpServer smtpServer = getSmtpServer();
    // Create our message.
    final message = Message()
      ..from = Address(smtpServer.username.toString(), 'RTA')
      ..recipients.add(data['mailto'])
      ..subject = data['subject']
      ..html = msg;
    final sendmail = await send(message, smtpServer);
    print('Message sent: ' + sendmail.toString());
  } catch (e) {
    print('sendMail()_Error: $e');
  }

  return resp;
}
