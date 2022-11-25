//
//  StartGameViewController.swift
//  Tic-tac-toe
//
//  Created by Стас Бойко on 22.07.2022.
//

import UIKit

class StartGameViewController: UIViewController {

    @IBOutlet weak var xButton: UIButton!
    @IBOutlet weak var oButton: UIButton!
    @IBOutlet weak var resultsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        xButton.setTitle("", for: .normal)
        oButton.setTitle("", for: .normal)
        xButton.layer.cornerRadius = 24
        oButton.layer.cornerRadius = 24
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? GameViewController else { return }
        vc.view.setNeedsLayout()
        
        if segue.identifier == "xButton" {
            vc.userSymbol = .x
        }
        
        if segue.identifier == "oButton" {
            vc.userSymbol = .o
        }
    }
}
