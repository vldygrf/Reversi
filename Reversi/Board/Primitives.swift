//
//  Primitives.swift
//  Reversi
//
//  Created by Vladislav Garifulin on 19.04.2021.
//

import Foundation

struct BP: Equatable {
    var row: Int
    var col: Int
    
    init(_ row: Int, _ col: Int) {
        self.row = row
        self.col = col
    }
    
    init(point: BP) {
        self.row = point.row
        self.col = point.col
    }
    
    mutating func add(_ point: BP) {
        self.row += point.row
        self.col += point.col
    }
}

enum Square: Equatable {
    case empty
    case white
    case black
    case frame
    case weight(value: Int)
    case whitePossible
    case blackPossible
    
    var value: Int {
        switch self {
        case .weight(let value):
            return value
        default:
            return 0
        }
    }
    
    func opposite() -> Square {
        return self == .white ? .black : .white
    }
    
    func possible() -> Square {
        return self == .white ? .whitePossible : self == .black ? .blackPossible : self
    }
    
    func resource() -> String {
        switch self {
        case .white:
            return "White"
        case .black:
            return "Black"
        case .empty:
            return "Empty"
        case .blackPossible:
            return "BlackPossible"
        case .whitePossible:
            return "WhitePossible"
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
        case .whitePossible,.blackPossible:
            return "p"
        }
    }
}

struct BoardAngle {
    let point: BP
    let diaPoint: BP
    let horPoint: BP
    let verPoint: BP
}
