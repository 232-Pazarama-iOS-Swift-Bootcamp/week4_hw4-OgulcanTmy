//
//  Photos.swift
//  FlickrClone
//
//  Created by Oğulcan Tamyürek on 19.10.2022.
//

import Foundation

struct PhotosResponse: Codable {
    var photos: Photos?
    var stat: String?
}

struct Photos: Codable {
    var page: Int?
    var pages: Int?
    var perpage: Int?
    var total: Int?
    var photo: [Photo]?
}

struct Photo: Codable {
    var id: String?
    var owner: String?
    var secret: String?
    var server: String?
    var farm: Int?
    var title: String?
}

extension Photo {
    init(from dict: [String : Any]) {
        id = dict["id"] as? String
        owner = dict["owner"] as? String
        secret = dict["secret"] as? String
        server = dict["server"] as? String
        farm = dict["farm"] as? Int
        title = dict["title"] as? String
    }
}
