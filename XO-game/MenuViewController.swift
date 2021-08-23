//
//  MenuViewController.swift
//  XO-game
//
//  Created by user on 23.08.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func twoPlayersButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "XOGameVC") as! GameViewController
        vc.computerIsSecondPlayer = false
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func playerVSComputerButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "XOGameVC") as! GameViewController
        vc.computerIsSecondPlayer = true
        navigationController?.pushViewController(vc, animated: true)
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
