//
//  APIClient.swift
//  URLCache
//
//  Created by Alex Paul on 3/23/21.
//

import Foundation

struct PodcastWrapper: Codable {
  let results: [Podcast]
}

struct Podcast: Codable {
  let collectionName: String
}

struct APIClient {
  func fetchData(completion: @escaping (Result<[Podcast], Error>) -> ()) {
    let session = URLSession.shared
    let url = URL(string: "https://itunes.apple.com/search?media=podcast&limit=200&term=swift")!
    var request = URLRequest(url: url)
    
    // see caching policy doc here: https://developer.apple.com/documentation/foundation/nsurlrequest/cachepolicy/useprotocolcachepolicy
    request.cachePolicy = .returnCacheDataElseLoad
        
    if let cacheResponse = session.configuration.urlCache?.cachedResponse(for: request) {
      // cache is available
      do {
        let searches = try JSONDecoder().decode(PodcastWrapper.self, from: cacheResponse.data)
        let podcasts = searches.results
        print("from cache")
        completion(.success(podcasts))
        return
      } catch {
        completion(.failure(error))
        return
      }
    } else {
      // we are making a GET request to the Web API or backend
      let dataTask = session.dataTask(with: request) { (data, response, error) in
        if let error = error {
          completion(.failure(error))
          return
        }
        
        if let data = data {
          do {
            let searches = try JSONDecoder().decode(PodcastWrapper.self, from: data)
            let podcasts = searches.results
            print("from server")
            completion(.success(podcasts))
            return
          } catch {
            completion(.failure(error))
            return
          }
        }
      }
      dataTask.resume()
    }
    
  }
  
  func clearCache() {
    let url = URL(string: "https://itunes.apple.com/search?media=podcast&limit=200&term=swift")!
    var request = URLRequest(url: url)
    request.cachePolicy = .returnCacheDataElseLoad
    URLCache.shared.removeCachedResponse(for: request)
  }
}
