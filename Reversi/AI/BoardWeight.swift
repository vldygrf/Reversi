//
//  BoardCost.swift
//  Reversi
//
//  Created by Vladislav Garifulin on 23.03.2021.
//

import Foundation

enum BoardWeightType {
    case greed
    case greedSmart
    case mobility
}

final class BoardWeight {
    static func fill(weight: BoardProtocol, board: BoardProtocol, type: BoardWeightType) {
        switch type {
        case .greedSmart:
            //Углы + смежные с углами клетки
            for angle in board.getAngles() {
                weight[angle.point.row, angle.point.col] = .weight(value: 200)
                let empty = (board[angle.point.row, angle.point.col] == .empty)
                weight[angle.diaPoint.row, angle.diaPoint.col] = empty ? .weight(value: -20) : .weight(value: 4)
                weight[angle.horPoint.row, angle.horPoint.col] = empty ? .weight(value: 0) : .weight(value: 6)
                weight[angle.verPoint.row, angle.verPoint.col] = empty ? .weight(value: 0) : .weight(value: 6)
            }
            //грани
            for i in 3...board.rows - 2 {
                weight[1, i] = .weight(value: 6)
                weight[i, board.cols] = .weight(value: 6)
                weight[board.rows, i] = .weight(value: 6)
                weight[i, 1] = .weight(value: 6)
            }
        case .mobility:
            let angles = board.getAngles()
            for angle in angles {
                weight[angle.point.row, angle.point.col] = .weight(value: 350)
                let empty = board[angle.point.row, angle.point.col] == .empty
                if !empty && weight[angle.diaPoint.row, angle.diaPoint.col].value != 0 {
                    weight[angle.diaPoint.row, angle.diaPoint.col] = .weight(value: 0)
                    weight[angle.horPoint.row, angle.horPoint.col] = .weight(value: 0)
                    weight[angle.verPoint.row, angle.verPoint.col] = .weight(value: 0)
                } else
                if empty && weight[angle.diaPoint.row, angle.diaPoint.col].value != -85 {
                    weight[angle.diaPoint.row, angle.diaPoint.col] = .weight(value: -85)
                    weight[angle.horPoint.row, angle.horPoint.col] = .weight(value: -12)
                    weight[angle.verPoint.row, angle.verPoint.col] = .weight(value: -12)
                }
            }
        default:
            return
        }
    }
}
