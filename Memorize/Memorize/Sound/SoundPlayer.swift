//
//  SoundPlayer.swift
//  Memorize
//  Control sound player
//  Created by Uri on 12/5/24.
//

import Foundation
import AVKit

class SoundPlayer {
    var player: AVAudioPlayer?
    
    func play(withURL: URL) {
        player = try! AVAudioPlayer(contentsOf: withURL)
        player?.prepareToPlay()
        player?.play()
    }
}
