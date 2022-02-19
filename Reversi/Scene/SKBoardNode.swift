//
//  SKBoardNode.swift
//  Reversi
//
//  Created by Vladislav Garifulin on 05.01.2021.
//

import SpriteKit

final
class SKBoardNode: SKNode {
    var size: CGSize? {
        didSet {
            self.resize()
        }
    }
    
    var board: BoardProtocol {
        didSet {
            self.resize()
        }
    }
    
    private var squareWidth: CGFloat = 0.0
    private var squareHeight: CGFloat = 0.0
    
    required init(board: Board, size: CGSize?) {
        self.board = board
        super.init()
        self.size = size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func resize() {
        guard let size = self.size else { return }
        
        removeAllChildren()
        var x: CGFloat, y: CGFloat = 0.0
            
        self.squareWidth = size.width / CGFloat(self.board.cols)
        self.squareHeight = size.height / CGFloat(self.board.rows)
            
        var chip: SKChipNode
        let rows = self.board.rows
        for row in 1...rows {
            x = 0.0
            let cols = self.board.cols
            for col in 1...cols {
                chip = SKChipNode(square: self.board[row, col])
                chip.size = CGSize(width: self.squareWidth, height: self.squareHeight)
                chip.position = CGPoint(x: x + self.squareWidth / 2.0, y: y + self.squareHeight / 2.0)
                addChild(chip)
                x += self.squareWidth
            }
                
            y += self.squareHeight
        }
    }
    
    func applyBoard() {
        DispatchQueue.main.async { [self] in
            var index = 0
            let rows = self.board.rows
            for row in 1...rows {
                let cols = self.board.cols
                for col in 1...cols {
                    if let child = children[index] as? SKChipNode/*, child.square != board[row, col]*/ {
                        child.square = self.board[row, col]
                    }
                        
                    index += 1
                }
            }
        }
    }
    
    subscript(row: Int, col: Int) -> SKChipNode? {
        let index = (row - 1) * self.board.cols + (col - 1)
        return children[index] as? SKChipNode
    }
    
    func boardPoint(touchPoint: CGPoint) -> BP {
        let bp = BP(Int(touchPoint.y / self.squareHeight) + 1, Int(touchPoint.x / self.squareWidth) + 1)
        return bp
    }
}
