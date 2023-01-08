//
//  BoardProtocol.swift
//  Reversi
//
//  Created by Vladislav Garifulin on 05.01.2021.
//

import Foundation

protocol BoardProtocol: AnyObject {
    init(board: BoardProtocol)
    init(rows: Int, cols: Int, defaultValue: Square)
    var rows: Int { get }
    var cols: Int { get }
    var squares: [Square] { get }
    subscript(row: Int, col: Int) -> Square { get set }
    func getAngles() -> [BoardAngle]
    func getAnglePoints() -> [BP]
    func countOf(square: Square) -> Int
    var count: Int { get }
    func within(bp: BP) -> Bool
    func log()
}
