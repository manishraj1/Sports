//
//  SportsListViewController.swift
//  Sports2
//
//  Created by Manish raj(MR) on 23/12/21.
//


import Foundation
import UIKit
import CoreData

class SportsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var stadiumListTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    //    static var savedStadiumObjects = [StadiumDetails]()
    
    var fetchedResultsController: NSFetchedResultsController<StadiumDetails>!
    
    fileprivate func reloadSavedData() -> [StadiumDetails]? {
        
        var detailsArray: [StadiumDetails] = []
        let fetchRequest: NSFetchRequest<StadiumDetails> = StadiumDetails.fetchRequest()
        let sortDesctriptor: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDesctriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: InfoController.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            let detailsCount = try fetchedResultsController.managedObjectContext.count(for: fetchedResultsController.fetchRequest)
            
            for index in 0..<detailsCount {
                detailsArray.append(fetchedResultsController.object(at: IndexPath(row: index, section: 0)))
            }
            return detailsArray
        } catch {
            print("error performing fetch")
            return nil
        }
    }
    fileprivate func downLoadNewStadiumInformation() {
        deleteExistingCoreDataStadiumDetail()
        Coredata.shared.savedStadiumObjects.removeAll()
        loadTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        stadiumListTableView.delegate = self
        stadiumListTableView.dataSource = self
        
        let savedStadiums = reloadSavedData()
        if savedStadiums != nil && savedStadiums?.count != 0 {
            Coredata.shared.savedStadiumObjects = savedStadiums!
            DispatchQueue.main.async {
                self.activityView.isHidden = true
                self.stadiumListTableView.reloadData()
            }
        } else {
            downLoadNewStadiumInformation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func loadTableView() {
        activityIndicator.startAnimating()
        SportsDataClient.getStadiums(completion: { (stadiums, error) in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityView.isHidden = true
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    let alertVC = UIAlertController(title: "Error", message: "Error retrieving data", preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alertVC, animated: true)
                    print(error.localizedDescription)
                }
            } else {
                if let stadiums = stadiums {
                    SportsArray.stadiums = stadiums
                    self.saveStadiumToCoreData(stadiums: stadiums)
                    DispatchQueue.main.async {
                        self.stadiumListTableView.reloadData()
                    }
                }
            }
        })
    }
    
    func saveStadiumToCoreData(stadiums: [Stadium]) {
        for stadium in SportsArray.stadiums {
            let stadiumDetail = StadiumDetails(context: InfoController.shared.viewContext)
            stadiumDetail.name = stadium.name
            stadiumDetail.city = stadium.city
            if let state = stadium.state {
                stadiumDetail.state = state
            } else {
                stadiumDetail.state = nil
            }
            stadiumDetail.latitude = stadium.geoLat
            stadiumDetail.longitude = stadium.geoLon
            Coredata.shared.savedStadiumObjects.append(stadiumDetail)
            InfoController.shared.save()
        }
    }
    
    func deleteExistingCoreDataStadiumDetail() {
        
        for object in Coredata.shared.savedStadiumObjects {
            
            InfoController.shared.viewContext.delete(object)
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Coredata.shared.savedStadiumObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        let stadium = Coredata.shared.savedStadiumObjects[indexPath.row]
        
        cell.label.text = stadium.name
        cell.setTableCellBackGroundColor()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "DetailsViewController") as! InfoViewController
        let stadiumDetail = Coredata.shared.savedStadiumObjects[indexPath.row]
        vc.currentStadiumName = stadiumDetail.name
        vc.currentCityName = stadiumDetail.city
        vc.currentStateName = stadiumDetail.state
        vc.stadiumDetail = stadiumDetail
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}
