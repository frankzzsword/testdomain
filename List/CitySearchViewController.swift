
import UIKit
import GoogleMaps

class CitySearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var placesClient: GMSPlacesClient?
    var searchActive : Bool = false
    var data = [GMSAutocompletePrediction]()
    var placeQueryArray: [GMSAutocompletePrediction] = []
    var delegate: searchDisplayProtocol?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placesClient = GMSPlacesClient()
        /* Setup delegates */
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
        searchBar.text = ""
        tableView.reloadData()
        
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        self.data.removeAll()
        self.placeQueryArray.removeAll()
        searchBar.text = ""
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    
    func placeAutocomplete(cityName: String,  completionHandler: (cityArray: [GMSAutocompletePrediction]) -> ())  {
        self.placeQueryArray.removeAll()
        let filter = GMSAutocompleteFilter()
        filter.type = GMSPlacesAutocompleteTypeFilter.City
        placesClient?.autocompleteQuery(cityName, bounds: nil, filter: filter, callback: { (results, error: NSError?) -> Void in
            if let error = error {
                println("Autocomplete error \(error)")
            }
            for result in results! {
                if let result = result as? GMSAutocompletePrediction {                    self.placeQueryArray.append(result)
                }
            }
            completionHandler(cityArray: self.placeQueryArray)
            
        })
        
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(!searchBar.text.isEmpty) {
            placeAutocomplete(searchBar.text) {
                (cityArray: [GMSAutocompletePrediction]) -> () in
                self.data = self.placeQueryArray
                self.tableView.reloadData()
            }
            if(data.count == 0){
                searchActive = false;
            } else {
                searchActive = true;
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return data.count
        }
        return 0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell;
        if(searchActive){
            var cityName = data[indexPath.row].attributedFullText
            cell.textLabel?.text = cityName.string
        }
        
        return cell;
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "displaySearchResults"
//        {
//            if let destination = segue.destinationViewController as? MainTableViewController {
//                if let cityIndex = tableView.indexPathForSelectedRow()?.row {
//                    destination.placeNumber = data[cityIndex].placeID
//                }
//            }
//        }
//        
//    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = tableView.indexPathForSelectedRow()
        var placeIDNumber = data[indexPath!.row].placeID
        println(data[indexPath!.row].attributedFullText)
        delegate?.getFromCity(placeIDNumber!)
            
        self.navigationController?.popToRootViewControllerAnimated(true)
       
        // return back to previous view
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}