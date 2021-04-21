//
//  GameScene.swift
//  Reversi
//
//  Created by Vladislav Garifulin on 01.01.2021.
//

import SpriteKit
import GameplayKit

final class GameScene: SKScene, GameDelegate {
    private var boardNode = SKBoardNode(board: Board(rows: 8, cols: 8, defaultValue: .empty), size: nil)
    private var game: Game!
    
    override var size: CGSize {
        get {
            return super.size
        }
        set(newSize) {
            super.size = newSize
            let min = (size.width < size.height) ? size.width : size.height
            boardNode.size = CGSize(width: min, height: min)
            boardNode.position = CGPoint(x: (size.width - boardNode.size!.width) / 2.0, y: (size.height - boardNode.size!.height) / 2.0)
        }
    }
    
    required override init(size: CGSize) {
        super.init(size: size)
        
        let rules = Rules(board: boardNode.board)
        let blackPlayer = Player(rules: rules)
        let whitePlayer = PlayerMachine(rules: rules, level: .l4)
        game = Game(rules: rules, blackPlayer: blackPlayer, whitePlayer: whitePlayer, delegate: self)
        
        addChild(boardNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func touchDown(atPoint pos: CGPoint) {

    }
    
    func touchMoved(toPoint pos: CGPoint) {

    }
    
    func touchUp(atPoint pos: CGPoint) {
        guard (game.waitingForTouch()) else { return }
        let bp = boardNode.boardPoint(touchPoint: pos)
        
        print(bp)
            
        if (game.canTake(move: bp)) {
            game.take(move: bp)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {        
        for t in touches { self.touchDown(atPoint: t.location(in: boardNode)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: boardNode)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: boardNode)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: boardNode)) }
    }
    
    func didMove() {
        boardNode.applyBoard()
    }
}
