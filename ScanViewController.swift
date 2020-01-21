//
//  ScanViewController.swift
//  Expense Tracker Final
//
//  Created by Arnav Gupta  on 21/8/18.
//  Copyright © 2018 Arnav Gupta. All rights reserved.
//

import UIKit
import Foundation

class ScanViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func getScannedData(_ sender: Any){
        guard let url = URL(string: "https://api.lucidtech.ai/v0/receipts") else {return}
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let response = response{
                print(response)
            }
    
        
    }

//    $ curl -X POST https://api.lucidtech.ai/v0/receipts \
//    -H 'x-api-key: <your api key>' \
//    -H 'Content-Type: application/json' \
//    -d '{"documentId": "a50920e1-214b-4c46-9137-2c03f96aad56"}'


}
}
