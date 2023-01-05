//
//  Rules.swift
//  Reversi
//
//  Created by Vladislav Garifulin on 06.01.2021.
//

import Foundation

final class Rules: RulesProtocol {
    private(set) var board: BoardProtocol
    
    required init(board: BoardProtocol) {
        self.board = board
    }
    
    init(rules: RulesProtocol) {
        self.board = Board(board: rules.board)
    }
    
    func opposite(square: Square, color: Square) -> Bool {
        return (square == .black && color == .white) || (square == .white && color == .black)
    }
    
    func isValid(direction: BP, start: BP, color: Square) -> Bool {
        var enemyChips = false
            
        var pos = BP(start.row + direction.row, start.col + direction.col)
        while (self.board[pos.row, pos.col] != .frame) {
            if self.board[pos.row, pos.col] == .empty {
                return false
            } else
            if self.opposite(square: self.board[pos.row, pos.col], color: color) {
                enemyChips = true
            } else
            if self.board[pos.row, pos.col] == color {
                return enemyChips
            }
            
            pos.add(direction)
        }
            
        return false
    }
    
    func isValid(move: BP, color: Square) -> Bool {
        return (self.board[move.row, move.col] == .empty
                &&
            (  self.isValid(direction: BP(0, -1), start: move, color: color)
            || self.isValid(direction: BP(1, -1), start: move, color: color)
            || self.isValid(direction: BP(1, 0), start: move, color: color)
            || self.isValid(direction: BP(1, 1), start: move, color: color)
            || self.isValid(direction: BP(0, 1), start: move, color: color)
            || self.isValid(direction: BP(-1, 1), start: move, color: color)
            || self.isValid(direction: BP(-1, 0), start: move, color: color)
            || self.isValid(direction: BP(-1, -1), start: move, color: color)
            )
        )
    }
    
    func reverse(direction: BP, start: BP, color: Square) {
        if !self.isValid(direction: direction, start: start, color: color) {
            return
        }
        
        var pos = BP(start.row + direction.row, start.col + direction.col)
        while(self.opposite(square: self.board[pos.row, pos.col], color: color)) {
            self.board[pos.row, pos.col] = color //ставим фишку
            pos.add(direction)
        }
    }
    
    func make(move:BP, color: Square) {
        self.board[move.row, move.col] = color  //ставим фишку
        self.reverse(direction: BP(0, -1), start: move, color: color)
        self.reverse(direction: BP(1, -1), start: move, color: color)
        self.reverse(direction: BP(1, 0), start: move, color: color)
        self.reverse(direction: BP(1, 1), start: move, color: color)
        self.reverse(direction: BP(0, 1), start: move, color: color)
        self.reverse(direction: BP(-1, 1), start: move, color: color)
        self.reverse(direction: BP(-1, 0), start: move, color: color)
        self.reverse(direction: BP(-1, -1), start: move, color: color)
    }
    
    func doesMoveExist(color: Square) -> Bool {
        for row in 1...self.board.rows {
            for col in 1...self.board.cols {
                if self.isValid(move: BP(row, col), color: color) {
                    return true
                }
            }
        }
        return false
    }
    
    func doesMoveExist() -> Bool {
        return self.doesMoveExist(color: .black) || self.doesMoveExist(color: .white)
    }
}
