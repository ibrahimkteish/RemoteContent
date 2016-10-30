//
//  APIAccess.swift
//  RemoteContent
//
//  Created by Ibrahim Kteish on 10/30/16.
//  Copyright © 2016 Ibrahim Kteish. All rights reserved.
//

import Foundation

typealias JSON = [String: Any]

struct Resource<T> {
    let url: URL
    let parse: (Data) -> T?
}

extension Resource {
    init(url: URL, parseJSON: @escaping (Any) -> T?) {
        self.url = url
        self.parse = { data in
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
           print(type(of: json))
            return json.flatMap(parseJSON)
        }
    }
}


final class Webservice {
    func load<T>(resource: Resource<T>, completion: @escaping (T?) -> ()) {
        URLSession.shared.dataTask(with: resource.url) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(resource.parse(data))
            }.resume()
    }
}
