//
//  FlickrAPI.swift
//  FlickrClone
//
//  Created by Oğulcan Tamyürek on 19.10.2022.
//

import Moya

let plugin: PluginType = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
let provider = MoyaProvider<FlickrAPI>(plugins: [plugin])

enum FlickrAPI {
    case recent
    case popular
}

// MARK: - TargetType
extension FlickrAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://www.flickr.com/services/rest") else {
            fatalError("Base URL not found or not in correct format.")
        }
        return url
    }
    
    var path: String {
        return "/"
    }
    
    var method: Moya.Method {
        .get
    }
    
    // URL: https://www.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=67271678b774c70a1734f50fee53cc00&format=json&nojsoncallback=1
    var task: Moya.Task {
            let parameters = ["method": "flickr.photos.getRecent",
                              "api_key": "67271678b774c70a1734f50fee53cc00",
                              "format": "json",
                              "nojsoncallback": "1"]
            return .requestParameters(parameters: parameters,
                                      encoding: URLEncoding.queryString)
    }
    
    var headers: [String : String]? {
        nil
    }
}
