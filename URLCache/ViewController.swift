//
//  ViewController.swift
//  URLCache
//
//  Created by Alex Paul on 3/23/21.
//

import UIKit

class ViewController: UIViewController {
  
  let apiClient = APIClient()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("viewDidLoad")
    fetchData()
  }
  
  func fetchData() {
    apiClient.fetchData { [weak self] (result) in
      switch result {
      case .failure(let error):
        print(error)
      case .success(let podcasts):
        print("results: \(podcasts.count) podcasts")
      }
      
      // automatically clear the cache
      // this could be a UI element or similar
      
      // to test ONLY getting response from cache comment the code below
      self?.apiClient.clearCache()
    }
  }
  
}

