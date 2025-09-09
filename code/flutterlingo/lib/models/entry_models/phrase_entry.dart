import 'package:isar/isar.dart';
part 'phrase_entry.g.dart';

// Class for individual phrase entries.
@collection
class PhraseEntry {
  
  // ID for identifying entries within Isar.
  final Id? id;

  // The todo item.
  final String text;

  // Language of the phrase.
  final String language;

  // When the entry was last updated.
  final DateTime updatedAt;

  // When the entry was created.
  final DateTime createdAt;

  // If the entry is checked as done.
  bool isChecked = false;

  // String for the check status (for semantics). 
  String checkString = 'To do is unchecked';

  factory PhraseEntry.fromText({String text = '', String language = ''}) {
    final when = DateTime.now();
    return PhraseEntry(
      text: text,
      language: language,
      updatedAt: when,
      createdAt: when,
      );
  }

  // Generative constructor for a journal entry.
  PhraseEntry(
      {required this.text,
      this.id,
      required this.language,
      required this.updatedAt,
      required this.createdAt,
      });

  // Constructor for updating a journal entry.
  // Parameters:
  // - JournalEntry entry: Entry that's being updated.
  // - String newText: Updated text within the entry.
  // - String newDescription: Updated description within the entry.
  // - DateTime? newDeadline: Updated deadline within the entry.
  // Returns: N/A, updates a journal entry/
  PhraseEntry.withUpdatedText(PhraseEntry entry, String newText, String newLanguage)
      : id = entry.id,
        createdAt = entry.createdAt,
        updatedAt = DateTime.now(),
        text = newText,
        language = newLanguage;
}