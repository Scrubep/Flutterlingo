import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:flutterlingo/models/entry_models/journal.dart';
import 'package:flutterlingo/models/entry_models/phrase_entry.dart';

// Provider for making changes within a journal.
class PhraseProvider extends ChangeNotifier {

  // Journal that is being changed.
  late final Journal _journal;

  // Isar database for the journal.
  late final Isar _isar;

  // Constructor for the provider. Defines
  // the isar and a journal consisting
  // of the entries within the database.
  PhraseProvider(Isar isar) {
    _isar = isar;
    _journal = Journal(isar);
  }

  // Getter that returns a clone of the journal.
  Journal get journal {
    return _journal.clone();
  }

  // Method for when the user adds or updates a phrase entry.
  // Parameters:
  // - PhraseEntry entry: Entry that's being added or updated.
  // Returns: N/A, adds or updates an entry to the journal.
  Future<void> upsertPhraseEntry(PhraseEntry entry) async {
    await _journal.upsertEntry(entry);
    notifyListeners();
  }

  // Method for checking the status of the phrase (learned, learning).
  // Parameters:
  // - PhraseEntry entry: Entry that's being checked.
  // Returns: N/A, checks and unchecks the phrase.
  Future<void> setChecked(PhraseEntry entry) async {
    entry.isChecked = !entry.isChecked;
    if (entry.isChecked) {
      entry.checkString = 'To do is checked';
    }
    else {
      entry.checkString = 'To do is unchecked';
    }
    
    await _isar.writeTxn(() async {
      await _isar.phraseEntrys.put(entry);
    });

    notifyListeners();
  }

  // Method for deleting a phrase entry.
  // Parameters:
  // - PhraseEntry entry: Entry that's being deleted.
  // Returns: N/A, deletes an entry from the isar database.
  Future<void> deletePhraseEntry(PhraseEntry entry) async {
    
    if (entry.id == null) return;
    
    await _isar.writeTxn(() async {
      await _isar.phraseEntrys.delete(entry.id!);
    });
    notifyListeners();
  }
}