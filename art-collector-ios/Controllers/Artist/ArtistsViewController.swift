//
//  ArtistsViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/17/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit

class ArtistsViewController: UIViewController {
    
    @IBOutlet weak var artistsTableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    
    var progressHUD: MBProgressHUDProtocol = MBProgressHUDClient()
    var selectedArtist: Artist?
    
    var artists: [Artist] = [] {
        didSet {
            guard isViewLoaded else {
                return
            }
            artistsTableView.reloadData()
        }
    }
    
    @objc private func refreshArtistsData(_ sender: Any) {
        getArtists(refresh: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Artists"
        
        artistsTableView.delegate = self
        artistsTableView.dataSource = self
        
        artistsTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshArtistsData(_:)), for: .valueChanged)
        
        getArtists(refresh: false)
    }
    
    @objc func newArtist() {
        print("Button pressed")
    }
    
    func getArtists(refresh: Bool) {
        artists = []
        let artistService = ArtistsService()
        
        if !refresh {
            progressHUD.show(onView: view, animated: true)
        }
        artistService.getArtists { [weak self] artistData, error in
            guard let self = self else {
                return
            }
            
            if let e = error {
                print("Issue getting artist data (Artists GET request) - \(e)")
                return
            } else {
                if let artists = artistData {
                    if !refresh {
                        self.progressHUD.hide(onView: self.view, animated: true)
                    } else {
                        self.refreshControl.endRefreshing()
                    }
                    self.artists = artists
                }
            }
        }
    }
    
    @IBAction func addArtist(_ sender: Any) {
        print("buttonPressed")
    }
    
    @IBAction func unwindToArtistsViewController(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.getArtists(refresh: false)
            }
        }
    }
}

extension ArtistsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistCell", for: indexPath)
        
        cell.textLabel?.text = "\(artists[indexPath.row].firstName ?? "test") \(artists[indexPath.row].lastName ?? "test")"
        return cell
    }
}

extension ArtistsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let artist = artists[indexPath.row]
        selectedArtist = artist

        let artistDetailViewController = ArtistDetailViewController()
        artistDetailViewController.artist = selectedArtist

        self.performSegue(withIdentifier: "ArtistDetailSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ArtistDetailSegue" {
            let destinationVC = segue.destination as! ArtistDetailViewController

            destinationVC.artist = selectedArtist
        }
    }
}
