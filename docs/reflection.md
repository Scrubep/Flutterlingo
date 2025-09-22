# Course topics applied
We applied data persistance through Isar, similarly to Journal, Querying web services (API), Gesture Detection, Drawing with Canvas, Internationalization, and Undo/Redo.

Our app reflects what we learned in lecture 9 about inclusive design by following guidelines of WCAG and principles of inclusive design. We understand that we are not the user and many populations may use assistive technology to engage with our app. Because of this, we included semantic labeling for buttons and other features throughout our views so voiceover can have descriptive details for those reliant on the assistance. Our views also have colors that meet the minimum requirement for contrast so all users can engage with the app fully without the visual challenages.

# Citation
Went to OH with Lauren and Elise to debug github issues along with minor bugs. Went to 1:30 and 12:30 sections as well.

Our implementation of undo, redo, and clear are heavily influenced by our drawing assignment and its code. We also used our journal assignment code for some of the listviews and data persistance logic. 

On chatGPT, we inputted the body of our entry view to ask "why are there still overflowing space?" In return, they said I had too many expanded widgets and provided a snippet of code that utilized other widgets instead to fix the overflow errors. The fixes did not resolve all our conflicts with overflow unfortunately. 

Links:
https://api.flutter.dev/
https://techdynasty.medium.com/mastering-api-integration-in-flutter-a-step-by-step-journey-from-beginner-to-pro-f1195914149f

# Challenges and deepened understanding of
We have a deepend understanding of how to incorporate accessiblity at the forefront of our design. Through practicing multiple peer edits and inclusivity testing now, we have a good idea of what features are often overlooked in design that may impact a users experience with our app. 

# Changes from original
Our final UI looked very different as compared to our wireframe. We did not have an additional edit view and had the practice and create view all in one. We split the views for easier navigation as it would have gotten too convoluted with all these features in one space. We also had the idea of a naviagtion bar but did not implement it as the back buttons were enough to easily switch between the different views. 

# Two areas of work
We wanted to input the letters of the phrase one at a time to check for correctness of spelling but it currently checks the spelling of the whole phrase. This was a challenge for us and ultimately could not do checking of one letter at a time. We wish to implement this feature in the future. 
Another feature would be additional internationalization by changing the views to reflect the language you select. Because this is a language learning app, we want it to be accessible for people who speak different languages, not just English speakers hoping to practice new langauges. 

# Most valuable lesson
The most valuable lesson learned from this class is that we are not the average consumers of technology. Because we are CS students, we likely are more tech savvy than most of the population. We assume portions of our app to be accessible or easy to navigate but may forget we are in the minority. Most users would have a difficult time engagig with apps especially if there lacks accessibility and assistive technology. It's important to remember inclusivity in all aspects of design.

# Advice
1 - Start on assignments early because you will inevitable run into errors with testing, xCode, gradescope, and other bugs. This allows you to go to OH and get help.

2 - Make use of resubmissions. Resubmissions is a chance for you to continue to dwell deeper into the material and fix your mistakes. It encourages growth as a learner. 