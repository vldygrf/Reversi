//
//  Board.swift
//  Reversi
//
//  Created by Vladislav Garifulin on 05.01.2021.
//

import Foundation

final class Board: BoardProtocol {
    let rows: Int, cols: Int, count: Int
    var squares: [Square] = []
    private lazy var anglePoints: [BP] = []
    private lazy var angles: [BoardAngle] = []
    
    required init(rows: Int, cols: Int, defaultValue: Square) {
        self.rows = rows
        self.cols = cols
        count = rows * cols
        squares = Array(repeating: defaultValue, count: (rows + 2) * (cols + 2))
    
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
        rows = board.rows
        cols = board.cols
        count = board.count
        squares = board.squares
    }
    
    func indexIsValid(row: Int, col: Int) -> Bool {
        return row >= 0 && row < rows + 2 && col >= 0 && col < cols + 2
    }
    
    func log() {
        for row in (0..<(rows+2)).reversed() {
            var s = ""
            for col in 0..<(cols+2) {
                s += self[row, col].letter()
            }
            
            print(s)
        }
    }
    
    subscript(row: Int, col: Int) -> Square {
        get {
            assert(indexIsValid(row: row, col: col), "Index out of range")
            return squares[(row * (cols + 2)) + col]
        }
        set {
            assert(indexIsValid(row: row, col: col), "Index out of range")
            squares[(row * (cols + 2)) + col] = newValue
        }
    }
    
    func getAnglePoints() -> [BP] {
        if (anglePoints.count == 0) {
            for angle in getAngles() {
                anglePoints.append(angle.point)
                anglePoints.append(angle.diaPoint)
                anglePoints.append(angle.verPoint)
                anglePoints.append(angle.horPoint)
            }
        }
        
        return anglePoints
    }
    
    func getAngles() -> [BoardAngle] {
        if (angles.count == 0) {
            angles.append(BoardAngle(BP(1, 1), diaPoint: BP(2, 2), horPoint: BP(1, 2), verPoint: BP(2, 1)))
            angles.append(BoardAngle(BP(rows, 1), diaPoint: BP(rows - 1, 2), horPoint: BP(rows, 2), verPoint: BP(rows - 1, 1)))
            angles.append(BoardAngle(BP(rows, cols), diaPoint: BP(rows - 1, cols - 1), horPoint: BP(rows, cols - 1), verPoint: BP(rows - 1, cols)))
            angles.append(BoardAngle(BP(1, cols), diaPoint: BP(2, cols - 1), horPoint: BP(1, cols - 1), verPoint: BP(2, cols)))
        }
        return angles
    }
    
    func countOf(square: Square) -> Int {
        var count = 0
        for row in 1...rows {
            for col in 1...cols {
                if (self[row, col] == square) {
                    count += 1
                }
            }
        }
        
        return count
    }
}
