//
//  Player.swift
//  Reversi
//
//  Created by Vladislav Garifulin on 16.01.2021.
//

import Foundation

class Player: PlayerProtocol {
    private(set) var thinking = false
    weak var delegate: PlayerDelegate?
    var rules: RulesProtocol
    
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
}
