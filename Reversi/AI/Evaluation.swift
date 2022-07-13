//
//  PositionEvaluation.swift
//  Reversi
//
//  Created by Vladislav Garifulin on 17.01.2021.
//

import Foundation

final class Evaluation {
    private enum Values {
        static let bonus = 1000
        static let mobility = 7
        static let potentialMobility = 5
    }
    private let board: BoardProtocol
    private let weight: BoardProtocol
    private let color: Square
    private let colorOpposite: Square
    private let weightType: BoardWeightType
    
    required init(board: BoardProtocol, weight: BoardProtocol, color: Square, weightType: BoardWeightType) {
        self.board = board
        self.weight = weight
        self.color = color
        self.colorOpposite = color.opposite()
        self.weightType = weightType
    }
    
    func getBoardWeight() -> Int {
        var value: Int = 0
        var chips: Int = 0    //Кол-во фишек игрока
        var chipsOpposite: Int = 0    //Кол-во фишек противника
        
        if self.weightType == .mobility {
            /*let angles = weight.getAngles()   //работает немного быстрее
            for angle in angles {
                if (self.board[angle.point.row, angle.point.col] == self.color) {
                    value += self.weight[angle.point.row, angle.point.col].value
                    chips += 1
                } else
                if (self.board[angle.point.row, angle.point.col] == self.colorOpposite) {
                    value -= self.weight[angle.point.row, angle.point.col].value
                    chipsOpposite -= 1
                }
                if (self.board[angle.horPoint.row, angle.horPoint.col] == self.color) {
                    value += self.weight[angle.horPoint.row, angle.horPoint.col].value
                    chips += 1
                } else
                if (self.board[angle.horPoint.row, angle.horPoint.col] == self.colorOpposite) {
                    value -= self.weight[angle.horPoint.row, angle.horPoint.col].value
                    chipsOpposite -= 1
                }
                if (self.board[angle.verPoint.row, angle.verPoint.col] == self.color) {
                    value += self.weight[angle.verPoint.row, angle.verPoint.col].value
                    chips += 1
                } else
                if (self.board[angle.verPoint.row, angle.verPoint.col] == self.colorOpposite) {
                    value -= self.weight[angle.verPoint.row, angle.verPoint.col].value
                    chipsOpposite -= 1
                }
                if (self.board[angle.diaPoint.row, angle.diaPoint.col] == self.color) {
                    value += self.weight[angle.diaPoint.row, angle.diaPoint.col].value
                    chips += 1
                } else
                if (self.board[angle.diaPoint.row, angle.diaPoint.col] == self.colorOpposite) {
                    value -= self.weight[angle.diaPoint.row, angle.diaPoint.col].value
                    chipsOpposite -= 1
                }
            }*/
            let aps = self.weight.getAnglePoints()
            for ap in aps {
                if self.board[ap.row, ap.col] == self.color {
                    value += self.weight[ap.row, ap.col].value
                    chips += 1
                } else
                if self.board[ap.row, ap.col] == self.colorOpposite {
                    value -= self.weight[ap.row, ap.col].value
                    chipsOpposite -= 1
                }
            }
            
            value += self.getMobilityWeight()
            
            if chips == 0 {
                value -= Values.bonus;    //Штрафуем
            } else
            if chipsOpposite == 0 {
                value += Values.bonus;    //Стимулируем
            }
        } else {
            for row in 1...self.board.rows {
                for col in 1...self.board.cols {
                    if self.board[row, col] == self.color {
                        value += self.weight[row, col].value
                        //chips += 1
                    } else
                    if self.board[row, col] == self.colorOpposite {
                        value -= self.weight[row, col].value
                        //chipsOpposite += 1
                    }
                }
            }
        }
        
        return value;
    }
    
    struct Mobility {
        var value: Int
        var potential: Int
        
        mutating func add(_ mobility: Mobility) {
            self.value += mobility.value
            self.potential += mobility.potential
        }
    }
    
