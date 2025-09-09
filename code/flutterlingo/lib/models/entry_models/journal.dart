import 'package:isar/isar.dart';
import 'package:flutterlingo/models/entry_models/phrase_entry.dart';

// Class for the journal.
class Journal {

  // A list of entries within the journal.
  late List<PhraseEntry> _entries;

  // Isar for data persistence.
  late Isar _isar;

  // Constructor for the journal.
  // Parameters:
  // - Isar isar: database to store journal data.
  // Returns: Creates a journal where the phrase entries
  // are populated from the isar database.  
  Journal(Isar isar) {
    _isar = isar;
    _entries = _isar.phraseEntrys.where().findAllSync();
  }

  // Getter method for the entries.
  List<PhraseEntry> get entries {
    return List<PhraseEntry>.from(_entries);
  }

  // Puts or updates a phrase entry in the isar database depending
  // on if the entry has an id within isar already.
  // Parameters:
  // - PhraseEntry entry: entry that's beeing made or updated. 
  Future<void> upsertEntry(PhraseEntry entry) async {
    await _isar.writeTxn(() async {
      await _isar.phraseEntrys.put(entry);
    });
  }

  // Clones the journal object.
  Journal clone() {
    final Journal copy = Journal(_isar);
    return copy;
  }
}