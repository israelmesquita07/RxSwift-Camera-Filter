//
//  ViewController.swift
//  CameraFilter
//
//  Created by Israel on 17/07/19.
//  Copyright © 2019 israel3D. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nav = segue.destination as? UINavigationController,
              let photoColVC = nav.viewControllers.first as? PhotosCollectionViewController else {return}
        
        photoColVC.selectedPhoto.subscribe(onNext: { [weak self] photo in
            DispatchQueue.main.async {
                self?.updateUI(with: photo)
            }
        }).disposed(by: disposeBag)
        
    }
    
    private func updateUI(with image:UIImage){
        self.photoImageView.image = image
        self.btnFilter.isHidden = false
    }
    
    @IBAction func aplicarFiltroImagem(_ sender: Any) {
        
        guard let sourceImage = self.photoImageView.image else {return}
        FilterService().aplicarFiltro(to: sourceImage).subscribe(onNext: { filteredImage in
            DispatchQueue.main.async {
                self.photoImageView.image = filteredImage
            }
        }).disposed(by: disposeBag)
    }
    
}

