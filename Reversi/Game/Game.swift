//
//  Game.swift
//  Reversi
//
//  Created by Vladislav Garifulin on 07.01.2021.
//

import Foundation

final class Game: GameProtocol, PlayerDelegate {
    weak var delegate: GameDelegate?
    private(set) var rules: RulesProtocol
    private(set) var moveColor: Square = .black
    private(set) var blackPlayer: PlayerProtocol {
        didSet {
            self.blackPlayer.delegate = self
        }
    }
    private(set) var whitePlayer: PlayerProtocol {
        didSet {
            self.whitePlayer.delegate = self
        }
    }
    
    required init(rules: RulesProtocol, blackPlayer: PlayerProtocol, whitePlayer: PlayerProtocol) {
        self.rules = rules
        self.blackPlayer = blackPlayer
        self.whitePlayer = whitePlayer
        self.blackPlayer.delegate = self
        self.whitePlayer.delegate = self
        self.findMove()
    }
    
    func findMove() {
        if self.rules.doesMoveExist(color: self.moveColor) {
            self.playerToMove().findMove(color: self.moveColor)
        } else {
            self.moveColor = self.moveColor.opposite()
            if self.rules.doesMoveExist(color: self.moveColor) {
                self.playerToMove().findMove(color: self.moveColor)
            } else {
                print("Game is over")
            }
        }
    }
    
    func playerToMove() -> PlayerProtocol {
        return self.moveColor == .black ? self.blackPlayer : self.whitePlayer
    }
    
    func waitingForTouch() -> Bool {
        return self.playerToMove().touchable() && (self.playerToMove().thinking)
    }
    
    func canTake(move: BP) -> Bool {
        return self.rules.isValid(move: move, color: moveColor)
    }
    
    func take(move: BP) {
        self.rules.make(move: move, color: self.moveColor)
        self.moveColor = self.moveColor.opposite()
        self.delegate?.didMove()
        self.findMove()
    }
}
