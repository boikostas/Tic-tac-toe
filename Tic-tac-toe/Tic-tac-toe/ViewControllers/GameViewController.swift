//
//  GameViewController.swift
//  Tic-tac-toe
//
//  Created by Стас Бойко on 22.07.2022.
//

import UIKit

protocol ResultViewControllerDelegate {
    var playersScoresLabel: UILabel! { get }
    var computersScoresLabel: UILabel! { get }
}


enum BoardType {
    case x
    case o
    case empty
    
    var image : UIImage? {
        switch self {
        case .x:
            return UIImage(named: "icon.x")?.withTintColor(.red, renderingMode: .automatic)
        case .o:
            return UIImage(named: "icon.o")?.withTintColor(.green, renderingMode: .automatic)
        case .empty:
            return UIImage()
        }
    }
}

class GameViewController: UIViewController {
    
    @IBOutlet var boardButtons: [UIButton]!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLable: UILabel!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var viewBoard: UIView!
    
    
    var playerWins = Int(UserDefaults.standard.string(forKey: "player wins") ?? "")
    var computerWins = Int(UserDefaults.standard.string(forKey: "computer wins") ?? "")
    
    private var gameStatusItems = [[BoardType]]()
    
    // MARK: - User/computer symbols
    var userSymbol: BoardType = .x {
        didSet {
            setupUIDefaultBoard()
            
            if userSymbol == .x {
                computerSymbol = .o
                titleLabel.text = "Your turn!"
            } else {
                computerSymbol = .x
                titleLabel.text = "Computer turn!"
                boardButtons.forEach { $0.isEnabled = false }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.boardButtons.forEach { $0.isEnabled = true }
                    self.computerTurn()
                }
            }
        }
    }
    
    private var computerSymbol: BoardType = .o
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBoard.layer.cornerRadius = 24
        restartButton.setTitle("", for: .normal)
    }
    
    // MARK: - Tap on button
    @IBAction func tapOnBoardButtons(_ sender: Any) {
        
        subTitleLable.text = ""
        
        guard let clickedButton = sender as? UIButton else { return }
        
        let indexButton = clickedButton.tag

        let i = indexButton / 3, j = indexButton % 3
        
        if gameStatusItems[i][j] == .empty {
            gameStatusItems[i][j] = userSymbol
            updateUIBoard()
            
            if isWin(with: userSymbol, i: i, j: j) {
                titleLabel.text = "You win!"
                playerWins = (playerWins ?? 0) + 1
    
                //Display the end of the game
                return
            }
            
            if !isEmptyCell() {
                titleLabel.text = "No empty cells!!!"
                //Display the end of the game
                return
            }
            
            titleLabel.text = "Computer turn!"
            
            boardButtons.forEach { $0.isEnabled = false }
    
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.boardButtons.forEach { $0.isEnabled = true }
                self.computerTurn()
            }
        } else {
            subTitleLable.text = "Cell is not empty. Choose another one"
        }
    }
    
    // MARK: - Setup default board
    private func setupUIDefaultBoard() {
        
        gameStatusItems = [
            [.empty, .empty, .empty],
            [.empty, .empty, .empty],
            [.empty, .empty, .empty]
        ]
        
        boardButtons.forEach {
            $0.setTitle("", for: .normal)
        }
        subTitleLable.text = ""
    }
    
    // MARK: - Update board
    private func updateUIBoard() {
        boardButtons.forEach {  button in
            let indexButton = button.tag
            let i = indexButton / 3, j = indexButton % 3
            button.setImage(gameStatusItems[i][j].image, for: .normal)
        }
    }
    
    // MARK: - Computer turn
    private func computerTurn() {
        var iIndex = 0, jIndex = 0
        
    outerLoop: for i in 0..<gameStatusItems.count {
        for j in 0..<gameStatusItems[i].count {
            if gameStatusItems[i][j] == .empty {
                    iIndex = i
                    jIndex = j
                    break outerLoop
                }
            }
        }
        
        gameStatusItems[iIndex][jIndex] = computerSymbol
        updateUIBoard()
        
        if isWin(with: computerSymbol, i: iIndex, j: jIndex) {
            titleLabel.text = "Computer wins!!!"
            computerWins = (computerWins ?? 0) + 1
            return
        }
        
        if !isEmptyCell() {
            titleLabel.text = "Draw!"
            subTitleLable.text = "No empty cells!"
            return
        }
        
        titleLabel.text = "Your turn!"
    }
    
    // MARK: - Is empty cell
    private func isEmptyCell() -> Bool {
        
        for i in 0..<gameStatusItems.count {
            for j in 0..<gameStatusItems[i].count {
                if gameStatusItems[i][j] == .empty {
                    return true
                }
            }
        }
        boardButtons.forEach { $0.isEnabled = false }
        return false
    }
    
    // MARK: - Check if win func
    private func isWin(with symbol: BoardType, i: Int, j: Int) -> Bool {
        var countLeftDiagonal = 0, countRightDiagonal = 0
        for i in 0..<gameStatusItems.count {
            for j in 0..<gameStatusItems[i].count {
                if i == j && gameStatusItems[i][j] == symbol {
                    countLeftDiagonal += 1
                }
                if i == gameStatusItems.count - 1 - j && gameStatusItems[i][j] == symbol {
                    countRightDiagonal += 1
                }
            }
        }
        
        if countLeftDiagonal == 3 || countRightDiagonal == 3 {
            boardButtons.forEach { $0.isEnabled = false }
            return true
        }
        
        
        for i in 0..<gameStatusItems.count {
            var jCount = 0, iCount = 0
            for j in 0..<gameStatusItems[i].count {
                if gameStatusItems[i][j] == symbol {
                    jCount += 1
                }
                if gameStatusItems[j][i] == symbol {
                    iCount += 1
                }
            }
            if jCount == 3 || iCount == 3 {
                boardButtons.forEach { $0.isEnabled = false }
                return true
            }
        }
        return false
    }
    
    // MARK: - Restart
    @IBAction func restartButtonTapped(_ sender: Any) {
        setupUIDefaultBoard()
        updateUIBoard()
        boardButtons.forEach { $0.isEnabled = true }
        
        if userSymbol == .o {
            computerTurn()
            //titleLabel.text = "Computer turn"
        } else {
            titleLabel.text = "Your turn!"
        }
    }
    
    // MARK: - Save results
    private func saveResults(_ result: Int, for string: String) -> String {
        UserDefaults.standard.setValue(String(result), forKey: string)
        UserDefaults.standard.synchronize()
        return UserDefaults.standard.string(forKey: string) ?? ""
    }
    
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let resultVC = segue.destination as? ResultsViewController else { return }

        resultVC.loadViewIfNeeded()

        resultVC.playersScoresLabel.text = saveResults(playerWins ?? 0, for: "player wins")
        resultVC.computersScoresLabel.text = saveResults(computerWins ?? 0, for: "computer wins")
    }

}
