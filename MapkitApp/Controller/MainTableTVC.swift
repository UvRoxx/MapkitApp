//
//  MainTableTVC.swift
//  MapkitApp
//
//  Created by UTKARSH VARMA on 2021-02-07.
//

import UIKit

class MainTableTVC: UITableViewController {
    
    var savedLocations = [SavedLocations]()
    var index = -1
    let saveLoadData = SaveLoadData()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        saveLoadData.loadInfo(completion: { (error, savedData) in
            if let e = error{
                let alert = saveLoadData.saveLoadAlert(alerttitle: "Error", alertMessage: e, alertButtonTitle: "Ok")
                present(alert, animated: true)
            }else{
                savedLocations = savedData!
                tableView.reloadData()
                
            }
        })
    }
    @IBAction func addNewLocation(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "gotoMap", sender:self)
    }
    //MARK:Table View Data Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = savedLocations[indexPath.row].locationName
        return cell
    }
    //MARK:Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "gotoMap", sender: self)
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            saveLoadData.delInfo(deleteIndex: indexPath.row) { (error, dataAfterDeletion) in
                if let e = error{
                    let alert = saveLoadData.saveLoadAlert(alerttitle: "Error Deleting", alertMessage: e, alertButtonTitle: "Ok")
                    present(alert, animated: true, completion: nil)
                }else{
                    savedLocations = dataAfterDeletion!
                    tableView.reloadData()
                }
            }
        }
    }
    
    //MARK:Preparing For Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if index>=0{
            let destinationVC = segue.destination as! MapVC
            destinationVC.savedAnnotation = savedLocations[index].locationName
            index = -1
        }
        
    }
    
    
}
