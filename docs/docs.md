# Data structures used

- **Drawing Models**: For drawing, we used different drawing models like draw actions and drawings. Those are then utilized in the drawing area and drawing painter in order to define strokes of ink. Finally, there is drawing provider that controls how drawing are made as well as the state of the drawing with redo, undo, and clear.

- **Entry Models**: There are two models called journal and phrase entry. The journal is where you store the phrase entries. The main instance variables for the phrase entries are text and language which determine what the user practices. There are then three views which are all entries, practice, and edit. These define what screens the user can enter into within the app.

-**Recognition Data Structures (Digital Ink Recognition API)**" The last data structure we used is a digital ink recognizer that can measure the accuracy between actual text and hand written text. This is used throughout the practice view where we change the models whenever a new language is being practiced and then when user's draw on the canvas.

-**Isar**: Used for data persistence and stores phrase entries within a database.

# Data flow

The whole app consists of a journal where phrase entries are stored (persistently using Isar). You can add, edit, or delete phrase entries. All phrase entries are displayed on the home screen. You can click into a phrase entry on the home screen and it goes into a practice screen. 

Here, you can practice the phrase by either writing it out on your key board or manually writing it on the canvas. If you were to do the latter, you can press the "recognize handwriting" button to see if you wrote it correctly. 

If you want to edit the entry, you can select the pencil icon at the top right of the practice view to go into the edit view. Here, you can change the phrase or the language of the phrase you input. 

The three providers (drawing, phrase, recognition) all work in conjunction to propagate changes to the data. The drawing provider allows the user to input their attempts at writing at whatever phrase they practice. The recognition provider then looks at what they wrote and interprets it using a language model. The phrase provider then provides the 'correct' answer which the recognition provider compares to what the user input. 

The whole app consists of a journal where phrase entries are stored (persistently using Isar). You can add, edit, or delete phrase entries. All phrase entries are displayed on the home screen. You can click into a phrase entry on the home screen and it goes into a practice screen. 

Here, you can practice the phrase by either writing it out on your key board or manually writing it on the canvas. If you were to do the latter, you can press the "recognize handwriting" button to see if you wrote it correctly. 

If you want to edit the entry, you can select the pencil icon at the top right of the practice view to go into the edit view. Here, you can change the phrase or the language of the phrase you input. 

The three providers (drawing, phrase, recognition) all work in conjunction to propagate changes to the data. The drawing provider allows the user to input their attempts at writing at whatever phrase they practice. The recognition provider then looks at what they wrote and interprets it using a language model. The phrase provider then provides the 'correct' answer which the recognition provider compares to what the user input. 