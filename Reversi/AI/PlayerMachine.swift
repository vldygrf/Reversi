//
//  PlayerMachine.swift
//  Reversi
//
//  Created by Vladislav Garifulin on 16.01.2021.
//

import Foundation

enum MachineLevel: Int {
    case l1 = 1, l2, l3, l4, l5, l6, l7
}

final class PlayerMachine: Player {
    var level: MachineLevel
    private let moveQueue = DispatchQueue(label: "com.vldygrf.reversi.ai", qos: .userInitiated)
    private var moveWorkItem: DispatchWorkItem!
    private var depth: Int!
    private var weightType: BoardWeightType!
    private var bestMove: BP!
    private var comb: Int = 0   //for debug
    
    required init(rules: RulesProtocol, level: MachineLevel = .l1) {
        self.level = level
        super.init(rules: rules)
    }
    
    required init(rules: RulesProtocol) {
        fatalError("init(rules:) has not been implemented")
    }
    
    func minMax(rules: RulesProtocol, weight: BoardProtocol, moveColor: Square, depth: Int, beta: Int) -> Int {
        var bestWeight = Int.min    //Вес лучшего хода
        
        if (depth < self.depth) {    //Текущая глубина < Максимальной
            var nWeight: Int
            
            for row in 1...rules.board.rows {
                for col in 1...rules.board.cols {
                    if (rules.isValid(move: BP(row, col), color: moveColor)) {
                        let cr = Rules(rules: rules)
                        cr.make(move: BP(row, col), color: moveColor)
                        
                        if (moveWorkItem.isCancelled) { return 0 }
                        
                        //Оценка хода
                        nWeight = -minMax(rules: cr, weight: weight, moveColor: moveColor.opposite(), depth: depth + 1, beta: (bestWeight == Int.min) ? Int.max : -bestWeight)
                        
                        if ((nWeight > beta) && (beta != Int.min) && (beta != Int.max)) { //Отсечение ветки (Альфабета)
                            return nWeight
                        }
                        
                        if (nWeight > bestWeight) {
                            bestWeight = nWeight
                            if (depth == 0) {    //Запоминаем лучший ход
                                bestMove = BP(row, col)
                            }
                        }
                    }
                }
            }
            
            if (bestWeight == Int.min) {    //возможные ходы цветом moveColor отсутствуют
                //будет ходить соперник в этой же позиции
                let cr = Rules(rules: rules)
                
                nWeight = -minMax(rules: cr, weight: weight, moveColor: moveColor.opposite(), depth: depth + 1, beta: (bestWeight == Int.min) ? Int.max : -bestWeight)
                
                if ((nWeight > beta) && (beta != Int.min) && (beta != Int.max)) { //Отсечение ветки (Альфабета)
                    return nWeight
                }
                
                if (nWeight > bestWeight) {
                    bestWeight = nWeight
                }
            }
        } else {
            if (weightType != .greed) {
                BoardWeight.fill(weight: weight, board: rules.board, type: weightType)
            }
            
            let evaluation = Evaluation(board: rules.board, weight: weight, color: moveColor, weightType: weightType)
            bestWeight = evaluation.getBoardWeight()
            comb += 1
        }
        
        return bestWeight;
    }
    
    override func findMove(color: Square) {
        super.findMove(color: color)
        moveWorkItem = DispatchWorkItem { [self] in
            switch level {
            case .l1:
                weightType = .greed
                depth = level.rawValue
            case .l2:
                weightType = .greedSmart
                depth = level.rawValue
            default:
                let emptyCount = rules.board.countOf(square: .empty)
                if (emptyCount <= (level.rawValue + level.rawValue - 3)) {  //Можно просчитать до конца
                    weightType = .greed
                    depth = level.rawValue + level.rawValue - 3
                } else {
                    weightType = .mobility
                    depth = level.rawValue
                }
            }
            
            bestMove = nil
            comb = 0
           
            let weight = Board(rows: rules.board.rows, cols: rules.board.cols, defaultValue: .weight(value: (weightType == .mobility) ? 0 : 3))
            if (weightType != .greed) {
                BoardWeight.fill(weight: weight, board: rules.board, type: weightType)
            }
            
            var dif = Date().timeIntervalSince1970
            let res = minMax(rules: rules, weight: weight, moveColor: color, depth: 0, beta: Int.max)
            dif = Date().timeIntervalSince1970 - dif
            print("comb = \(comb), res = \(res), sec = \(dif), speed = \(Double(comb) / dif)")
            
            if (!moveWorkItem.isCancelled) {
                make(move: bestMove)
                //rules.board.log()
            }
        }

        moveQueue.async(execute: moveWorkItem!)
    }
    
    override func stopMove() {
        moveWorkItem?.cancel()
        
        super.stopMove()
    }
}

