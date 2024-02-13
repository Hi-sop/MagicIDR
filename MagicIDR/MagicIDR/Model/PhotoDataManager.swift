//
//  PhotoData.swift
//  MagicIDR
//
//  Created by Hisop on 2024/02/13.
//

import CoreImage

struct CutPoint {
    let topLeft: CGPoint
    let topRight: CGPoint
    let bottomLeft: CGPoint
    let bottomRight: CGPoint
}

final class PhotoData {
    var image: CIImage
    let cutPoint: CutPoint
    let widthRatio: CGFloat
    let heightRatio: CGFloat
    
    init(image: CIImage, cutPoint: CutPoint, widthRatio: CGFloat, heightRatio: CGFloat) {
        self.image = image
        self.cutPoint = cutPoint
        self.widthRatio = widthRatio
        self.heightRatio = heightRatio
    }
}

final class PhotoDataManager {
    private var photoDataArray: [PhotoData] = []
    
    func addPhotoData(data: PhotoData) {
        photoDataArray.append(data)
    }
    
    func removePhotoData(at: Int) {
        photoDataArray.remove(at: at)
    }
    
    func loadPhotoData() -> [PhotoData] {
        return photoDataArray
    }
}
