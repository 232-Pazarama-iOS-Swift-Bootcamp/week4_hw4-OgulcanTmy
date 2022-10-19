//
//  HomeViewModel.swift
//  FlickrClone
//
//  Created by Oğulcan Tamyürek on 19.10.2022.
//

import Foundation
import FirebaseFirestore

enum HomeStateChange {
    case success
    case failure(_ error: Error)
}

class HomeViewModel {
    
    var photosResponse: PhotosResponse? {
        didSet {
            self.changeHandler?(.success)
        }
    }
    
    private let db = Firestore.firestore()
    
    var changeHandler: ((HomeStateChange) -> Void)?
    
    var numberOfRows: Int {
        photosResponse?.photos?.photo?.count ?? .zero
    }
    
    func fetchPhotos() {
        provider.request(.popular) { result in
            switch result {
            case .failure(let error):
                self.changeHandler?(.failure(error))
            case .success(let response):
                do {
                    let photosResponse = try JSONDecoder().decode(PhotosResponse.self, from: response.data)
                    self.photosResponse = photosResponse
                } catch {
                    self.changeHandler?(.failure(error))
                }
            }
        }
    }
    
}
