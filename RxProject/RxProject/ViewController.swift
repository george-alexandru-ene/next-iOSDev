//
//  ViewController.swift
//  RxProject
//
//  Created by andreea.zanfir on 21/03/2020.
//  Copyright © 2020 andreea.zanfir. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var applyFilterButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController, let photosCVC = navC.viewControllers.first as? PhotosCollectionViewController else {
            fatalError("Segue dest not found")
        }
        
        photosCVC.selectedPhoto.subscribe(onNext: { [weak self] photo in
                DispatchQueue.main.async {
                    self?.updateUI(with: photo)
                }
            }).disposed(by: disposeBag)
    }
    
    private func updateUI(with image: UIImage) {
        self.photoImageView.image = image
        self.applyFilterButton.isHidden = false
    }
    
    @IBAction func applyFilterButtonPressed(_ sender: Any) {
        guard let sourceImage = self.photoImageView.image else {
            return
        }
        
        FiltersService().applyFilter(to: sourceImage)
            .subscribe(onNext: { filteredImage in
                DispatchQueue.main.async {
                    self.photoImageView.image = filteredImage
                }
            }).disposed(by: disposeBag)
        
//        FiltersService().applyFilter(to: sourceImage) { filteredImage in
//            DispatchQueue.main.async {
//                self.photoImageView.image = filteredImage
//            }
//        }
    }
}

