//
//  ViewController.swift
//  AppsOnAirSDK
//
//  Created by nikesh8 on 11/24/2022.
//  Copyright (c) 2022 nikesh8. All rights reserved.
//

import UIKit
import AppsOnAir

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let appUpdateManager = AppsOnAirServices()
        // Please replace your APP_ID from https://appsonair.com
        // appUpdateManager.setAppId(APP_ID: "XXXXX-XXXX-XXXX-XXXX-XXXXXXXX", showNativeUI: true/false)
        //appUpdateManager.setAppId("XXXXX-XXXX-XXXX-XXXX-XXXXXXXX")
        print("Helloooooooo")
        AppsOnAirServices.shared.setAppId("XXXXX-XXXX-XXXX-XXXX-XXXXXXXX")
        AppsOnAirServices.shared.setupFeedbackScreen(backgroundColor: "c3a5ff",txtEmailHintText: "your email", btnSubmitText: "Save")
        //AppsOnAirServices.shared.setupFeedbackScreen()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

