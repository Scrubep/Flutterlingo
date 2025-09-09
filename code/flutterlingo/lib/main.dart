import 'package:flutter/material.dart';
import 'package:flutterlingo/models/entry_models/phrase_entry.dart';
import 'package:flutterlingo/providers/phrase_provider.dart';
import 'package:flutterlingo/providers/drawing_provider.dart';
import 'package:flutterlingo/providers/recognition_provider.dart';
import 'package:flutterlingo/views/entry_views/all_entries_view.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';

// The root of the app where the majority of the setup is (providers, Isar, etc.)
void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([PhraseEntrySchema], directory: dir.path);

  runApp(MainApp(isar: isar));
}

class MainApp extends StatelessWidget {
  final Isar isar;
  
  const MainApp({super.key, required this.isar});

  // This widget is the root of your application.
  // Parameters:
  // - BuildContext context: The widget that will become the parents of this widget tree once built.
  // Returns: The root of the application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PhraseProvider>(
          create: (context) => PhraseProvider(isar),
          ),
        ChangeNotifierProvider<DrawingProvider>(
          create: (context) => DrawingProvider(width: 360, height: 360),
          ),
        ChangeNotifierProvider<RecognitionProvider>(
          create: (context) => RecognitionProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Flutterlingo',
        debugShowCheckedModeBanner: false, // to not block the + button
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
          useMaterial3: true,
        ),
        home: AllEntriesView(),
      )
    );
  }
}