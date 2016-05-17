//
//  NoticeViewController.swift
//  
//
//  Created by nakajimashunta on 2016/05/13.
//
//

import UIKit

class NoticeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openlefts(){
        self.slideMenuController()?.openLeft()
    }
}
