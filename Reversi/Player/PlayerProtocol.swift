//
//  PlayerInterface.swift
//  Reversi
//
//  Created by Vladislav Garifulin on 09.01.2021.
//

import Foundation

protocol PlayerProtocol: AnyObject {
    var delegate: PlayerDelegate? { get set }
    func findMove(color: Square)
    func stopMove()
    func canTake(move: BP, color: Square) -> Bool
    func take(move: BP, color: Square)
    func doesMoveExist(color: Square) -> Bool
    func getThinking() -> Bool
}
