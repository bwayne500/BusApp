//
//  SegmentedController.swift
//  Bus
//
//  Created by bwayne500 on 2022/3/9.
//

import UIKit

class SegmentedController: UIViewController {

    @IBOutlet var ContainerViews: [UIView]!
    @IBAction func segmentedChange(_ sender: UISegmentedControl) {
        ContainerViews.forEach {
               $0.isHidden = true
            }
            ContainerViews[sender.selectedSegmentIndex].isHidden = false
        print(sender.selectedSegmentIndex)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
