//
//  ResultsViewController.swift
//  Tic-tac-toe
//
//  Created by Стас Бойко on 17.08.2022.
//

import UIKit

class ResultsViewController: UIViewController, ResultViewControllerDelegate {
 
    @IBOutlet weak var playersScoresLabel: UILabel!
    @IBOutlet weak var computersScoresLabel: UILabel!
    @IBOutlet weak var resultsView: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        resultsView.layer.cornerRadius = 24
        backButton.setTitle("", for: .normal)
        backButton.layer.cornerRadius = 50
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
