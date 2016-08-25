//
//  ViewController.swift
//  HMSegmentedControl
//
//  Created by Hesham Abd-Elmegid on 8/24/16.
//  Copyright © 2016 Tinybits. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let segmentedControl = HMSegmentedControl(items: ["One", "Two", "Three"])
    
    override func viewDidLoad() {
        view.addSubview(segmentedControl)
        
        segmentedControl.backgroundColor = #colorLiteral(red: 0.7683569193, green: 0.9300123453, blue: 0.9995251894, alpha: 1)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectionIndicatorPosition = .Bottom
        segmentedControl.selectionIndicatorColor = #colorLiteral(red: 0.1142767668, green: 0.3181744218, blue: 0.4912756383, alpha: 1)
        segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName : #colorLiteral(red: 0.2818343937, green: 0.5693024397, blue: 0.1281824261, alpha: 1)]
        segmentedControl.selectedTitleTextAttributes = [
            NSForegroundColorAttributeName : #colorLiteral(red: 0.05439098924, green: 0.1344551742, blue: 0.1884709597, alpha: 1),
            NSFontAttributeName : UIFont.boldSystemFont(ofSize: 20)
        ]
        segmentedControl.indexChangedHandler = { index in
            print(index)
//            print(self.segmentedControl.selectedSegmentIndex)
//            self.segmentedControl.selectedSegmentIndex = 1
        }
        
        NSLayoutConstraint.activate(
            [segmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor),
             segmentedControl.heightAnchor.constraint(equalToConstant: 50),
             segmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor),
             segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 40)]
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        segmentedControl.setSelectedSegmentIndex(index: 2, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

