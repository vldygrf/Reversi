//
//  Player.swift
//  Reversi
//
//  Created by Vladislav Garifulin on 16.01.2021.
//

import Foundation

class Player: PlayerProtocol {
    private var thinking = false
    weak var delegate: PlayerDelegate?
    var rules: RulesProtocol
    
    func getThinking() -> Bool {
        return thinking
    }
    
    required init(rules: RulesProtocol) {
        self.rules = rules
    }
    
    func findMove(color: Square) {
        thinking = true
    }
    
    func canTake(move: BP, color: Square) -> Bool {
        return rules.isValid(move: move, color: color)
    }
    
    func take(move: BP, color: Square) {
        rules.make(move: move, color: color)
        delegate?.didMove(player: self)
        thinking = false
    }
    
    func doesMoveExist(color: Square) -> Bool {
        return rules.doesMoveExist(color: color)
    }
    
    func stopMove() {
        thinking = false
    }
}
