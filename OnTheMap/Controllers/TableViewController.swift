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
    
    // MARK: - Table view cell
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell")!
        
        let studentLocation = studentLocations![indexPath.row]
        
        cell.textLabel?.text = "\(studentLocation.firstName) \(studentLocation.lastName)"
        
        return cell
    }

    // MARK: - Utility functions
    func getStudentLocations() async {
        
        studentLocations = await UdacityApi.shared.getStudentLocations()
       
    }
    
}
