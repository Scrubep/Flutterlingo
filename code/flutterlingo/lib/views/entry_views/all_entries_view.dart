import 'package:flutter/material.dart';
import 'package:flutterlingo/providers/phrase_provider.dart';
import 'package:flutterlingo/views/entry_views/edit_view.dart';
import 'package:flutterlingo/models/entry_models/phrase_entry.dart';
import 'package:flutterlingo/views/entry_views/practice_view.dart';
import 'package:provider/provider.dart';

// Class for the home page of the app where all entries are
// shown as a list.
class AllEntriesView extends StatelessWidget {
  
  // Constructor for the all entries view.
  const AllEntriesView({super.key});

  // Builds widget tree for the home page of the journal.
  // Parameters:
  // - BuildContext context: The widget that will become the parents of this widget tree once built.
  // Returns: Home page of the journal.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          label: '',
          excludeSemantics: true,
          child: Text('Flutterlingo'),
        ),
        actions: [
          Semantics(
            label: 'Add an entry. Double tap to activate.',
            button: true,
            excludeSemantics: true,
            child: IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Add Entry',
              onPressed: () {
                final PhraseEntry newEntry = PhraseEntry.fromText();
                _navigateToEdit(context, newEntry);
              }
          ),
          )
        ]
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Consumer<PhraseProvider>(
              builder: (context, phraseProvider, child) {
                return ListView.builder(
                  itemCount: phraseProvider.journal.entries.length,
                  itemBuilder:(context, index) {
                    return _createListElementForEntry(context, phraseProvider.journal.entries[index]);
                  },
                );
              }
            )
          )
        ]
      ),
    );
  }

  // A method that creates a tile widget for each journal entry that is then
  // displayed on the home page.
  // Parameters:
  // - BuildContext context: The widget that will become the parents of this widget tree once built.
  // - JournalEntry entry: The entry the widget is built around.
  // Returns: A clickable tile Widget representing the entry.
  Widget _createListElementForEntry(BuildContext context, PhraseEntry entry) {
    
    final provider = Provider.of<PhraseProvider>(context, listen: false);
    
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: Card(
          color: const Color.fromARGB(255, 255, 225, 183),
          child: ListTile(
          contentPadding: const EdgeInsets.all(8.0),
          title: Text(
            entry.text,
            style: const TextStyle(
              fontSize: 15,
            )
          ),
          subtitle: Text(
            'Language: ${entry.language}',
            style: const TextStyle(
                fontSize: 13,
                color: Colors.black,
            )
          ),
          trailing: Semantics (
            label: 'Checkbox. ${entry.checkString}. Doubletap to change.',
            excludeSemantics: true,
            button: true,
            child: Checkbox(
            value: entry.isChecked,
            onChanged: (bool? value) {
              provider.setChecked(entry);
            }
            ),
          ),
          onTap: () => _navigateToPractice(context, entry),
        ),
        )
      )
    );
  }

  // Method for navigating from an all entry view (home page) to an individual entry view.
  // Allows the user to edit or add an entry to their journal.
  // Parameters: 
  // - BuildContext context: The widget that will become the parents of this widget tree once built.
  // - JournalEntry entry: The entry that is clicked into.
  // Returns: N/A, allows navigation from the home page to an individual entry view.
  Future<void> _navigateToEdit(BuildContext context, PhraseEntry entry) async {
    final newEntry = await Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => EditView(entry: entry))
    );

    if (!context.mounted) return; // This checks if a widget is mounted and still within the tree. A scenario where the
    // widget may be unmounted is when the screen is when the user navigates back. If the widget is unmounted and
    // you use the provider, it may throw an error if the widget isn't present within the tree.

    if(newEntry != null) {
      Provider.of<PhraseProvider>(context, listen: false).upsertPhraseEntry(newEntry);
    }
  }

  Future<void> _navigateToPractice(BuildContext context, PhraseEntry entry) async {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => PracticeView(entry: entry))
    );
  }
}