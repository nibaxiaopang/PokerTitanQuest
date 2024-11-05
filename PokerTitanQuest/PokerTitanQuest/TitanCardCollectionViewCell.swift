//
//  CardCollectionViewCell.swift
//  PokerTitanQuest
//
//  Created by jin fu on 2024/11/5.
//

import UIKit

class TitanCardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var FrountImageView: UIImageView!
    @IBOutlet weak var BackImageView: UIImageView!
    
    var card: TitanCards?
    
    func setCard(_ card: TitanCards) {
        
        if card.isMatched {
            
            BackImageView.alpha = 0
            FrountImageView.alpha = 0
            
            return
            
        } else {
            
            BackImageView.alpha = 1
            FrountImageView.alpha = 1
        }
        
        self.card = card
        
        FrountImageView.image = UIImage(named: card.imageName)
        
        if card.isFlipped {
            
            UIView.transition(from: BackImageView, to: FrountImageView, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
            
        } else {
            
            UIView.transition(from: FrountImageView, to: BackImageView, duration: 0, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
    }
    
    func flip() {
        
        UIView.transition(from: BackImageView, to: FrountImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
    }
    
    func flipBack() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
            
            UIView.transition(from: self.FrountImageView, to: self.BackImageView, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        })
    }
    
    func remove() {
        
        BackImageView.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            
            self.FrountImageView.alpha = 0
            
        }, completion: nil)
        
        
    }
}
