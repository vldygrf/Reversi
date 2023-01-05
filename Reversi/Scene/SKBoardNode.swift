//
//  SKBoardNode.swift
//  Reversi
//
//  Created by Vladislav Garifulin on 05.01.2021.
//

import SpriteKit

final class SKBoardNode: SKNode {
    var size: CGSize? {
        didSet {
            self.resize()
        }
    }
    
    private var board: BoardProtocol {
        didSet {
            self.resize()
        }
    }
    
    private var game: GameProtocol
    private var chips: [SKChipNode] = []
    private var squareWidth: CGFloat = 0.0
    private var squareHeight: CGFloat = 0.0
    
    required init(board: Board, game: GameProtocol, size: CGSize?) {
        self.board = board
        self.game = game
        super.init()
        self.size = size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func removeAllChildren() {
        super.removeAllChildren()
        self.chips.removeAll()
    }
    
    @discardableResult private func addChip(square: Square, position: CGPoint) -> SKChipNode {
        let chip = SKChipNode(square: square)
        chip.size = CGSize(width: self.squareWidth, height: self.squareHeight)
        chip.position = CGPoint(x: position.x + self.squareWidth / 2.0, y: position.y + self.squareHeight / 2.0)
        self.addChild(chip)
        return chip
    }

    func resize() {
        guard let size = self.size else { return }
        
        self.removeAllChildren()
        var x: CGFloat, y: CGFloat = 0.0
            
        self.squareWidth = size.width / CGFloat(self.board.cols)
        self.squareHeight = size.height / CGFloat(self.board.rows)
            
        let rows = self.board.rows
        for _ in 1...rows {
            x = 0.0
            let cols = self.board.cols
            for _ in 1...cols {
                self.addChip(square: .empty, position: CGPoint(x: x, y: y))
                let chip = self.addChip(square: .empty, position: CGPoint(x: x, y: y))
                self.chips.append(chip)
                x += self.squareWidth
            }
            y += self.squareHeight
        }
        
        self.applyBoard()
    }
    
    func applyBoard() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            var index = 0
            let rows = self.board.rows
            for row in 1...rows {
                let cols = self.board.cols
                for col in 1...cols {
                    if self.board[row, col] == .empty {
                        self.chips[index].square = self.game.canTake(move: BP(row, col)) && self.game.playerToMove().touchable() ? self.game.moveColor.possible() : .empty
                    } else {
                        self.chips[index].square = self.board[row, col]
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
