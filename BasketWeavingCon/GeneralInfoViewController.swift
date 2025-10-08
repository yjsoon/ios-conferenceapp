
import UIKit
import MapKit

class GeneralInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView = UITableView()
    private let mapView = MKMapView()
    
    private let eventInfo = [
        ("Date", "1st - 3rd December 2025"),
        ("Time", "9:00 AM - 5:00 PM"),
        ("Venue", "Ngee Ann Polytechnic Convention Centre"),
        ("Address", "535 Clementi Rd, Singapore 599489")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "General Info"
        navigationItem.largeTitleDisplayMode = .always
        
        setupMapView()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    @objc private func showMoreInfo() {
        let moreInfoVC = MoreInfoViewController()
        navigationController?.pushViewController(moreInfoVC, animated: true)
    }
    
    private func setupMapView() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ])
        
        let ngeeAnnPolytechnicCoordinate = CLLocationCoordinate2D(latitude: 1.332, longitude: 103.774)
        let region = MKCoordinateRegion(center: ngeeAnnPolytechnicCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = ngeeAnnPolytechnicCoordinate
        annotation.title = "Ngee Ann Polytechnic"
        mapView.addAnnotation(annotation)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: mapView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "moreInfoCell")
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .systemBackground
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventInfo.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < eventInfo.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let info = eventInfo[indexPath.row]
            var content = cell.defaultContentConfiguration()
            content.text = info.0
            content.secondaryText = info.1
            cell.contentConfiguration = content
            cell.selectionStyle = .none
            cell.accessoryType = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "moreInfoCell", for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = "More info"
            content.textProperties.color = view.tintColor
            content.secondaryText = nil
            cell.contentConfiguration = content
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row == eventInfo.count else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        showMoreInfo()
    }
}
