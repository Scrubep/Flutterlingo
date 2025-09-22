# Starting Repo Structure
You should create a new flutter project (`flutter create -e <project name>`) *inside* the `code` directory.
Put your docs (except README) in the `docs` directory.

Once you start adding things to the `code` and `docs` directories, delete the files named `delete_this_file` from each of those directories, repectively. They are temporary placeholders, because git does not allow the addition of empty directories to a repo.

# Build Instructions
1.  Navigate to the project directory:
    ```bash
    cd code/flutterlingo
    ```

2.  Install dependencies:
    ```bash
    flutter pub get
    ```

3.  Run the application:
    ```bash
    flutter run	
    ```
# Requirements
To build and run this project, you need to have the Flutter SDK installed. You can find installation instructions on the [official Flutter website](https://flutter.dev/docs/get-started/install).

* Some features of the API requires you to run Andriod and does not run on MacOS because it is not supported 
* Deploys all features well on Andriod but not on IOS

# Project Layout
The project is structured as follows:
-   `code/flutterlingo`: Contains the Flutter application source code.
-   `docs`: Contains project documentation.
Within 'code/flutterlingo' is the FlutterLingo project with the following structure:
-   `lib/`: This is the main folder containing all the Dart source code.
-   `pubspec.yaml`: The project's configuration file, where dependencies are managed.
-   `android/` and `ios/`: These folders contain platform-specific project files for Android & iOS devices.
-   `web/`, `windows/`, `macos/`, `linux/`: Platform-specific project files for other supported platforms.
-   `build/`: When building, this holds the project's final output

# Data Structure & Flow

The application's architecture is built around the Provider state management pattern, with different data models, providers, and views. The core data flow revolves around learning phrases through handwriting recognition.

**Data Models:**
-   `PhraseEntry`: Represents a single phrase to be learned. It includes the text of the phrase, the language, and tracking information like creation/update timestamps and a completion status (`isChecked`). These objects are stored persistently using Isar, an object database for Dart.
-   `Journal`: A collection of `PhraseEntry` objects, representing all the phrases a user is learning. It provides methods to interact with the underlying Isar database to add, update, and retrieve phrases.
-   `Drawing`: Represents the user's handwriting on the canvas. It's composed of a list of `DrawAction` objects.
-   `DrawAction`: An abstract class representing a single action on the drawing canvas. Concrete implementations include `StrokeAction` (a series of points), `LineAction`, `ClearAction`, etc. This allows for a detailed representation of the drawing process, including undo/redo functionality.

**Providers:**
-   `PhraseProvider`: Manages the state of the `Journal`. It handles creating, updating, and deleting `PhraseEntry` objects and notifies the UI of any changes.
-   `DrawingProvider`: Manages the state of the drawing canvas. It tracks the list of `DrawAction`s, handles user input to create strokes, and manages undo/redo stacks.
-   `RecognitionProvider`: The central piece that connects drawing to phrase learning. It uses Google's ML Kit for digital ink recognition. It takes a `Drawing` from the `DrawingProvider`, sends it to the ML model for the selected language, and provides the recognized text candidates. It also holds the target phrase and checks if the user's drawing matches it.

**Data Flow:**
1.  A user is presented with a `PhraseEntry` to practice. This phrase is set as the target in the `RecognitionProvider`.
2.  The user draws the phrase on the screen. The `DrawingProvider` records the handwriting as a series of `DrawAction`s.
3.  Upon completion, the `Drawing` is passed to the `RecognitionProvider`.
4.  The provider converts the drawing into a format compatible with ML Kit and sends it for recognition.
5.  ML Kit processes the ink and returns a list of possible text candidates.
6.  The `RecognitionProvider` compares the top candidate with the target phrase.
7.  The UI, listening to the providers, updates to show the recognition results and indicates whether the user's input was correct.
8.  All phrases and their learning progress are persisted in the `Journal` via the `PhraseProvider` and Isar database.

This architecture allows for a reactive user experience where the UI automatically updates in response to changes in the application's state, driven by user interactions.
