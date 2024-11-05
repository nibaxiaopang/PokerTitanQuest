//
//  PlayerCradViewController.swift
//  PokerTitanQuest
//
//  Created by PokerTitanQuest on 2024/11/5.
//


import UIKit

class TitanPlayerCradViewController: UIViewController {

    @IBOutlet weak var player1CardImg: UIImageView!
    @IBOutlet weak var player2CardImg: UIImageView!
    @IBOutlet weak var winSlider: UISlider!
    
    var cardArr = ["card1","card2","card3","card4","card5","card6","card7","card8","card9","cardJeck","cardQueen","cardKing","cardClub"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showHowToPlayAlert()
        // Initialize the slider value to 50
        winSlider.value = 50
        winSlider.setThumbImage(UIImage(named: "spade"), for: .normal)
    }
    
    @IBAction func shuffleBtn(_ sender: UIButton) {
        // Shuffle and select random cards for both players
        let player1Card = cardArr.randomElement()!
        let player2Card = cardArr.randomElement()!
        
        // Set the card images (make sure the images are named according to the cardArr strings)
        player1CardImg.image = UIImage(named: player1Card)
        player2CardImg.image = UIImage(named: player2Card)
        
        // Determine the index (or value) of each card to compare
        let player1CardValue = cardArr.firstIndex(of: player1Card)! + 1 // Adding +1 so the cards have values from 1-10
        let player2CardValue = cardArr.firstIndex(of: player2Card)! + 1
        
        // Compare the two cards and adjust the slider accordingly
        if player1CardValue > player2CardValue {
            winSlider.value -= 10 // Decrease slider by 10 for Player 1 win
        } else if player2CardValue > player1CardValue {
            winSlider.value += 10 // Increase slider by 10 for Player 2 win
        }
        
        // Check for win conditions
        if winSlider.value <= 0 {
            showAlert(winner: "Player 1")
        } else if winSlider.value >= 100 {
            showAlert(winner: "Player 2")
        }
    }
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    // Function to show alert when a player wins
    func showAlert(winner: String) {
        let alert = UIAlertController(title: "Game Over", message: "\(winner) Wins!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { _ in
            self.restartGame()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // Restart the game by resetting the slider and shuffling cards
    func restartGame() {
        winSlider.value = 50
        player1CardImg.image = UIImage(named: "back")
        player2CardImg.image = UIImage(named: "back")
    }
    
    func showHowToPlayAlert() {
            let alert = UIAlertController(title: "How to Play", message: """
                - Both players will be dealt a random card.
                - If Player 1's card is higher, the slider moves left.
                - If Player 2's card is higher, the slider moves right.
                - First to move the slider to their side wins!
                """, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
}
