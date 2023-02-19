//
//  InitialViewController.swift
//  test
//
//  Created by Mohamed Musa on 2/19/23.
//

import UIKit

class InitialViewController: UIViewController {

    @IBOutlet weak var begin_button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        begin_button.setTitle("Begin", for: .normal)
        begin_button.tintColor = .blue
        begin_button.backgroundColor = .white
        begin_button.layer.cornerRadius = 20
        begin_button.layer.masksToBounds = true
        // Do any additional setup ater loading the view.
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
