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
            let angles = board.getAngles()
            var i = 0
            while i < angles.count  {
                weight[angles[i].point.row, angles[i].point.col] = .weight(value: 200)
                let empty = (board[angles[i].point.row, angles[i].point.col] == .empty)
                weight[angles[i].diaPoint.row, angles[i].diaPoint.col] = empty ? .weight(value: -20) : .weight(value: 4)
                weight[angles[i].horPoint.row, angles[i].horPoint.col] = empty ? .weight(value: 0) : .weight(value: 6)
                weight[angles[i].verPoint.row, angles[i].verPoint.col] = empty ? .weight(value: 0) : .weight(value: 6)
                i += 1
            }
            //грани
            i = 3
            while i <= board.rows - 2 {
                weight[1, i] = .weight(value: 6)
                weight[i, board.cols] = .weight(value: 6)
                weight[board.rows, i] = .weight(value: 6)
                weight[i, 1] = .weight(value: 6)
                i += 1
            }
        case .mobility:
            let angles = board.getAngles()
            var i = 0
            while i < angles.count  {
                weight[angles[i].point.row, angles[i].point.col] = .weight(value: 350)
                let empty = board[angles[i].point.row, angles[i].point.col] == .empty
                if !empty && weight[angles[i].diaPoint.row, angles[i].diaPoint.col].value != 0 {
                    weight[angles[i].diaPoint.row, angles[i].diaPoint.col] = .weight(value: 0)
                    weight[angles[i].horPoint.row, angles[i].horPoint.col] = .weight(value: 0)
                    weight[angles[i].verPoint.row, angles[i].verPoint.col] = .weight(value: 0)
                } else
                if empty && weight[angles[i].diaPoint.row, angles[i].diaPoint.col].value != -85 {
                    weight[angles[i].diaPoint.row, angles[i].diaPoint.col] = .weight(value: -85)
                    weight[angles[i].horPoint.row, angles[i].horPoint.col] = .weight(value: -12)
                    weight[angles[i].verPoint.row, angles[i].verPoint.col] = .weight(value: -12)
                }
                i += 1
            }
        default:
            return
        }
    }
}
