//
//  RulesProtocol.swift
//  Reversi
//
//  Created by Vladislav Garifulin on 06.01.2021.
//

import Foundation

protocol RulesProtocol: AnyObject {
    var board: BoardProtocol { get }
    func isValid(move: BP, color: Square) -> Bool
    func doesMoveExist(color: Square) -> Bool
    func doesMoveExist() -> Bool
    func make(move: BP, color: Square)
}
