//
//  TicToeGameView.swift
//  Lab1_HarpreetKaur_C0636891_iOS
//
//  Created by Harpreet on 18/01/22.
//

import Foundation
import UIKit


class SquareItemView: UIView {
    
    var index = 0
    var currentPlayer: Game.Player = Game.Player.E {
        didSet {
            imageView.image = UIImage(named: currentPlayer.rawValue)
        }
    }
    
    private let imageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: Game.Player.E.rawValue))
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .yellow
        image.isUserInteractionEnabled = true
        return image
    }()
    
    override init(frame : CGRect) {
        super.init(frame : frame)
        initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeView()
    }
    
    private func initializeView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        addGestureRecognizer(tapGestureRecognizer)
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        backgroundColor = .white
        
        addSubview(imageView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: imageView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: imageView)
    }
    
    @objc private func viewDidTap(gesture: UITapGestureRecognizer) {
        
        onViewTap(gesture)
    }
    
    //MARK:- Call Delegate On Tap
    var onViewTap: (UITapGestureRecognizer)->() = { gesture in
        debugPrint("onViewTap")
       // MotionReset()
    }
  
    
    func reset() {
        currentPlayer = Game.Player.E
    }
    
    func MotionReset() {
        currentPlayer = Game.Player.E
    }
    
}

//MARK:- UIView addConstraints

extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for(index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
