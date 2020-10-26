Lucid Text:

Type: Educational

xcodeproject Name: **"LucidText.xcodeproj"** in the outermost folder (ignore the project in the folder "swift")
Associated swift files are in the folder: "LucidText" (ignore the folders "swift", "MapKit", and "OldVCs")

Works on **Iphone8** and **Iphone11**.

Link to Demo: https://vimeo.com/410739832

Note: Demo was filled on Zoom so we could not demonstrate the "No Wifi" handler for the API calls. You can test it out yourself and see an alert view controller pop up for both the HomeViewController and ProcessedTextTwoViewController, and mapScreen.

Purpose:
For people that are trying to improve their english literacy.

Say you come across something online that you read and don’t understand. Copy and paste it into LucidText and it will automatically identify challenging words and provide definitions, synonyms, and translations to the 6 most popular languages: Spanish, Portuguese, Arabic, Hindi, Bengali, and Mandarin.

Features:

1. Breakdown complex diction by actively defining difficult words (difficulty can be modified so it is tunable to the user)
2. Save difficult words to a personal dictionary.
4. Display translations, definitions, and synonyms to user (and parse text and catch errors well)
5. Handle vertical and horizontal (rotated) display of iphone
6. Text Entry Organization: Handle repeated words, special character inputs, lists that max out API capacity of fetching 60 definitions per minute, parse words by special characters so words all of the words of a text entry can be found.

Contributors:
Tommy Tilton: UIDevelopment, Design, view controller and API integration 

Vikram Ruppa-Kasani: API and API integration (Dictionary, Thesaraus, PhraseFinder) 

Arjun Rao: API, API integratino, some view elements (Dictionary, Thesaraus, PhraseFinder) 

Conner Lewis: MapKit and Logo

Vin Somasundaram: MapKit and Language API Integration


APIs -
Oxford API: Get definitions and synonyms.
PhraseFinder API: Get text frequency to determine how “common” a word is
Google translate: Get translations for languages.

Databases -

We want to store dictionary entries (word, definition, synonyms, translations) in a SQlite database to limit the number of api calls. We also need another SQlite database to hold store saved vocabulary words

Frameworks -

MapKit
CoreData

Storyboard -

Every displayed view controller is a UICollectionViewController except HomeViewController which is a normal UIViewController. Each UICollectionViewController uses custom collectionViewCells.

