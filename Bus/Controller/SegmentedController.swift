//
//  SegmentedController.swift
//  Bus
//
//  Created by bwayne500 on 2022/3/9.
//

import UIKit
class SegmentedController: UIViewController {
    var text = UserDefaults.standard.value(forKey: "BusStop")as!String
    @IBOutlet weak var Segmented: UISegmentedControl!
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
        let BusStop = text.split(separator: "-")
        print(BusStop[0])
        Segmented.setTitle(String(BusStop[0]), forSegmentAt: 0)
        Segmented.setTitle(String(BusStop[1]), forSegmentAt: 1)
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
