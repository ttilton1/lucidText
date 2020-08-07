Cherokee Final Project


Educational Lucid Text:

For people that are trying to improve their english literacy.

Say you come across something online that you read and don’t understand. Copy and paste it into LucidText and it will automatically identify challenging words and provide definitions.

I imagine the user pastes text and the same text reappears with certain words highlighted. When clicked those words show a dictionary definition

Features:

1. Breakdown complex diction by actively defining difficult words (difficulty can be modified so it is tunable to the user)
2. Highlighted words saved to a growing list so people can learn difficult words
3. Siri kit
4. Potentially Flashcard feature to test knowledge
etc

APIs -
Merriam Webster API: Get close synonyms
Lexus Corpuses API: get text frequency to determine how “common” a word is

Databases -

We want to store common definitions in a SQlite database to limit the number of api calls. We also need another SQlite database to hold store saved vocabulary words

Frameworks -

Perhaps implement a mapkit framework that finds closest tutoring center

Storyboard -

Refer to "Lucid_Text_Sketches.pdf" in the main Cherokee Directory for our storyboard. Right now we are envisioning a set of UIViews with UICollection Views. We have no experience with CollectionView yet so should be a good experience.
