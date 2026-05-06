import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/index.dart';
import 'providers/index.dart';
import 'screens/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive Adapters
  Hive.registerAdapter(EventAdapter());
  Hive.registerAdapter(ParticipantAdapter());
  Hive.registerAdapter(CheckInRecordAdapter());

  final eventProvider = EventProvider();
  final checkInProvider = CheckInProvider();
  final participantProvider = ParticipantProvider();
  final connectivityProvider = ConnectivityProvider();

  await eventProvider.initializeBox();
  await checkInProvider.initializeBox();
  await participantProvider.initializeBox();
  await connectivityProvider.initialize();

  runApp(MyApp(
    eventProvider: eventProvider,
    checkInProvider: checkInProvider,
    participantProvider: participantProvider,
    connectivityProvider: connectivityProvider,
  ));
}

class MyApp extends StatelessWidget {
  final EventProvider eventProvider;
  final CheckInProvider checkInProvider;
  final ParticipantProvider participantProvider;
  final ConnectivityProvider connectivityProvider;

  const MyApp({
    super.key,
    required this.eventProvider,
    required this.checkInProvider,
    required this.participantProvider,
    required this.connectivityProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: eventProvider),
        ChangeNotifierProvider.value(value: checkInProvider),
        ChangeNotifierProvider.value(value: participantProvider),
        ChangeNotifierProvider.value(value: connectivityProvider),
      ],
      child: MaterialApp(
        title: 'Smart Event Check-in',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4F46E5),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFF9FAFB),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: Color(0xFF1F2937)),
            titleTextStyle: TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          textTheme: GoogleFonts.interTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: const DashboardScreen(),
        routes: {
          '/setup': (context) => const EventSetupScreen(),
          '/checkin': (context) => const CheckInScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/logs': (context) => const LogsSearchScreen(),
        },
      ),
    );
  }
}
