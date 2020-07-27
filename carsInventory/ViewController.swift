//
//  ViewController.swift
//  carsInventory
//
//  Created by Kuwardeep Singh on 2020-07-27.
//  Copyright © 2020 Kuwardeep Singh. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    

    @IBOutlet weak var carsTableInfo: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //table data inside my entity name array
    var items:[Car]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        carsTableInfo.delegate = self
        carsTableInfo.dataSource = self
        
        //this functions will fetch data from core data
        fetchCars()
        
    }
    
    //function to fetch information
    func fetchCars(){
        
        //fetch data from core data and displaying in table view
        do{
            self.items = try context.fetch(Car.fetchRequest())
            carsTableInfo.reloadData()
        }
        catch{
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = carsTableInfo.dequeueReusableCell(withIdentifier: "MyCarWorld", for: indexPath)
        //get data
        
        let Car = items![indexPath.row]
        cell.textLabel?.text = Car.make
        return cell
        
    }
    
    //on the plus button press this would happen
    @IBAction func plusDone(_ sender: UIBarButtonItem) {
        //create alert
        let alert = UIAlertController(title: "Add Car Info", message: "What is the car make", preferredStyle: .alert)
        alert.addTextField()
        
        let addButtonPress = UIAlertAction(title: "Add", style: .default) { (action) in
            //access array
            let textField = alert.textFields![0]
            
            //create car object
            
            let newCar = Car(context: self.context)
            newCar.make = textField.text
            newCar.model = "Elantra"
            newCar.year = 2020
            
            //save
            do{
                try self.context.save()
            }
            catch{
                
            }
            
            //refetch the data
            self.fetchCars()
        }
        // plus button
        alert.addAction(addButtonPress)
        
        //showing alert in the view
        present(alert, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //create swiping function for delete
       let action = UIContextualAction(style: .destructive, title: "Delete car") { (action, view, completionHandler) in
        //selecting the car
        let removeItem = self.items![indexPath.row]
        
        //trying to delete it
        self.context.delete(removeItem)
        
        //saveing the data after deletion
        do{
            try self.context.save()
        }
        catch{
            
        }
        
        //fetching
        self.fetchCars()
        
        }
        
        return UISwipeActionsConfiguration(actions: [action])
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let updateItem = self.items![indexPath.row]
        
        //create alert to confirm if really wanna change
        let alert = UIAlertController(title: "Update car", message: "Are you sure you wanna update", preferredStyle: .alert)
        alert.addTextField()
        
        let textFRef = alert.textFields![0]
        textFRef.text = updateItem.make
        
        let save = UIAlertAction(title: "Save car", style: .default) { (action) in
            let textFRef = alert.textFields![0]
            
            //edit
            updateItem.make = textFRef.text
            
            do{
                try self.context.save()
            }
            catch{
                
            }
            self.fetchCars()
            
        }
        alert.addAction(save)
        
        //showing the alert
        present(alert, animated: true, completion: nil)
    }
    
}
	
