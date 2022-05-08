//
//  TableTableViewController.swift
//  OnTheMap
//
//  Created by joel.stevick on 5/7/22.
//

import UIKit

class TableViewController: UITableViewController {

    // MARK: - Properties
    var studentLocations: [StudentLocation]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // initialize
        Task {
            await getStudentLocations()
            
            tableView.reloadData()
        }
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return studentLocations?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
        
        let studentLocation = studentLocations![indexPath.row]
        
        cell.textLabel?.text = "\(studentLocation.firstName) \(studentLocation.lastName)"
        
        cell.imageView?.image = UIImage(systemName: "mappin")
                
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentLocation = studentLocations![indexPath.row]
        
        if let url = URL(string: studentLocation.mediaURL) {
        
            UIApplication.shared.open(url)
        }
    }

    // MARK: - Utility functions
    func getStudentLocations() async {
        
        studentLocations = await UdacityApi.shared.getStudentLocations()
       
    }
    
    
}
