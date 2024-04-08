//
//  Scorecard.swift
//  Memorize
//
//  Created by Uri on 7/4/24.
//

import Foundation

struct Scorecard {
    var player: String
    var deck: String
    var matches: Int
    var score: Int
}

#if DEBUG
extension Scorecard {
    static var stub: [Scorecard] {
        [
            Scorecard(player: "Uri", deck: "Halloween", matches: 10, score: 400),
            Scorecard(player: "Darko", deck: "Animals", matches: 15, score: 460),
            Scorecard(player: "Makabre", deck: "Faces", matches: 14, score: 400),
            Scorecard(player: "Larry", deck: "Flora", matches: 20, score: 40),
            Scorecard(player: "Oscar", deck: "Food", matches: 30, score: 400),
            Scorecard(player: "Uri", deck: "Vehicles", matches: 10, score: 400),
            Scorecard(player: "Darko", deck: "Animals", matches: 15, score: 460),
            Scorecard(player: "Makabre", deck: "Countries", matches: 14, score: 400),
            Scorecard(player: "Lofilldigneeeeeeeeee", deck: "Sports", matches: 20, score: 40),
            Scorecard(player: "Oscar", deck: "Animal faces", matches: 30, score: 400)
        ]
    }
}
#endif
