//
//  GameProtocol.swift
//  Reversi
//
//  Created by Vladislav Garifulin on 16.01.2021.
//

import Foundation

protocol GameProtocol {
    var delegate: GameDelegate? { get set }
    func waitingForTouch() -> Bool
    func canTake(move: BP) -> Bool
    func take(move: BP)
}
