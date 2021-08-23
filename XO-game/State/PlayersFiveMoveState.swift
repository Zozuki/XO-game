//
//  PlayersFiveMoveState.swift
//  XO-game
//
//  Created by user on 23.08.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class PlayersFiveMoveState: PlayGameState {
    var isMoveCompleted: Bool = false
    
    public var player: Player
    
    private(set) weak var gameViewController: GameViewController?
    private(set) weak var gameBoard: Gameboard?
    private(set) weak var gameBoardView: GameboardView?
    public var markView: MarkView
    
    static var firstPlayerPostitions: [GameboardPosition] = []
    static var secondPlayerPostitions: [GameboardPosition] = []
    var pos = 0
    init(player: Player, gameViewController: GameViewController?, gameBoard: Gameboard?, gameBoardView: GameboardView?, markView: MarkView) {
        self.player = player
        self.gameViewController = gameViewController
        self.gameBoard = gameBoard
        self.gameBoardView = gameBoardView
        self.markView = markView
    }
    
    
    func addSign(at position: GameboardPosition) {
        guard let gameBoardView = gameBoardView
//              gameBoardView.canPlaceMarkView(at: position)
        else { return }
        
        if player == .first {
            PlayersFiveMoveState.firstPlayerPostitions.append(position)
            
            if PlayersFiveMoveState.firstPlayerPostitions.count == 5 {
                isMoveCompleted = true
            }
        } else {
            PlayersFiveMoveState.secondPlayerPostitions.append(position)
            
            if PlayersFiveMoveState.secondPlayerPostitions.count == 5 {
                isMoveCompleted = true
            }
        }
        
        if PlayersFiveMoveState.firstPlayerPostitions.count + PlayersFiveMoveState.secondPlayerPostitions.count == 10 {
            while pos != 5 {
                firstPlayerTurn(firstPlayerPos: PlayersFiveMoveState.firstPlayerPostitions[pos])
                secondPlayerTurn(secondPlayerPos: PlayersFiveMoveState.secondPlayerPostitions[pos])
                pos += 1
            }
            PlayersFiveMoveState.firstPlayerPostitions.removeAll()
            PlayersFiveMoveState.secondPlayerPostitions.removeAll()
        }
        
    }
    func firstPlayerTurn(firstPlayerPos: GameboardPosition) {
        player = .first
        markView = XView()
        gameBoard?.setPlayer(player, at: firstPlayerPos)
        Logger.shared.log(action: .playerSetSign(player: player, position: firstPlayerPos))
        gameBoardView?.removeMarkView(at: firstPlayerPos)
        gameBoardView?.placeMarkView(markView.copy(), at: firstPlayerPos)
    }
    
    func secondPlayerTurn(secondPlayerPos: GameboardPosition) {
        player = .second
        markView = OView()
        gameBoard?.setPlayer(player, at: secondPlayerPos)
        Logger.shared.log(action: .playerSetSign(player: player, position: secondPlayerPos))
        gameBoardView?.removeMarkView(at: secondPlayerPos)
        gameBoardView?.placeMarkView(markView.copy(), at: secondPlayerPos)
    }
    
    func begin() {
        switch player {
        case .first:
            gameViewController?.firstPlayerTurnLabel.isHidden = false
            gameViewController?.secondPlayerTurnLabel.isHidden = true
        case .second:
            gameViewController?.firstPlayerTurnLabel.isHidden = true
            gameViewController?.secondPlayerTurnLabel.isHidden = false
        case .computer:
            gameViewController?.firstPlayerTurnLabel.isHidden = true
            gameViewController?.secondPlayerTurnLabel.isHidden = false
        }
        
        gameViewController?.winnerLabel.isHidden = true
    }
    
    
}
