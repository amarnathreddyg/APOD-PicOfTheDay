//
//  ViewController.swift
//  APOD
//
//  Created by Amarnath Gopireddy on 4/14/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var dateButton: UIButton!
    
    var viewModel:APODViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "PIC OF THE DAY"
        NetworkStatus.shared.listener = { (isConected) in
            DispatchQueue.main.async { [unowned self] in
                fetchData()
            }
        }
        NetworkStatus.shared.start()
        viewModel = APODViewModel()
    }

    func fetchData() {
        viewModel?.getApodDataFromAPI(with: { [weak self] (errorMessage) in
            DispatchQueue.main.async {
                self?.infoLabel.text = errorMessage
                self?.imageView.image = self?.viewModel?.image
                self?.titleLabel.text = self?.viewModel?.title
                self?.descriptionTextView.text = self?.viewModel?.description
                self?.dateButton.setTitle(self?.viewModel?.date, for: .normal)
            }
        })
    }
    
    deinit {
        NetworkStatus.shared.stop()
    }
}

