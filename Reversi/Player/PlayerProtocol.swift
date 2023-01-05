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
    func make(move: BP)
    var thinking: Bool { get }
    func touchable() -> Bool
}
