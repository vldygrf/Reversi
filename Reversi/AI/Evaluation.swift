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
        
        if (weightType == .mobility) {
            /*let angles = weight.getAngles()   //работает немного быстрее
            for angle in angles {
                if (board[angle.point.row, angle.point.col] == color) {
                    value += weight[angle.point.row, angle.point.col].value
                    chips += 1
                } else
                if (board[angle.point.row, angle.point.col] == colorOpposite) {
                    value -= weight[angle.point.row, angle.point.col].value
                    chipsOpposite -= 1
                }
                if (board[angle.horPoint.row, angle.horPoint.col] == color) {
                    value += weight[angle.horPoint.row, angle.horPoint.col].value
                    chips += 1
                } else
                if (board[angle.horPoint.row, angle.horPoint.col] == colorOpposite) {
                    value -= weight[angle.horPoint.row, angle.horPoint.col].value
                    chipsOpposite -= 1
                }
                if (board[angle.verPoint.row, angle.verPoint.col] == color) {
                    value += weight[angle.verPoint.row, angle.verPoint.col].value
                    chips += 1
                } else
                if (board[angle.verPoint.row, angle.verPoint.col] == colorOpposite) {
                    value -= weight[angle.verPoint.row, angle.verPoint.col].value
                    chipsOpposite -= 1
                }
                if (board[angle.diaPoint.row, angle.diaPoint.col] == color) {
                    value += weight[angle.diaPoint.row, angle.diaPoint.col].value
                    chips += 1
                } else
                if (board[angle.diaPoint.row, angle.diaPoint.col] == colorOpposite) {
                    value -= weight[angle.diaPoint.row, angle.diaPoint.col].value
                    chipsOpposite -= 1
                }
            }*/
            let aps = weight.getAnglePoints()
            for ap in aps {
                if (board[ap.row, ap.col] == color) {
                    value += weight[ap.row, ap.col].value
                    chips += 1
                } else
                if (board[ap.row, ap.col] == colorOpposite) {
                    value -= weight[ap.row, ap.col].value
                    chipsOpposite -= 1
                }
            }
            
            value += getMobilityWeight()
            
            if (chips == 0) {
                value -= Values.bonus;    //Штрафуем
            } else
            if (chipsOpposite == 0) {
                value += Values.bonus;    //Стимулируем
            }
        } else {
            for row in 1...board.rows {
                for col in 1...board.cols {
                    if (board[row, col] == color) {
                        value += weight[row, col].value
                        //chips += 1
                    } else
                    if (board[row, col] == colorOpposite) {
                        value -= weight[row, col].value
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
        
        init(value: Int, potential: Int) {
            self.value = value
            self.potential = potential
        }
        
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
        
        while(board[curr.row, curr.col] != .frame) {
            if ((board[curr.row, curr.col] == .empty) && (qbb == color) && (qb == colorOpposite)) {
                mobility.value += 1
                qbb = .frame
                qb = .frame
                curr.add(direction)
                k += 1
                continue    //потенц. моб. в этом случае считать не нужно
            }else
            if ((board[curr.row, curr.col] == color) && (qbb == .frame) && (qb == colorOpposite)) {
                mobility.value += 1
                mobility.potential -= 1    //данная пот. мобильность лишняя (обычная мобильность перебивает)
            }
            
            //Вычитаем мобильность противника
            if ((board[curr.row, curr.col] == .empty) && (qbb == colorOpposite) && (qb == color)) {
                mobility.value -= 1
                qbb = .frame
                qb = .frame
                curr.add(direction)
                k += 1
                continue    //потенц. моб. в этом случае считать не нужно
            }else
            if ((board[curr.row, curr.col] == colorOpposite) && (qbb == .empty) && (qb == color)) {
                mobility.value -= 1
                mobility.potential += 1     //данная пот. мобильность лишняя (обычная мобильность перебивает)
            }
            
            //Потенциальная мобильность
            if (    (   (board[curr.row, curr.col] == .empty) && (qb == colorOpposite)
                    &&  (k > 1)        //не нужно у края считать пот. мобильность (т.к. за краем фишек нет)
                    &&  (board[curr.row + direction.row, curr.col + direction.col] != colorOpposite))    //эту потенц. мобильность посчит. в след. итерации
                ||  (   (board[curr.row, curr.col] == colorOpposite) && (qb == .empty)
                    &&  (board[curr.row + direction.row, curr.col + direction.col] != .frame))//не нужно у края считать пот. мобильность (т.к. за краем фишек нет)
            ) {
                mobility.potential += 1
            }
            
            //Вычитаем потенциальную мобильность противника
            if (    (   (board[curr.row, curr.col] == .empty) && (qb == color)
                     && (k > 1)        //не нужно у края считать пот. мобильность (т.к. за краем фишек нет)
                     && (board[curr.row + direction.row, curr.col + direction.col] != color))    //эту потенц. мобильность посчит. в след. итерации
                ||  (   (board[curr.row, curr.col] == color) && (qb == .empty)
                    && (board[curr.row, curr.col] != .frame))   //не нужно у края считать пот. мобильность (т.к. за краем фишек нет)
            ) {
                mobility.potential -= 1
            }
            
            
            if (board[curr.row, curr.col] != qb) {    //запоминаем пред. состояния
                qbb = qb
                qb = board[curr.row, curr.col]
            }
            
            curr.add(direction)
            k += 1
        }
        
        return mobility
    }
    //-------------------------------------------------------------------------------------------
    func getMobilityWeight() -> Int {
        var mobility = Mobility(value: 0, potential: 0)
        
        for i in 1...board.cols { //т.к. поле у нас квадратное делаем в одном цикле
            //вертикали
            mobility.add(getLineMobilityWeight(start: BP(1, i), direction: BP(1, 0)))
            //горизонтали
            mobility.add(getLineMobilityWeight(start: BP(i, 1), direction: BP(0, 1)))
            
            if (i < (board.cols - 2)) {
                //главная диагональ и параллельные лежащие выше
                mobility.add(getLineMobilityWeight(start: BP(1, i), direction: BP(1, 1)))
                //побочная диагональ и паралллельные лежащие выше
                mobility.add(getLineMobilityWeight(start: BP(board.cols - i + 1, 1), direction: BP(-1, 1)))
                
                if (i > 1) {
                    //диагонали паралллельные главной и лежащие ниже
                    mobility.add(getLineMobilityWeight(start: BP(i, 1), direction: BP(1, 1)))
                    //диагонали паралллельные побочной и лежащие ниже
                    mobility.add(getLineMobilityWeight(start: BP(board.cols, i), direction: BP(-1, 1)))
                }
            }
        }
        
        return mobility.value * Values.mobility + mobility.potential * Values.potentialMobility
    }
}
