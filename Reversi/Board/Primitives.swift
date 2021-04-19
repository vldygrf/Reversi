//
//  Primitives.swift
//  Reversi
//
//  Created by Vladislav Garifulin on 19.04.2021.
//

import Foundation

struct BP {
    var row: Int
    var col: Int
    
    init(_ row: Int, _ col: Int) {
        self.row = row
        self.col = col
    }
    
    init(point: BP) {
        row = point.row
        col = point.col
    }
    
    mutating func add(_ point: BP) {
        row += point.row
        col += point.col
    }
}

enum Square: Equatable {
    case empty
    case white
    case black
    case frame
    case weight(value: Int)
    
    var value: Int {
        switch self {
        case .weight(let value):
            return value
        default:
            return 0
        }
    }
    
    func opposite() -> Square {
        return (self == .white) ? .black : .white
    }
    
    func resource() -> String {
        switch self {
        case .white:
            return "White"
        case .black:
            return "Black"
        case .empty:
            return "Empty"
        default:
            return ""
        }
    }
    
    func letter() -> String {
        switch self {
        case .white:
            return "w"
        case .black:
            return "b"
        case .empty:
            return " "
        case .frame:
            return "X"
        case let .weight(value: value):
            return " \(value) "
        }
    }
}

struct BoardAngle {
    let point: BP
    let diaPoint: BP
    let horPoint: BP
    let verPoint: BP
    
    init(_ point: BP, diaPoint: BP, horPoint: BP, verPoint: BP) {
        self.point = point
        self.diaPoint = diaPoint
        self.horPoint = horPoint
        self.verPoint = verPoint
    }
}
