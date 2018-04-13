//
//  ManualViewController.swift
//  ObjectRecognition
//
//  Created by Gary Hicks on 2018-04-02.
//  Copyright © 2018 Gary Hicks. All rights reserved.
//

import UIKit

class ManualViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    let defaults = UserDefaults.standard
    
    @IBAction func save(_ sender: Any) {
        print("Hit")
        if let item = self.textField.text {
            items.append(item)
            defaults.set(items, forKey: "SavedItems")
            self.textField.text = ""
            print("Here")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.textField.text=""
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.textField.text = ""
        self.hideKeyboard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
