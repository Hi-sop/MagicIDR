//
//  PhotoData.swift
//  MagicIDR
//
//  Created by Hisop on 2024/02/13.
//

import Foundation

struct CutPoint {
    let topLeft: CGPoint
    let topRight: CGPoint
    let bottomLeft: CGPoint
    let bottomRight: CGPoint
}

final class PhotoData {
    let image: Data
    let cutPoint: CutPoint
    
    init(image: Data, cutPoint: CutPoint) {
        self.image = image
        self.cutPoint = cutPoint
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
}
