# Stanford 2023 - Memorize
App made following Stanford University's course CS193p (Developing Applications for iOS using SwiftUI) - https://cs193p.sites.stanford.edu/2023

Memory game to match emojis, user can play with several themed decks
⚠️⚠️ Project in construction ⚠️⚠️

## This app features 
- MVVM architecture
- Model for game conforming to Equatable, Identifiable and CustomDebugStringConvertible
- Logic implemented in Model for game: Creation of game, shuffle of cards, chosing a card and comparing it with the next one chosen, score for the game
- Model for card decks
  
- Animations
- Transitions
- MatchedGeometryEffect

- Options menu to select the deck, the card color and to check the scoreboard
- Button to start / restart the game

- Languages: Localized in Catalan, English and Spanish

**Components**
- AnimatedactionButton: Button with its actions animated
- AspectVGrid: View resizes its components in a LazyVGrid according to how many of them are created at the begining of the game, using GeometryReader
- FlyingNumber: The score of each play goes up or down of the card using offset & opacity
- PieShape: A circle that diminishes using TimeInterval, the smaller the less score for the play
- Cardify: Animatable & ViewModifier to give a look & feel of a game card, including a rotation3DEffect

 **Extensions**
- Extension "only" for Array, to return the only element if the array is of one element 

## License

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/) [MIT](https://choosealicense.com/licenses/mit/) 
