
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
        
        setupMapView()
        setupTableView()
        setupMoreInfoButton()
    }
    
    private func setupMoreInfoButton() {
        let moreInfoButton = UIButton(type: .system)
        moreInfoButton.setTitle("More Info", for: .normal)
        moreInfoButton.addTarget(self, action: #selector(showMoreInfo), for: .touchUpInside)
        
        view.addSubview(moreInfoButton)
        moreInfoButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            moreInfoButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            moreInfoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
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
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let info = eventInfo[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = info.0
        content.secondaryText = info.1
        cell.contentConfiguration = content
        return cell
    }
}
