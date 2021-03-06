//
//  AudioManager.swift
//  Audiometer
//
//  Created by Sergey Kachan on 2/20/18.
//  Copyright © 2018 Sergey Kachan. All rights reserved.
//

import AudioKit
import RxSwift
import UIKit

class AudioManager {
    let node: AKNode

    init(player: AudioPlayer) {
        node = player.node
    }

    init(players: AudioPlayer...) {
        node = AKMixer(players.map { $0.node })
    }

    func start() {
        do {
            try AudioKit.stop()
        } catch {
            
        }
        
        AudioKit.output = node
        do {
            try AudioKit.start()
        } catch {
            
        }
        AKSettings.enableLogging = false
//        do {
//            try AKSettings.setSession(category: AKSettings.SessionCategory.ambient, with: AVAudioSession.CategoryOptions.interruptSpokenAudioAndMixWithOthers)
//        } catch {
//            print("failed to set category")
//        }
    }

    func stop() {
        do {
            try AudioKit.stop()
        } catch {
        
        }
        
        AudioKit.output = nil
    }
    
    
}

func ||>(controller: UIViewController, manager: AudioManager) -> Disposable {
    return Disposables.create(
        controller.rx.appeared.subscribe(onNext: manager.start),
        controller.rx.disappeared.subscribe(onNext: manager.stop)
    )
}
