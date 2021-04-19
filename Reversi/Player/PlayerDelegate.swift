//
//  PlayerDelegate.swift
//  Reversi
//
//  Created by Vladislav Garifulin on 19.04.2021.
//

import Foundation

protocol PlayerDelegate: AnyObject {
    func didMove(player: PlayerProtocol)
}
