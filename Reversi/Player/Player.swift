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
    
    func make(move: BP) {
        delegate?.take(move: move)
        thinking = false
    }
    
    func stopMove() {
        thinking = false
    }
}
