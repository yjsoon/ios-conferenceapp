import UIKit
import MapKit

// UITableViewDelegate: handles user interactions with table rows
// UITableViewDataSource: provides data to populate the table view
class GeneralInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties

    private let tableView = UITableView()
    private let mapView = MKMapView()

    // Array of (label, value) tuples for event details
    private let eventInfo = [
        ("Date", "1st - 3rd December 2025"),
        ("Time", "9:00 AM - 5:00 PM"),
        ("Venue", "Ngee Ann Polytechnic Convention Centre"),
        ("Address", "535 Clementi Rd, Singapore 599489")
    ]

    // MARK: - Lifecycle

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

    // MARK: - Setup

    private func setupMapView() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false

        // Map takes 30% of screen height at the top
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ])

        // CLLocationCoordinate2D represents a geographic location (latitude, longitude)
        // Latitude: how far north/south (Singapore is around 1°N)
        // Longitude: how far east/west (Singapore is around 103°E)
        let ngeeAnnPolytechnicCoordinate = CLLocationCoordinate2D(latitude: 1.332, longitude: 103.774)

        // MKCoordinateRegion defines the visible area of the map
        // latitudinalMeters and longitudinalMeters control zoom level (1000m = 1km visible area)
        let region = MKCoordinateRegion(center: ngeeAnnPolytechnicCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)

        // MKPointAnnotation is a pin dropped on the map
        let annotation = MKPointAnnotation()
        annotation.coordinate = ngeeAnnPolytechnicCoordinate
        annotation.title = "Ngee Ann Polytechnic" // Shows in pin callout when tapped
        mapView.addAnnotation(annotation)
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        // Table view fills remaining space below the map
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: mapView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        // Set delegate and data source to handle table view callbacks
        // delegate = handles user interactions (taps, selection)
        // dataSource = provides the data (number of rows, cell content)
        tableView.delegate = self
        tableView.dataSource = self

        // Register cell types for reuse (optimization - cells are recycled as you scroll)
        // "cell" identifier = used for event info rows
        // "moreInfoCell" identifier = used for the "More info" action row
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "moreInfoCell")

        // Empty footer view removes separator lines below last row
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .systemBackground
    }

    // MARK: - UITableViewDataSource

    /// Tells table view how many rows to display
    /// We have eventInfo.count (4 items) + 1 extra row for "More info" button
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventInfo.count + 1 // 4 event rows + 1 "More info" row = 5 total
    }

    /// Creates and configures each table row
    /// Table view calls this for each visible row (only creates cells currently on screen)
    /// Cells are recycled as you scroll for better performance
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // If this is one of the event info rows (0-3)
        if indexPath.row < eventInfo.count {
            // Dequeue a reusable cell (recycles off-screen cells instead of creating new ones)
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let info = eventInfo[indexPath.row]

            // Modern cell configuration (iOS 14+)
            // defaultContentConfiguration() gives us a pre-configured layout
            var content = cell.defaultContentConfiguration()
            content.text = info.0 // Primary text (e.g., "Date")
            content.secondaryText = info.1 // Secondary text (e.g., "1st - 3rd December 2025")
            cell.contentConfiguration = content

            // No tap highlight or arrow indicator for info rows
            cell.selectionStyle = .none
            cell.accessoryType = .none
            return cell
        }
        // Last row is the "More info" action button
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "moreInfoCell", for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = "More info"
            content.textProperties.color = view.tintColor // Use app's tint color (looks like a link)
            content.secondaryText = nil // No subtitle
            cell.contentConfiguration = content

            // Show chevron arrow and allow tap highlight
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
            return cell
        }
    }

    // MARK: - UITableViewDelegate

    /// Called when user taps a row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Only respond if they tapped the "More info" row (last row)
        guard indexPath.row == eventInfo.count else { return }

        // Deselect row so highlight fades out
        tableView.deselectRow(at: indexPath, animated: true)

        // Navigate to More Info screen
        showMoreInfo()
    }

    // MARK: - Navigation

    @objc private func showMoreInfo() {
        let moreInfoVC = MoreInfoViewController()
        navigationController?.pushViewController(moreInfoVC, animated: true)
    }
}
