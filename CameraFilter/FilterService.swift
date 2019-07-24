//
//  FilterService.swift
//  CameraFilter
//
//  Created by Israel on 19/07/19.
//  Copyright © 2019 israel3D. All rights reserved.
//

import Foundation
import UIKit
import CoreImage
import RxSwift

class FilterService {
    
    private var context:CIContext
    
    init() {
        self.context = CIContext()
    }
    
    func aplicarFiltro(to inputImage:UIImage) -> Observable<UIImage> {
        
        return Observable<UIImage>.create { observer in
            
            self.aplicarFiltro(to: inputImage) { filteredImage in
                observer.onNext(filteredImage)
            }
            return Disposables.create()
        }
    }
    
    private func aplicarFiltro(to inputImage:UIImage, completion: @escaping((UIImage) -> ())){
        
        let filter = CIFilter(name: "CICMYKHalftone")!
        filter.setValue(5.0, forKey: kCIInputWidthKey)
        
        if let sourceImage = CIImage(image: inputImage){
            
            filter.setValue(sourceImage, forKey: kCIInputImageKey)
            
            if let cgimg = self.context.createCGImage(filter.outputImage!, from: filter.outputImage!.extent){
             
                let processedImage = UIImage(cgImage: cgimg, scale: inputImage.scale, orientation: inputImage.imageOrientation)
                completion(processedImage)
            }
        }
    }
}
