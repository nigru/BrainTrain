//
//  GameActivityItemSource.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 27.07.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import UIKit

class GameActivityItemSource: NSObject, UIActivityItemSource {

    let game: GameProtocol

    init(game: GameProtocol) {
        self.game = game
    }

    @objc func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return ""
    }

    public func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivityType) -> Any? {
        return "Im Spiel \"\(self.game.name) \(self.game.level)\" habe ich \(self.game.score) Punkte erreicht. Schaffst du mehr?"
    }

    @objc func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivityType?) -> String {
        return "Herausforderung"
    }
}
