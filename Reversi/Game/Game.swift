//
//  Game.swift
//  Reversi
//
//  Created by Vladislav Garifulin on 07.01.2021.
//

import Foundation

final class Game: GameProtocol, PlayerDelegate {
    weak var delegate: GameDelegate?
    private var moveColor: Square = .black
    private var rules: RulesProtocol
    var blackPlayer: PlayerProtocol {
        didSet {
            blackPlayer.delegate = self
        }
    }
    var whitePlayer: PlayerProtocol {
        didSet {
            whitePlayer.delegate = self
        }
    }
    
    required init(rules: RulesProtocol, blackPlayer: PlayerProtocol, whitePlayer: PlayerProtocol, delegate: GameDelegate) {
        self.rules = rules
        self.blackPlayer = blackPlayer
        self.whitePlayer = whitePlayer
        self.blackPlayer.delegate = self
        self.whitePlayer.delegate = self
        self.delegate = delegate
        findMove()
    }
    
    func findMove() {
        if (rules.doesMoveExist(color: moveColor)) {
            playerToMove().findMove(color: moveColor)
        } else {
            moveColor = moveColor.opposite()
            if (rules.doesMoveExist(color: moveColor)) {
                playerToMove().findMove(color: moveColor)
            } else {
                print("Game is over")
            }
        }
    }
    
    func playerToMove() -> PlayerProtocol {
        return (moveColor == .black) ? blackPlayer : whitePlayer
    }
    
    func waitingForTouch() -> Bool {
        return (playerToMove() is Player) && (playerToMove().getThinking())
    }
    
    func canTake(move: BP) -> Bool {
        return rules.isValid(move: move, color: moveColor)
    }
    
    func take(move: BP) {
        rules.make(move: move, color: moveColor)
        moveColor = moveColor.opposite()
        delegate?.didMove()
        findMove()
    }
}
