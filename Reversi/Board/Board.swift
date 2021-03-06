//
//  Board.swift
//  Reversi
//
//  Created by Vladislav Garifulin on 05.01.2021.
//

import Foundation

final
class Board: BoardProtocol {
    let rows: Int
    let cols: Int
    let count: Int
    var squares: [Square] = []
    private var anglePoints: [BP] = []
    private var angles: [BoardAngle] = []
    
    required init(rows: Int, cols: Int, defaultValue: Square) {
        self.rows = rows
        self.cols = cols
        self.count = rows * cols
        self.squares = Array(repeating: defaultValue, count: (rows + 2) * (cols + 2))
    
        for col in 0..<cols+2 {
            self[0, col] = .frame
            self[rows + 1, col] = .frame
        }
        
        for row in 0..<rows+2 {
            self[row, 0] = .frame
            self[row, cols + 1] = .frame
        }
        
        if (defaultValue == .empty) {   //game board
            let pos = BP(rows / 2, cols / 2)
            self[pos.row, pos.col] = .black
            self[pos.row + 1, pos.col + 1] = .black
            self[pos.row, pos.col + 1] = .white
            self[pos.row + 1, pos.col] = .white
        }
    }
    
    required init(board: BoardProtocol) {
        self.rows = board.rows
        self.cols = board.cols
        self.count = board.count
        self.squares = board.squares
    }
    
    private func indexIsValid(row: Int, col: Int) -> Bool {
        return row >= 0 && row < self.rows + 2 && col >= 0 && col < self.cols + 2
    }
    
    func log() {
        for row in (0..<(self.rows+2)).reversed() {
            var s = ""
            for col in 0..<(self.cols+2) {
                s += self[row, col].letter()
            }
            
            print(s)
        }
    }
    
    subscript(row: Int, col: Int) -> Square {
        get {
            assert(self.indexIsValid(row: row, col: col), "Index out of range")
            return self.squares[(row * (cols + 2)) + col]
        }
        set {
            assert(self.indexIsValid(row: row, col: col), "Index out of range")
            self.squares[(row * (cols + 2)) + col] = newValue
        }
    }
    
    func getAnglePoints() -> [BP] {
        if self.anglePoints.count == 0 {
            let angles = self.getAngles()
            for angle in angles {
                self.anglePoints.append(angle.point)
                self.anglePoints.append(angle.diaPoint)
                self.anglePoints.append(angle.verPoint)
                self.anglePoints.append(angle.horPoint)
            }
        }
        
        return self.anglePoints
    }
    
    func getAngles() -> [BoardAngle] {
        if self.angles.count == 0 {
            self.angles.append(BoardAngle(point: BP(1, 1), diaPoint: BP(2, 2), horPoint: BP(1, 2), verPoint: BP(2, 1)))
            self.angles.append(BoardAngle(point: BP(self.rows, 1), diaPoint: BP(self.rows - 1, 2), horPoint: BP(self.rows, 2), verPoint: BP(self.rows - 1, 1)))
            self.angles.append(BoardAngle(point: BP(self.rows, cols), diaPoint: BP(self.rows - 1, self.cols - 1), horPoint: BP(self.rows, self.cols - 1), verPoint: BP(self.rows - 1, self.cols)))
            self.angles.append(BoardAngle(point: BP(1, self.cols), diaPoint: BP(2, self.cols - 1), horPoint: BP(1, self.cols - 1), verPoint: BP(2, self.cols)))
        }
        return angles
    }
    
    func countOf(square: Square) -> Int {
        var count = 0
        for row in 1...self.rows {
            for col in 1...self.cols {
                if (self[row, col] == square) {
                    count += 1
                }
            }
        }
        
        return count
    }
}