    func getLineMobilityWeight(start: BP, direction: BP) -> Mobility {
        var qb: Square = .frame, qbb: Square = .frame
        var k: Int = 0
        var mobility = Mobility(value: 0, potential: 0)
        var curr = start
        
        while(self.board[curr.row, curr.col] != .frame) {
            if self.board[curr.row, curr.col] == .empty && qbb == self.color && qb == self.colorOpposite {
                mobility.value += 1
                qbb = .frame
                qb = .frame
                curr.add(direction)
                k += 1
                continue    //потенц. моб. в этом случае считать не нужно
            }else
            if self.board[curr.row, curr.col] == self.color && qbb == .frame && qb == self.colorOpposite {
                mobility.value += 1
                mobility.potential -= 1    //данная пот. мобильность лишняя (обычная мобильность перебивает)
            }
            
            //Вычитаем мобильность противника
            if self.board[curr.row, curr.col] == .empty && qbb == self.colorOpposite && qb == self.color {
                mobility.value -= 1
                qbb = .frame
                qb = .frame
                curr.add(direction)
                k += 1
                continue    //потенц. моб. в этом случае считать не нужно
            }else
            if self.board[curr.row, curr.col] == self.colorOpposite && qbb == .empty && qb == self.color {
                mobility.value -= 1
                mobility.potential += 1     //данная пот. мобильность лишняя (обычная мобильность перебивает)
            }
            
            //Потенциальная мобильность
            if (    self.board[curr.row, curr.col] == .empty && qb == self.colorOpposite
                 && k > 1       //не нужно у края считать пот. мобильность (т.к. за краем фишек нет)
                 && self.board[curr.row + direction.row, curr.col + direction.col] != self.colorOpposite)    //эту потенц. мобильность посчит. в след. итерации
                ||
                (self.board[curr.row, curr.col] == self.colorOpposite && qb == .empty
                 && self.board[curr.row + direction.row, curr.col + direction.col] != .frame) {//не нужно у края считать пот. мобильность (т.к. за краем фишек нет)
                mobility.potential += 1
            }
            
            //Вычитаем потенциальную мобильность противника
            if (    self.board[curr.row, curr.col] == .empty && qb == self.color
                 && k > 1        //не нужно у края считать пот. мобильность (т.к. за краем фишек нет)
                 && self.board[curr.row + direction.row, curr.col + direction.col] != color)    //эту потенц. мобильность посчит. в след. итерации
                ||
                (   self.board[curr.row, curr.col] == self.color && qb == .empty
                 && self.board[curr.row, curr.col] != .frame) {   //не нужно у края считать пот. мобильность (т.к. за краем фишек нет)
                mobility.potential -= 1
            }
            
            if self.board[curr.row, curr.col] != qb {    //запоминаем пред. состояния
                qbb = qb
                qb = self.board[curr.row, curr.col]
            }
            
            curr.add(direction)
            k += 1
        }
        
        return mobility
    }

    func getMobilityWeight() -> Int {
        var mobility = Mobility(value: 0, potential: 0)
        let items = self.board.cols
        for i in 1...items { //т.к. поле у нас квадратное делаем в одном цикле
            //вертикали
            mobility.add(self.getLineMobilityWeight(start: BP(1, i), direction: BP(1, 0)))
            //горизонтали
            mobility.add(self.getLineMobilityWeight(start: BP(i, 1), direction: BP(0, 1)))
            
            if i < (self.board.cols - 2) {
                //главная диагональ и параллельные лежащие выше
                mobility.add(self.getLineMobilityWeight(start: BP(1, i), direction: BP(1, 1)))
                //побочная диагональ и паралллельные лежащие выше
                mobility.add(self.getLineMobilityWeight(start: BP(board.cols - i + 1, 1), direction: BP(-1, 1)))
                
                if i > 1 {
                    //диагонали паралллельные главной и лежащие ниже
                    mobility.add(self.getLineMobilityWeight(start: BP(i, 1), direction: BP(1, 1)))
                    //диагонали паралллельные побочной и лежащие ниже
                    mobility.add(self.getLineMobilityWeight(start: BP(board.cols, i), direction: BP(-1, 1)))
                }
            }
        }
        
        return mobility.value * Values.mobility + mobility.potential * Values.potentialMobility
    }
}
