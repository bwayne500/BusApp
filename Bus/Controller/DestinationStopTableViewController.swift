//
//  DestinationStopTableViewController.swift
//  Bus
//
//  Created by bwayne500 on 2022/3/9.
//

import UIKit
import CryptoKit
import Foundation
class DestinationStopTableViewController: UITableViewController {
    var BusNumber = UserDefaults.standard.value(forKey: "BusName") as!String
    var BusStop :NSMutableArray = []
    var StopStatus :NSMutableArray = []
    var stopNum :NSMutableArray = []
    var nextBusTime :NSMutableArray = []
    func getTimeString() -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "EEE, dd MMM yyyy HH:mm:ww zzz"
        dateFormater.locale = Locale(identifier: "en_US")
        dateFormater.timeZone = TimeZone(secondsFromGMT: 0)
        let time = dateFormater.string(from: Date())
        return time
    }
    func startParsing(data :NSData)
    {
        let dictdata:NSArray=(try! JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSArray
        for i in 0 ..< (dictdata.count)
        {
            let StopName=(dictdata[i] as! NSDictionary).value(forKey: "StopName")
            //let Estimates=(dictdata[i] as! NSDictionary).value(forKey: "Estimates")
            BusStop[i]=(StopName as! NSDictionary).value(forKey: "Zh_tw") as! NSString
            StopStatus[i]=(dictdata[i] as! NSDictionary).value(forKey: "EstimateTime")
            stopNum[i]=(dictdata[i] as! NSDictionary).value(forKey: "StopStatus")
            nextBusTime[i]=(dictdata[i] as! NSDictionary).value(forKey: "NextBusTime")
            
        }
        //print(StopStatus)
        print(stopNum)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                   }
    }
    
    @objc func jsonParsingFromURL () {
        let appId = "157b589f603b438abe5ae63c440606c9"
        let appKey = "_0hyfPIE1weH3wPB295hydvKYBM"
        let xdate = getTimeString()
        let signDate = "x-date: \(xdate)"
        let key = SymmetricKey(data: Data(appKey.utf8))
        let hmac = HMAC<SHA256>.authenticationCode(for: Data(signDate.utf8), using: key)
        let base64HmacString = Data(hmac).base64EncodedString()
        let authorization = """
        hmac username="\(appId)", algorithm="hmac-sha256", headers="x-date", signature="\(base64HmacString)"
        """
        let request = NSMutableURLRequest(url: NSURL(string: "https://ptx.transportdata.tw/MOTC/v2/Bus/EstimatedTimeOfArrival/City/Taichung?$filter=RouteName%2FZh_tw%20eq%20%27"+BusNumber+"%27%20and%20Direction%20eq%20%271%27&$orderby=StopSequence%20asc&$top=100&$format=JSON")! as URL)
        let session = URLSession.shared
        request.setValue(xdate, forHTTPHeaderField: "x-date")
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        let task = session.dataTask(with: request as URLRequest,

        completionHandler:
            {
                data, response, error -> Void in
                self.startParsing(data: data! as NSData)
            }
        )
        task.resume()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        jsonParsingFromURL()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return BusStop.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DestinationStopCell", for: indexPath) as! DestinationStopTableViewCell
        var value = Int()
        switch stopNum[indexPath.row] as! Int{
        case 0:
            value = (StopStatus[indexPath.row]as! Int)/60
            cell.EstimateTime.text = "\(value)"+"分鐘"
        case 1:
            let isoFormatter = ISO8601DateFormatter()
            let date = isoFormatter.date(from: nextBusTime[indexPath.row]as! String)!
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "HH:mm"
            let time = dateFormater.string(from: date)
            cell.EstimateTime.text=time
            value = 4
        case 2:
            cell.EstimateTime.text="交管不停靠"
            value = 4
        case 3:
            cell.EstimateTime.text="末班車已過"
            value = 4
        case 4:
            cell.EstimateTime.text="今日未營運"
            value = 4
        default:
            cell.EstimateTime.text="ERROR"
            value = 4
        }
        cell.DestinationStopName.text = BusStop[indexPath.row] as! String?
        cell.EstimateTime.layer.cornerRadius = 10
        cell.EstimateTime.layer.masksToBounds = true
        switch value{
        case 0:
            cell.EstimateTime.text = "即將到站"
            cell.EstimateTime.textColor = .white
            cell.EstimateTime.backgroundColor = UIColor(red: 232/255, green: 13/255, blue: 11/255, alpha: 1)
        case 1,2,3:
            cell.EstimateTime.textColor = .red
            cell.EstimateTime.backgroundColor = UIColor(red: 252/255, green: 230/255, blue: 231/255, alpha: 1)
        default:
            cell.EstimateTime.textColor = .darkGray
            cell.EstimateTime.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 245/255, alpha: 1)
        }
        return cell
    }
    
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
