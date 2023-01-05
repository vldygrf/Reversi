//
//  GameViewController.swift
//  Reversi
//
//  Created by Vladislav Garifulin on 01.01.2021.
//

import UIKit
import SpriteKit
import GameplayKit

final class GameViewController: UIViewController {
    private let scene = GameScene(size: CGSize.zero)
    
    override func loadView() {
        self.view = SKView()
    }
    
    func view() -> SKView {
        return self.view as! SKView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.scene.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        self.view().presentScene(self.scene)
        self.view().showsFPS = true
        self.view().showsNodeCount = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.scene.size = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
