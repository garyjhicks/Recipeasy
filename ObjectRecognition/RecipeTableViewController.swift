//
//  RecipeTableViewController.swift
//  ObjectRecognition
//
//  Created by Gary Hicks on 2018-04-02.
//  Copyright © 2018 Gary Hicks. All rights reserved.
//

import UIKit

class RecipeTableViewController: UITableViewController {
    
    var urlAddition=""
    var titles = [String]()
    var sources = [String]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidAppear(_ animated: Bool) {
        
        urlAddition = ""
        
        for item in items{
            urlAddition = urlAddition + item.replacingOccurrences(of: " ", with: "%20") + ","
        }
        //print(urlAddition)
        
        
        if let url = URL(string: "http://food2fork.com/api/search?key=c5d2f79b22fa3251aa9b700c5541d5d5&q=\(urlAddition)") {
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    print(error as Any)
                    
                }
                else{
                    if let urlContent = data {
                        
                        do{
                            let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                            //print(jsonResult)
                            
                            
                            if let recipes = jsonResult["recipes"] as? NSMutableArray {
                                self.titles.removeAll()
                                self.sources.removeAll()
                                for count in recipes {
                                    if let recipe = count as? NSDictionary {
                                        self.titles.append((recipe["title"] as? String)!)
                                        self.sources.append((recipe["source_url"] as? String)!)
                                        self.tableView.reloadData()
                                    }
                                }
                                
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    //print(self.titles)
                                    //print(self.sources)
                                }
                            }
                            
                            
                        }catch{
                            print("Json Error")
                        }
                        
                    }
                }
                
            }
            task.resume()
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        titles.removeAll()
        sources.removeAll()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return titles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.numberOfLines = 0;
        //print(titles.count)
        cell.textLabel?.text = "\(titles[indexPath.row])"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let url = URL(string: sources[indexPath.row]) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let save = UIContextualAction(style: .normal, title: "Save") { _, _, handler in
            
            handler(true)
            
            print(self.titles.count)
            print(indexPath.row)
            favs.append(self.titles[indexPath.row])
            self.defaults.set(favs, forKey: "FavsItems")
            print("Saved!")
            
        }
        return UISwipeActionsConfiguration(actions: [save])
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
