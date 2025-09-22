import 'package:flutter/material.dart';
import 'package:flutterlingo/models/entry_models/phrase_entry.dart';
import 'package:flutterlingo/providers/phrase_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// View for editing a phrase entry.
class EditView extends StatefulWidget {
  final PhraseEntry entry;

  const EditView({super.key, required this.entry});

  @override
  State<EditView> createState() => _EditViewState();
}

// State for the edit view.
class _EditViewState extends State<EditView> {
  late TextEditingController textController;
  late String currentLanguage;

  final List<String> supportedLanguages = ['en-US', 'es-ES', 'fr-FR', 'ko', 'zh-Hani'];

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: widget.entry.text);
    currentLanguage = supportedLanguages.contains(widget.entry.language)
        ? widget.entry.language
        : supportedLanguages.first;
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  // Builds the view for the phrase entry.
  @override
  Widget build(BuildContext context) {
    final createdAt = widget.entry.createdAt;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _popBack(context, textController.text, currentLanguage);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Semantics(
            label: 'Editing page.',
            excludeSemantics: true,
            child: const Text('Phrase Entry'),
          ),
          actions: [
            Semantics(
              label: 'Delete entry. Double tap to activate.',
              button: true,
              child: IconButton(
                icon: const Icon(Icons.delete),
                tooltip: 'Delete',
                onPressed: () async {
                  final provider = Provider.of<PhraseProvider>(
                    context,
                    listen: false,
                  );
                  await provider.deletePhraseEntry(widget.entry);
                  if (context.mounted) {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }
                },
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color.fromARGB(255, 189, 189, 189)),
                  borderRadius: BorderRadius.circular(4),
                  color: const Color.fromARGB(255, 242, 242, 242),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Created at:',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 116, 116, 116),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('HH:mm   MM/dd').format(createdAt),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 67, 67, 67),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Semantics(
                label:
                    'Text box for phrase. ${textController.text}. Double tap to edit.',
                excludeSemantics: true,
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 1,
                  controller: textController,
                  decoration: const InputDecoration(labelText: 'Phrase'),
                ),
              ),
              const SizedBox(height: 20),
              Semantics(
                label:
                    'Dropdown for language. $currentLanguage. Double tap to edit.',
                excludeSemantics: true,
                child: DropdownButtonFormField<String>(
                  value: currentLanguage,
                  decoration: const InputDecoration(labelText: 'Language'),
                  items: supportedLanguages.map((lang) {
                    return DropdownMenuItem<String>(
                      value: lang,
                      child: Text(lang),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        currentLanguage = value;
                      });
                    }
                  },
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _popBack(
                      context,
                      textController.text,
                      currentLanguage,
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
                      foregroundColor: const Color.fromARGB(221, 4, 4, 4),
                      elevation: 0,
                    ),
                    child: const Text('Back'),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () => _popBack(
                      context,
                      textController.text,
                      currentLanguage,
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      elevation: 0,
                    ),
                    child: const Text('Submit'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Pops back to the previous view with the updated entry.
  void _popBack(BuildContext context, String text, String language) {
    final PhraseEntry newEntry = PhraseEntry.withUpdatedText(
      widget.entry,
      text,
      language,
    );

    Navigator.pop(context, newEntry);
  }
}
