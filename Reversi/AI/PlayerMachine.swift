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

final
class PlayerMachine: Player {
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
        
        if depth < self.depth {    //Текущая глубина < Максимальной
            var nWeight: Int
            let rows = self.rules.board.rows
            for row in 1...rows {
                let cols = rules.board.cols
                for col in 1...cols {
                    if self.rules.isValid(move: BP(row, col), color: moveColor) {
                        let cr = Rules(rules: rules)
                        cr.make(move: BP(row, col), color: moveColor)
                        
                        if self.moveWorkItem.isCancelled { return 0 }
                        
                        //Оценка хода
                        nWeight = -self.minMax(rules: cr, weight: weight, moveColor: moveColor.opposite(), depth: depth + 1, beta: (bestWeight == Int.min) ? Int.max : -bestWeight)
                        
                        if nWeight > beta && beta != Int.min && beta != Int.max { //Отсечение ветки (Альфабета)
                            return nWeight
                        }
                        
                        if nWeight > bestWeight {
                            bestWeight = nWeight
                            if depth == 0 {    //Запоминаем лучший ход
                                self.bestMove = BP(row, col)
                            }
                        }
                    }
                }
            }
            
            if bestWeight == Int.min {    //возможные ходы цветом moveColor отсутствуют
                //будет ходить соперник в этой же позиции
                let cr = Rules(rules: rules)
                
                nWeight = -self.minMax(rules: cr, weight: weight, moveColor: moveColor.opposite(), depth: depth + 1, beta: (bestWeight == Int.min) ? Int.max : -bestWeight)
                
                if nWeight > beta && beta != Int.min && beta != Int.max { //Отсечение ветки (Альфабета)
                    return nWeight
                }
                
                if nWeight > bestWeight {
                    bestWeight = nWeight
                }
            }
        } else {
            if self.weightType != .greed {
                BoardWeight.fill(weight: weight, board: rules.board, type: self.weightType)
            }
            
            let evaluation = Evaluation(board: rules.board, weight: weight, color: moveColor, weightType: self.weightType)
            bestWeight = evaluation.getBoardWeight()
            comb += 1
        }
        
        return bestWeight;
    }
    
    override func findMove(color: Square) {
        super.findMove(color: color)
        self.moveWorkItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            switch self.level {
            case .l1:
                self.weightType = .greed
                self.depth = self.level.rawValue
            case .l2:
                self.weightType = .greedSmart
                self.depth = self.level.rawValue
            default:
                let emptyCount = self.rules.board.countOf(square: .empty)
                if emptyCount <= (self.level.rawValue + self.level.rawValue - 3) {  //Можно просчитать до конца
                    self.weightType = .greed
                    self.depth = self.level.rawValue + self.level.rawValue - 3
                } else {
                    self.weightType = .mobility
                    self.depth = self.level.rawValue
                }
            }
            
            self.bestMove = nil
            self.comb = 0
           
            let weight = Board(rows: self.rules.board.rows, cols: self.rules.board.cols, defaultValue: .weight(value: (self.weightType == .mobility) ? 0 : 3))
            if self.weightType != .greed {
                BoardWeight.fill(weight: weight, board: self.rules.board, type: self.weightType)
            }
            
            var dif = Date().timeIntervalSince1970
            let res = self.minMax(rules: self.rules, weight: weight, moveColor: color, depth: 0, beta: Int.max)
            dif = Date().timeIntervalSince1970 - dif
            print("comb = \(self.comb), res = \(res), sec = \(dif), speed = \(Double(self.comb) / dif)")
            
            if (!self.moveWorkItem.isCancelled) {
                self.make(move: self.bestMove)
                //rules.board.log()
            }
        }

        self.moveQueue.async(execute: moveWorkItem!)
    }
    
    override func stopMove() {
        self.moveWorkItem?.cancel()
        
        super.stopMove()
    }
}

