//
//  Copyright © 2017 REA. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var tramTimesTable: UITableView!
    @IBOutlet weak var clearButton: UIBarButtonItem!
    @IBOutlet weak var loadButton: UIBarButtonItem!
    
    // MARK: - Properties
    var northTrams: [Tram]?
    var southTrams: [Tram]?
    var loadingNorth: Bool = false
    var loadingSouth: Bool = false
    let tokenLoader = TokenLoader()
    let tramLoader = TramsLoader()
    let northStopId = "4055"
    let southStopId = "4155"
    var timer:Timer!
    
    // MARK: - Methods - Overridden
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        clearTramData()
        loadTramData()
    }
    
    // MARK: - IBActions
    @IBAction func clearButtonTapped(_ sender: UIBarButtonItem) {
        clearTramData()
    }
    
    @IBAction func loadButtonTapped(_ sender: UIBarButtonItem) {
        clearTramData()
        loadTramData()
    }
    
}

// MARK: - Tram Data

extension ViewController {
    
    // MARK: - Selectors
    @objc func updateRemainingTime(){
        guard let visibleIndexPaths = tramTimesTable.indexPathsForVisibleRows else {return}
        tramTimesTable.beginUpdates()
        tramTimesTable.reloadRows(at:visibleIndexPaths , with: .none)
        tramTimesTable.endUpdates()
    }
    
    @objc func refresh(sender:AnyObject) {
        clearTramData()
        loadTramData()
    }
    
    // MARK: - Methods
    func configureViews(){
        tramTimesTable.register(UINib(nibName: "TramDetailTVC", bundle: nil), forCellReuseIdentifier: tvcDetailIdentifier)
        tramTimesTable.register(UINib(nibName: "TramsNotFoundTVC", bundle: nil), forCellReuseIdentifier: tvcTramNotFoundIdentifier)
        refreshControl = UIRefreshControl()
        refreshControl!.attributedTitle = NSAttributedString(string: reloadingTrams)
        refreshControl!.addTarget(self, action:#selector(refresh(sender:)) , for: UIControl.Event.valueChanged)
        timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(updateRemainingTime), userInfo: nil, repeats: true)
    }
    
    func clearTramData() {
        northTrams = nil
        southTrams = nil
        loadingNorth = false
        loadingSouth = false
        tramTimesTable.reloadData()
    }
    
    func loadTramData() {
        loadingNorth = true
        loadingSouth = true

        let token = DataManager.shared.getToken()
        if token.isEmpty{
            self.loadTokenIfNotFound()
        }else{
            self.loadNorthBoundTrams()
            self.loadSouthBoundTrams()
        }
    }

    func loadTokenIfNotFound(){
        tokenLoader.loadToken {[weak self] (token, error) in
            guard let weakSelf = self else {return}
            if error == nil && !(token?.isEmpty)! {
                DataManager.shared.saveTokenLocally(token: token!)
                weakSelf.loadNorthBoundTrams()
                weakSelf.loadSouthBoundTrams()
            }else{
                // STOP loading and show error
                _ = weakSelf.showAlert(titleOops, message: errorLoadingToken, buttonsDictionary: [ titleOK: {(alertAction) in
                    // Can perform any tasks here upon OK if needed
                    }], baseController: self, preferredStyle: .alert)
            }
        }
    }
    
    func loadNorthBoundTrams() {
        self.tramLoader.loadTrams(stopID: self.northStopId, completion: { [weak self] (northTrams, error) in
            guard let weakSelf = self else{return}
            //North Trams Loaded
            if error == nil {
                weakSelf.refreshControl?.endRefreshing()
                weakSelf.loadingNorth = false
                weakSelf.northTrams = northTrams
                weakSelf.tramTimesTable.reloadSections(IndexSet(integer: 0), with: .automatic)
            }else{
                //Error Alert
                weakSelf.refreshControl?.endRefreshing()
                weakSelf.loadingNorth = false
                _ = weakSelf.showAlert(titleOops, message: errorLoadingNorthTrams, buttonsDictionary: [ titleOK: {(alertAction) in
                    // Can perform any tasks here upon OK if needed
                    }], baseController: self, preferredStyle: .alert)
            }
        })
    }
    
    func loadSouthBoundTrams(){
        self.tramLoader.loadTrams(stopID: self.southStopId, completion: {[weak self] (southTrams, error) in
            guard let weakSelf = self else{return}
            
            //South Trams Loaded
            if error == nil {
                weakSelf.refreshControl?.endRefreshing()
                weakSelf.loadingSouth = false
                weakSelf.southTrams = southTrams
                weakSelf.tramTimesTable.reloadSections(IndexSet(integer: 1), with: .automatic)
            }else{
                //Error Alert
                weakSelf.refreshControl?.endRefreshing()
                weakSelf.loadingSouth = false
                _ = weakSelf.showAlert(titleOops, message: errorLoadingSouthTrams, buttonsDictionary: [titleOK: {(alertAction) in
                    // Can perform any tasks here upon OK if needed
                    }], baseController: self, preferredStyle: .alert)
            }
            
        })
    }
    
    func tramsFor(section: Int) -> [Tram]? {
        return (section == 0) ? northTrams : southTrams
    }
    
    func isLoading(section: Int) -> Bool {
        return (section == 0) ? loadingNorth : loadingSouth
    }
}


// MARK - UITableViewDataSource

extension ViewController {
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let trams = tramsFor(section: indexPath.section)
        
        
        guard let tram = trams?[indexPath.row]  else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: tvcTramNotFoundIdentifier, for: indexPath) as! TramsNotFoundTVC
            
            if isLoading(section: indexPath.section) {
                cell.configCell(message: loadingUpcommingTrams)
            } else {
                cell.configCell(message: noUpcommingTrams)
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: tvcDetailIdentifier, for: indexPath) as! TramDetailTVC
        cell.configCell(tram: tram)
        return cell;
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0)
        {
            guard let count = northTrams?.count else { return 1 }
            return count
        }
        else
        {
            guard let count = southTrams?.count else { return 1 }
            return count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? northBoundTramsTitle : southBoundTramsTitle
    }
}
