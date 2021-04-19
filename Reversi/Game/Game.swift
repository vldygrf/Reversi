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
    
    required init(blackPlayer: PlayerProtocol, whitePlayer: PlayerProtocol, delegate: GameDelegate) {
        self.blackPlayer = blackPlayer
        self.whitePlayer = whitePlayer
        self.blackPlayer.delegate = self
        self.whitePlayer.delegate = self
        self.delegate = delegate
        findMove()
    }
    
    func findMove() {
        if (playerToMove().doesMoveExist(color: moveColor)) {
            playerToMove().findMove(color: moveColor)
        } else {
            moveColor = moveColor.opposite()
            if (playerToMove().doesMoveExist(color: moveColor)) {
                playerToMove().findMove(color: moveColor)
            } else {
                print("Game is over")
            }
        }
    }
    
    func playerToMove() -> PlayerProtocol {
        return (moveColor == .black) ? blackPlayer : whitePlayer
    }
    
    func didMove(player: PlayerProtocol) {
        moveColor = moveColor.opposite()
        delegate?.didMove()
        findMove()
    }
    
    func waitingForTouch() -> Bool {
        return (playerToMove() is Player) && (playerToMove().getThinking())
    }
    
    func canTake(move: BP) -> Bool {
        return playerToMove().canTake(move: move, color: moveColor)
    }
    
    func take(move: BP) {
        playerToMove().take(move: move, color: moveColor)
    }
}
