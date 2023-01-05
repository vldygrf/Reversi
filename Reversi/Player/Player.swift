//
//  Player.swift
//  Reversi
//
//  Created by Vladislav Garifulin on 16.01.2021.
//

import Foundation

class Player: PlayerProtocol {
    weak var delegate: PlayerDelegate?
    private(set) var rules: RulesProtocol
    private(set) var thinking = false
    
    required init(rules: RulesProtocol) {
        self.rules = rules
    }
    
    func findMove(color: Square) {
        self.thinking = true
    }
    
    func make(move: BP) {
        self.delegate?.take(move: move)
        self.thinking = false
    }
    
    func stopMove() {
        self.thinking = false
    }
    
    func touchable() -> Bool {
        return true
    }
}
