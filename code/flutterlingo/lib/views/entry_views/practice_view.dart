import 'package:flutter/material.dart';
import 'package:flutterlingo/models/entry_models/phrase_entry.dart';
import 'package:flutterlingo/providers/phrase_provider.dart';
import 'package:flutterlingo/providers/drawing_provider.dart';
import 'package:flutterlingo/providers/recognition_provider.dart';
import 'package:flutterlingo/views/draw_views/draw_area.dart';
import 'package:flutterlingo/views/entry_views/edit_view.dart';
import 'package:provider/provider.dart';

// View for a single entry that the user can click into from
// the home page.
class PracticeView extends StatefulWidget {
  // The entry of the view.
  final PhraseEntry entry;

  // Constructor for the single entry view.
  const PracticeView({super.key, required this.entry});

  @override 
  State<PracticeView> createState() => _PracticeViewState();
}

// Creates the state for an entry view.
class _PracticeViewState extends State<PracticeView> {
  late PhraseEntry _entry;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _entry = widget.entry;

    // Defer async model change to after the first build
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        final recognizer = context.read<RecognitionProvider>();
        final drawer = context.read<DrawingProvider>();

        recognizer.setTargetPhrase(_entry.text);
        recognizer.clearResults();
         drawer.totalClear();
        //drawer.clear();

        await recognizer.changeModel(_entry.language);
      }
    });
  }

  // Builds the view for the practice page.
  @override
  Widget build(BuildContext context) {
    final recognizer = context.watch<RecognitionProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Practice'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Entry',
            onPressed: () => _navigateToEdit(context, widget.entry),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 5,
        children: [
          Text('Write or type: "${recognizer.targetPhrase}"'),
          const SizedBox(height: 20),

          // Text input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _textController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: 'Type here',
                border: OutlineInputBorder(),
                suffixIcon: Icon(
                  _textController.text.trim().toLowerCase() ==
                          recognizer.targetPhrase.toLowerCase()
                      ? Icons.check
                      : Icons.close,
                  color:
                      _textController.text.trim().toLowerCase() ==
                              recognizer.targetPhrase.toLowerCase()
                          ? Colors.green
                          : Colors.red,
                ),
              ),
            ),
          ),

          // Draw area (simplified)
          Semantics(label: "Handwriting input area", hint: "Draw the phrase here using your finger or stylus. Double tap to start drawing.", child: DrawArea(height: 300, width: 350)),

          ElevatedButton(
            onPressed:
                () => recognizer.recognizeFromDrawing(
                  context.read<DrawingProvider>(),
                ),
            child: const Text(
              "Recognize Handwriting",
              style: TextStyle(color: Color.fromARGB(255, 92, 63, 11)),
            ),
          ),

          if (recognizer.hasResults)
            Text(
              'You wrote: "${recognizer.topCandidate}"\n'
              '${recognizer.isMatch ? "✅ Correct!" : "❌ Try again"}',
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  // Navigates to the edit view for the entry.
  Future<void> _navigateToEdit(BuildContext context, PhraseEntry entry) async {
    final newEntry = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditView(entry: entry)),
    );

    if (!mounted) return;

    if (newEntry != null && newEntry is PhraseEntry && context.mounted) {
      _entry = newEntry;
      final recognizer = context.read<RecognitionProvider>();
      recognizer.setTargetPhrase(newEntry.text);

      recognizer.changeModel(newEntry.language);
      if (!mounted) return;

      Provider.of<PhraseProvider>(
        context,
        listen: false,
      ).upsertPhraseEntry(newEntry);
      setState(() {});
    }
  }
}
