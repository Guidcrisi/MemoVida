import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:memovida/interface/SplashPage.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // ID do canal
  'High Importance Notifications', // Nome do canal
  description: 'This channel is used for important notifications.', // Descrição
  importance: Importance.high,
  showBadge: true, // Mostra o ícone na barra de status
  enableLights: true, // Ativa luzes ao receber notificações
  enableVibration: true, // Ativa vibração
  playSound: true, // Ativa som
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');

  InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  runApp(App());
}

class App extends StatelessWidget {
  static Color primary = const Color(0xFF4A90E2);
  static Color secondary = const Color(0xFFD0021B);
  static Color textColor = Colors.black;
  static Color backgroundColor = Colors.white;
  static double fontSize = 18.0;

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "MemoVida",
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    );
  }
}
