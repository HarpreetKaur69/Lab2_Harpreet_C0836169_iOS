//
//  GameViewController.swift
//  Lab1_HarpreetKaur_C0636891_iOS
//  Created by Harpreet on 18/01/22.
//

import UIKit

class GameViewController: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var gridItemView_0: SquareItemView!
    @IBOutlet weak var gridItemView_1: SquareItemView!
    @IBOutlet weak var gridItemView_2: SquareItemView!
    @IBOutlet weak var gridItemView_3: SquareItemView!
    @IBOutlet weak var gridItemView_4: SquareItemView!
    @IBOutlet weak var gridItemView_5: SquareItemView!
    @IBOutlet weak var gridItemView_6: SquareItemView!
    @IBOutlet weak var gridItemView_7: SquareItemView!
    @IBOutlet weak var gridItemView_8: SquareItemView!
    
    @IBOutlet weak var gameStatusLabel: UILabel!
    @IBOutlet weak var gameScoreLabel: UILabel!
    
    //MARK:- PROPERTIES
    private let statusPlayerText = "Player"
    private let statusActiveText = "Turn"
    private let statusDrawText = "Game Is A Draw!"
    private let statusWonText = "Won!"
    private let gameManager = GameManager()
    private var gridItemsViews = [SquareItemView]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addSwipeGestures()
    }
    
    //MARK:- View Setup
    private func setupViews() {
        view.backgroundColor = .white
        
        gridItemsViews = [gridItemView_0, gridItemView_1, gridItemView_2,
                          gridItemView_3, gridItemView_4, gridItemView_5,
                          gridItemView_6, gridItemView_7, gridItemView_8]
        
        for (index, SquareItemView) in gridItemsViews.enumerated() {
            SquareItemView.index = index
            SquareItemView.onViewTap = handleDidTapGridItem
        }
        
        gameManager.onGameStatusUpdate = gameStatusUpdated
        gameManager.startNewGame()
        updateGameScoreLabel()
    }
    
    //MARK:- SWIPE Gestures
    func addSwipeGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
           swipeLeft.direction = .left
           self.view.addGestureRecognizer(swipeLeft)
               
           let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
           swipeRight.direction = .right
           self.view.addGestureRecognizer(swipeRight)
               
           let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
           swipeUp.direction = .up
           self.view.addGestureRecognizer(swipeUp)
               
           let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
           swipeDown.direction = .down
           self.view.addGestureRecognizer(swipeDown)
    }
    //MARK:- Tap
    private func handleDidTapGridItem(gesture: UITapGestureRecognizer) {
        if let itemView = gesture.view as? SquareItemView {
            let currentPlayer = gameManager.currentPlayer
            if gameManager.makeMove(at: itemView.index) {
                itemView.currentPlayer = currentPlayer
                if itemView.currentPlayer.rawValue == "X" {
                    gameManager.startNewGame()
                    _ = gridItemsViews.map { $0.MotionReset()}
                }
                self.becomeFirstResponder() // To get shake gesture
            }
        }
    }
    
    private func gameStatusUpdated(_ status: Game.Status) {
        switch status {
        case .Active:
            gameStatusLabel.text = "\(statusPlayerText) \(gameManager.currentPlayer.rawValue) \(statusActiveText)"
        case .Draw:
            gameStatusLabel.text = "\(statusDrawText)"
            updateGameScoreLabel()
        case .Won:
            gameStatusLabel.text = "\(statusPlayerText) \(gameManager.currentPlayer.rawValue) \(statusWonText)"
            updateGameScoreLabel()
        }
    }
    
    private func updateGameScoreLabel() {
        let gameSession = gameManager.session
        let playerXScore = gameSession.wins[Game.Player.X] ?? 0
        let playerOScore = gameSession.wins[Game.Player.O] ?? 0
        let ties = gameSession.draws
        
        gameScoreLabel.text = "\(Game.Player.X): \(playerXScore)    \(Game.Player.O): \(playerOScore)   \("TIES"): \(ties)"
    }
    
    //MARK:- Swipe Gesture to Reset Game
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) {
       if gesture.direction == .right {
            print("Swipe Right")
           gameManager.startNewGame()
           _ = gridItemsViews.map { $0.reset() }
       }
       else if gesture.direction == .left {
            print("Swipe Left")
           gameManager.startNewGame()
           _ = gridItemsViews.map { $0.reset() }
       }
       else if gesture.direction == .up {
            print("Swipe Up")
       }
       else if gesture.direction == .down {
            print("Swipe Down")
       }
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }

    // Enable detection of shake motion
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            print("Why are you shaking me?")
            gameManager.startNewGame()
            _ = gridItemsViews.map { $0.MotionReset()}
//            if let itemView = gesture.view as? SquareItemView {
//                let currentPlayer = gameManager.currentPlayer
//                if gameManager.makeMove(at: itemView.index) {
//                    itemView.currentPlayer = currentPlayer
//                    self.becomeFirstResponder() // To get shake gesture
//                }
//            }
        }
    }
}
