import 'package:flutter/material.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart' as mlkit;
import '../models/drawing_models/draw_actions/draw_actions.dart';
import '../providers/drawing_provider.dart';

// Provider for handling handwriting recognition.
class RecognitionProvider extends ChangeNotifier {
  mlkit.DigitalInkRecognizer? _recognizer;
  final mlkit.DigitalInkRecognizerModelManager _modelManager = mlkit.DigitalInkRecognizerModelManager();

  String _languageTag = '';
  List<mlkit.RecognitionCandidate> _results = [];
  bool _isProcessing = false;
  String _targetPhrase = '';

  RecognitionProvider();

  // Getter for the list of recognition results (to be used in the practice view).
  List<mlkit.RecognitionCandidate> get results => _results;

  // Getter for the top recognition candidate string.
  bool get isProcessing => _isProcessing;
  bool get hasResults => _results.isNotEmpty;
  bool get isInitialized => _recognizer != null;

  String get topCandidate => hasResults ? _results.first.text : '';
  String get allCandidates => _results.map((e) => e.text).join(', ');
  String get targetPhrase => _targetPhrase;

  // Sets the target phrase for the user to match.
  void setTargetPhrase(String phrase) {
    _targetPhrase = phrase;
    notifyListeners();
  }

  // Checks if the top candidate matches the target phrase (case-insensitive).
  bool get isMatch => topCandidate.trim().toLowerCase() == _targetPhrase.trim().toLowerCase();


  // Changes the recognition model to a new language.
  Future<void> changeModel(String languageTag) async {
    try {
      debugPrint('Attempting to clean up model for $_languageTag');

      if (_recognizer != null) {

        // _recognizer!.close();
        _recognizer = null;
        
        // await Future.delayed(Duration(milliseconds: 100));

        // debugPrint('Deleting model...');
        // await _modelManager.deleteModel(_languageTag);
        debugPrint("Model for $_languageTag closed and deleted.");
      }

    } catch (e) {
      debugPrint("Error cleaning up previous model: $e");
    }

    _languageTag = languageTag;

    try {
      final downloaded = await _modelManager.isModelDownloaded(_languageTag);
      if (!downloaded) {
        final success = await _modelManager.downloadModel(_languageTag);
        if (!success) throw Exception("Failed to download model for $_languageTag");
      }

      _recognizer = mlkit.DigitalInkRecognizer(languageCode: _languageTag);
      debugPrint("Model for $_languageTag initialized.");

      // Defer notification to avoid build-time errors
      if (hasListeners) notifyListeners();
    } catch (e) {
      debugPrint("Model init failed: $e");
    }
  }

  // Performs handwriting recognition on the drawing from a DrawingProvider.
  Future<void> recognizeFromDrawing(DrawingProvider provider) async {
    if (_isProcessing || _recognizer == null) return;

    _isProcessing = true;
    notifyListeners();

    final ink = _buildInkFromDrawing(provider);
    final context = mlkit.DigitalInkRecognitionContext(
      writingArea: mlkit.WritingArea(width: provider.width, height: provider.height),
    );

    try {
      _results = await _recognizer!.recognize(ink, context: context);
    } catch (e) {
      debugPrint("Recognition failed: $e");
      _results = [];
    }

    _isProcessing = false;
    notifyListeners();
  }

  // Translates user's drawing into the 'Ink' format that ML Kit requires for recognition.
  mlkit.Ink _buildInkFromDrawing(DrawingProvider provider) {
    final strokes = <mlkit.Stroke>[];
    List<DrawAction> relevantActions = [];

    int lastClearIndex = provider.drawing.drawActions.lastIndexWhere((action) => action is ClearAction);

    if (lastClearIndex != -1) {
      relevantActions = provider.drawing.drawActions.sublist(lastClearIndex);
    }
    else {
      relevantActions = provider.drawing.drawActions;
    }

    for (final action in relevantActions) {
      if (action is StrokeAction && action.points.isNotEmpty) {
        final strokePoints = action.points.map((point) {
          return mlkit.StrokePoint(
            x: point.dx,
            y: point.dy,
            t: DateTime.now().millisecondsSinceEpoch,
          );
        }).toList();

        final stroke = mlkit.Stroke()..points = strokePoints;
        strokes.add(stroke);
      }
    }

    return mlkit.Ink()..strokes = strokes;
  }

  // Clears the model cache for the current language.
  Future<void> clearModelCache() async {
    await _modelManager.deleteModel(_languageTag);
    notifyListeners();
  }

  void clearResults() {
    _results = [];
    notifyListeners();
  }

  @override
  void dispose() {
    _recognizer?.close();
    super.dispose();
  }
}