# Stanford 2023 - Memorize
Memory game app made following Stanford University's course CS193p (Developing Applications for iOS using SwiftUI) - https://cs193p.sites.stanford.edu/2023

⚠️⚠️ Project in construction ⚠️⚠️

## Features

- MVVM architecture
- Model conforming to Equatable, Identifiable and CustomDebugStringConvertible
- Logic implemented in Model: Creation of game, shuffle of cards, chosing a card and comparing it with the next one chosen, score for the game
  
- Animations
- Transitions
- MatchedGeometryEffect

- Components:
  - AspectVGrid: View resizes its components in a LazyVGrid according to how many of them are created at the begining of the game, using GeometryReader
  - FlyingNumber: The score of each play goes up or down of the card using offset & opacity
  - PieShape: A circle that diminishes using TimeInterval, the smaller the less score for the play
  - Cardify: Animatable & ViewModifier to give a look & feel of a game card, including a rotation3DEffect
 
- Extension "only" for Array, to return the only element if the array is of one element 
