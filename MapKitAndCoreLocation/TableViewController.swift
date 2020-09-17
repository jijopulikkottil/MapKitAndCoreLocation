//
//  TableViewController.swift
//  MapKitAndCoreLocation
//
//  Created by Jijo Pulikkottil on 16/09/20.
//  Copyright © 2020 MVoc. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    enum DemoView: CaseIterable {
        case mapView
        case overLays
        case annotation
        case userLocation
        case geofence
        
        var displayValue: String {
            switch self {

            case .mapView:
                return "Map view"
            case .overLays:
                return "Overlays"
            case .annotation:
                return "Annotations"
            case .userLocation:
                return "User Location"
            case .geofence:
                return "Region Monitoring"
            }
        }
    }
    
    @IBOutlet var tableView: UITableView!
    var arrayItems: [DemoView]?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        arrayItems = DemoView.allCases
        title = "Map and Locations"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell") else { fatalError() }
        cell.textLabel?.text = arrayItems?[indexPath.row].displayValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let item = arrayItems?[indexPath.row] else { return }
        switch item {
        
        case .mapView:
            performSegue(withIdentifier: "ShowMapview", sender: nil)
        case .overLays:
            performSegue(withIdentifier: "ShowOverlay", sender: nil)
        case .annotation:
            performSegue(withIdentifier: "ShowAnnotation", sender: nil)
        case .userLocation:
            performSegue(withIdentifier: "ShowUserLocation", sender: nil)
        case .geofence:
            performSegue(withIdentifier: "ShowGeofence", sender: nil)
        }
        
    }
}
