//
//  CardFlipViewController.swift
//  PokerTitanQuest
//
//  Created by jin fu on 2024/11/5.
//

import UIKit

class TitanCardFlipViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timeRemaining: UILabel!
    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet weak var restartButton: UIButton! // Outlet for the restart button
    
    var model = TitanCardsModels()
    var cardArray = [TitanCards]()
    
    var firstFlippedCardIndex: IndexPath?
    
    var timer: Timer?
    var milliseconds: Float = 40 * 1000 // 30 seconds
    
    var flipCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
       
        cardArray = model.getCards()
        
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        
        RunLoop.main.add(timer!, forMode: .common)
        
        // Customize the restart button appearance (optional)
        //   restartButton.setTitle("Restart", for: .normal)
        restartButton.addTarget(self, action: #selector(restartButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
            TitanSoundManager.playSound(.shuffle)
    }
    
    // MARK: - Timer Methods
    
    @objc func timerElapsed() {
        milliseconds -= 1
        
        let seconds = String(format: "%.2f", milliseconds/1000)
        timeRemaining.text = "Time : \(seconds)"
        
        if milliseconds <= 0 {
            timer?.invalidate()
             timeRemaining.textColor = UIColor.red
            
            checkGameEnded()
        }
    }

    // MARK: - UICollectionView Protocol Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! TitanCardCollectionViewCell
        
        let card = cardArray[indexPath.row]
        cell.setCard(card)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if milliseconds <= 0 {
            return
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! TitanCardCollectionViewCell
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false && card.isMatched == false {
            cell.flip()
            card.isFlipped = true
            
            TitanSoundManager.playSound(.flip)
            
            // Increment the flip count and update the label
            flipCount += 1
            updateFlipCountLabel()
            
            if firstFlippedCardIndex == nil {
                firstFlippedCardIndex = indexPath
            } else {
                checkForMatches(indexPath)
            }
        }
    }
    
    // MARK: - Game logic methods
    
    func checkForMatches(_ secondFlippedCardIndex: IndexPath) {
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? TitanCardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? TitanCardCollectionViewCell
        
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        if cardOne.imageName == cardTwo.imageName {
            TitanSoundManager.playSound(.match)
            cardOne.isMatched = true
            cardTwo.isMatched = true
            cardOneCell?.remove()
            cardTwoCell?.remove()
            checkGameEnded()
        } else {
            TitanSoundManager.playSound(.nomatch)
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
        }
        
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        
        firstFlippedCardIndex = nil
    }
    
    func checkGameEnded() {
        var isWon = true
        
        for card in cardArray {
            if card.isMatched == false {
                isWon = false
                break
            }
        }
        
        var title = ""
        var message = ""
        
        if isWon {
            if milliseconds > 0 {
                timer?.invalidate()
            }
            
            title = "Congratulations!!!"
            message = "You've won"
            
        } else {
            if milliseconds > 0 {
                return
            }
            
            title = "Game Over"
            message = "You've lost"
        }
        
        showAlert(title, message)
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Done", style: .default, handler: {_ in
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func updateFlipCountLabel() {
        flipCountLabel.text = "Flips: \(flipCount)"
        // restartButton.setTitle("Restart", for: .normal)
    }
    
    func showAboutUs() {
         // Replace with your About Us data
         let aboutUs = "This App Is About The Matching The Cards And Improve Your Focus And Mind You Have to Matched THe both Card IF the Both Cards Matched Thn They Remove And You Have To Complete The Whole GAme In Certain Time And You Can Also See Numbers Of Flips On Your Screen."
         
         let aboutUsAlert = UIAlertController(title: "Info" ,message: aboutUs, preferredStyle: .alert)
         let okayAction = UIAlertAction(title: "Done", style: .default, handler: nil)
         aboutUsAlert.addAction(okayAction)
         
         present(aboutUsAlert, animated: true, completion: nil)
     }

    @IBAction func InfoBtnTapped(_ sender: Any) {
        showAboutUs()
        
    }
    
    @IBAction func exit(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        
        model = TitanCardsModels()
        cardArray = model.getCards()
        milliseconds = 40 * 1000
        flipCount = 0
        firstFlippedCardIndex = nil
        collectionView.reloadData()
        updateFlipCountLabel()
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        
        // timeRemaining.textColor = UIColor.white
        let seconds = String(format: "%.2f", milliseconds / 1000)
        timeRemaining.text = "Time : \(seconds)"
    }
}
