//
//  APIManager.swift
//  NextCars
//
//  Created by Anusha Kottiyal on 7/15/19.
//  Copyright © 2019 NextDigit. All rights reserved.
//

import Foundation

class APIManager: NSObject {
}

// MARK: - To implement API service methods
extension APIManager: APIService {
    
    private func getRequest(_ url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) {
        
        DispatchQueue.global(qos: .background).async {
            let session = URLSession.shared
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = session.dataTask(with: request) { data, response, error in
                completionHandler(data, response, error)
            }
            task.resume()
        }
    }
    
    func getDataSet(_ endPoint: String, complete: @escaping (_ success: Bool, _ dataSetId: String?, _ error: APIError?)->()) {
        guard let url = URL(string: endPoint) else {
            complete(false, nil, APIError.invalidURL)
            return
        }
        
        // Execute Get Request
        getRequest(url) { (data, response, error) in
            
            guard let jsonData = data else { return }
            do {
                // Decode data to object
                let jsonDecoder = JSONDecoder()
                let dataSet = try jsonDecoder.decode(DataSet.self, from:
                    jsonData)
                complete(true, dataSet.id, nil)
            } catch {
                complete(false, nil, APIError.dataError)
            }
        }
    }
    
    func fetchVehicles(_ endPoint: String, complete: @escaping (_ success: Bool, _ vehicleIds: [Int64], _ error: APIError? )->()) {
        
        guard let url = URL(string: endPoint) else {
            complete(false, [], APIError.invalidURL)
            return
        }
        
        // Execute Get Request
        getRequest(url) { (data, response, error) in
            
            guard let jsonData = data else { return }
            do {
                // Decode data to object
                let jsonDecoder = JSONDecoder()
                let result = try jsonDecoder.decode(VehicleList.self, from:
                    jsonData)
                complete(true, result.vehicleIds, nil)
            } catch {
                print(error)
                complete(false, [], APIError.dataError)
            }
        }
    }
    
    func fetchVehicleInfo(_ endPoint: String, complete: @escaping (_ success: Bool, _ vehicleInfo: VehicleInfo?, _ error: APIError? )->()) {
        
        guard let url = URL(string: endPoint) else {
            complete(false, nil, APIError.invalidURL)
            return
        }
        
        // Execute Get Request
        getRequest(url) { (data, response, error) in
            
            guard let jsonData = data else { return }
            do {
                // Decode data to object
                let jsonDecoder = JSONDecoder()
                let result = try jsonDecoder.decode(VehicleInfo.self, from:
                    jsonData)
                complete(true, result, nil)
            } catch {
                print(error)
                complete(false, nil, APIError.dataError)
            }
        }
    }
    
    func fetchDealershipInfo(_ endPoint: String, complete: @escaping (_ success: Bool, _ vehicleInfo: DealershipInfo?, _ error: APIError? )->()) {
        
        guard let url = URL(string: endPoint) else {
            complete(false, nil, APIError.invalidURL)
            return
        }
        
        // Execute Get Request
        getRequest(url) { (data, response, error) in
            
            guard let jsonData = data else { return }
            do {
                // Decode data to object
                let jsonDecoder = JSONDecoder()
                let result = try jsonDecoder.decode(DealershipInfo.self, from:
                    jsonData)
                complete(true, result, nil)
            } catch {
                print(error)
                complete(false, nil, APIError.dataError)
            }
        }
    }
    
    func fetchDealerships(_ endPoint: String, complete: @escaping (_ success: Bool, _ dealerships: [DealershipInfo], _ error: APIError? )->()) {
        
        guard let url = URL(string: endPoint) else {
            complete(false, [], APIError.invalidURL)
            return
        }
        
        // Execute Get Request
        getRequest(url) { (data, response, error) in
            
            guard let jsonData = data else { return }
            do {
                // Decode data to object
                let jsonDecoder = JSONDecoder()
                let result = try jsonDecoder.decode(Result.self, from:
                    jsonData)
                complete(true, result.dealers, nil)
            } catch {
                print(error)
                complete(false, [], APIError.dataError)
            }
        }
    }
    
    // Fetch photo
    func fetchPhoto(_ photoURL: String, complete: @escaping (Data?, APIError?) -> Void) {
        
        guard let url = URL(string: photoURL) else {
            complete(nil, APIError.invalidURL)
            return
        }
        
        // Execute Get Request
        getRequest(url) { (data, response, error) in
            guard error == nil, let imageData = data  else {
                complete(nil, APIError.dataError)
                return
            }
            complete(imageData, nil)
        }
    }
}
