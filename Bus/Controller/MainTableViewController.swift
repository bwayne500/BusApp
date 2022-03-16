//
//  MainTableViewController.swift
//  Bus
//
//  Created by bwayne500 on 2022/3/14.
//

import UIKit
import CryptoKit
class MainTableViewController: UITableViewController {
    @IBOutlet weak var MinT: UILabel!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var PoP: UILabel!
    @IBOutlet weak var Wx: UILabel!
    @IBOutlet weak var MaxT: UILabel!
    @IBOutlet weak var CI: UILabel!

    struct Weather: Codable {
        var records: records
    }

    struct records: Codable {
        var location: [location]
    }

    struct location: Codable {
        var locationName: String
        var weatherElement: [weatherElement]
    }

    struct weatherElement: Codable {
        var elementName: String
        var time: [time]
    }

    struct time: Codable {
        var startTime: String
        var endTime: String
        var parameter: parameter
    }

    struct parameter: Codable {
        var parameterName: String
        var parameterValue: String?
        var parameterUnit: String?
        // 注意 parameterValue 和 parameterUnit 不一定存在，所以宣告成 String?
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        var request = URLRequest(url: URL(string: "https://opendata.cwb.gov.tw/api/v1/rest/datastore/F-C0032-001?Authorization=CWB-6F803E34-66E5-4135-AC7D-25811AD53D5C&locationName=%E8%87%BA%E4%B8%AD%E5%B8%82")!,timeoutInterval: Double.infinity)
                request.httpMethod = "GET"
                let task = URLSession.shared.dataTask(with: request){(data, respond, error) in
                    
                    let decoder = JSONDecoder()
                    if let data = data, let weather = try? decoder.decode(Weather.self, from: data){
                        
                        print(weather)
                        DispatchQueue.main.sync {
                                           self.locationName.text = weather.records.location[0].locationName
                                           self.Wx.text = weather.records.location[0].weatherElement[0].time[0].parameter.parameterName
                                           self.PoP.text = weather.records.location[0].weatherElement[1].time[0].parameter.parameterName + "%"
                                           self.MinT.text = weather.records.location[0].weatherElement[2].time[0].parameter.parameterName + "°" + weather.records.location[0].weatherElement[2].time[0].parameter.parameterUnit!
                                           self.CI.text = weather.records.location[0].weatherElement[3].time[0].parameter.parameterName
                                           self.MaxT.text = weather.records.location[0].weatherElement[4].time[0].parameter.parameterName + "°" + weather.records.location[0].weatherElement[4].time[0].parameter.parameterUnit!
                                       }
                        
                    }
                    else {
                        print("error")
                    }
                }
                task.resume()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
*/
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
