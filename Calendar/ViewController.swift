//
//  ViewController.swift
//  Calendar
//
//  Created by Vladimir Saprykin on 19.11.16.
//  Copyright © 2016 Vladimir Saprykin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let eCal: eCalendar = eCalendar()
    
    @IBAction func dateButtonClicked(sender: UIView) {
        if eCal.today == . {
            let vc = storyboard?.instantiateViewController(withIdentifier: "showDate")
            self.present(vc!, animated: true, completion: nil)
        }
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

