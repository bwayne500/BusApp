//
//  BusSearchTableViewController.swift
//  Bus
//
//  Created by bwayne500 on 2022/3/4.
//

import UIKit
import CryptoKit
import Foundation
class BusSearchTableViewController: UITableViewController,UISearchResultsUpdating{
    struct MyStruct {
        var BusName:String
        var BusStop:String
    }
    var BusArray = [MyStruct]()
    lazy var filteredBus = BusArray
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text,
                   searchText.isEmpty == false  {
            filteredBus = BusArray.filter({$0.BusName.localizedStandardContains(searchText)})
                } else {
                    filteredBus = []
                }
                tableView.reloadData()
            }
        
    
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
        let dictdata=(try! JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSArray
        for i in 0 ..< (dictdata.count)
        {
            let RouteName=(dictdata[i] as! NSDictionary).value(forKey: "RouteName")
            //BusRoute.append((RouteName as! NSDictionary).value(forKey: "Zh_tw") as! String)
            let DestinationStopName = (dictdata[i] as! NSDictionary).value(forKey: "DepartureStopNameZh") as!String
            let DepartureStopName = (dictdata[i] as! NSDictionary).value(forKey: "DestinationStopNameZh") as!String
            //BusStop.append(DepartureStopName+"-"+DestinationStopName)
            BusArray.append(MyStruct(BusName: (RouteName as! NSDictionary).value(forKey: "Zh_tw") as! String, BusStop: DepartureStopName+"-"+DestinationStopName))
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                   }
        }
        //print(test)
        //print(self.BusRoute)
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
        let request = NSMutableURLRequest(url: NSURL(string: "https://ptx.transportdata.tw/MOTC/v2/Bus/Route/City/Taichung?%24select=RouteName%2CDepartureStopNameZh%2CDestinationStopNameZh&%24format=JSON")! as URL)
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
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.automaticallyShowsCancelButton = false
        searchController.searchBar.placeholder = "請輸入搜尋路線編號"
        searchController.searchBar.searchTextField.backgroundColor = .white
        
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
        return filteredBus.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! BusSearchTableViewCell
        cell.BusImage.image = UIImage(named: "BusLogo.png")
        cell.BusRoute.text = filteredBus[indexPath.row].BusStop
        cell.BusName.text = filteredBus[indexPath.row].BusName
        // Configure the cell...

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.setValue(filteredBus[indexPath.row].BusName, forKey: "BusName")
        UserDefaults.standard.setValue(filteredBus[indexPath.row].BusStop, forKey: "BusStop")
        performSegue(withIdentifier: "GoBusStatue", sender: self)
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoBusStatue"{
            let Destination = segue.destination as! SegmentedController
            Destination.modalPresentationStyle = .fullScreen
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
