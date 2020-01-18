//
//  GeneralInformationService.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/17/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

struct GeneralInformationService {
    var deserializer: GeneralInformationServiceDeserializerProtocol
    
    init(deserializer: GeneralInformationServiceDeserializerProtocol = GeneralInformationServiceDeserializer()) {
        self.deserializer = deserializer
    }
    
    func getGeneralInformation(completionHandler: (([GeneralInformation]?, Error?) -> Void)?) {
        let endpoint = buildEndpoint()
                    let headers: HTTPHeaders = [
                        "Authorization": "Bearer \(ApiClient.authToken)"
                    ]
                    var data : [GeneralInformation] = []
                    
                    AF.request(endpoint,
                               headers: headers).responseJSON { responseJSON in
//                         debugPrint(responseJSON)
                                
                                switch responseJSON.result {
                                    case .success:
                                        if let safeData = responseJSON.data {
                                            data = self.parseJSON(generalInfoData: safeData)
                                        }
                                        
                                        completionHandler?(data, nil)
                                    case let .failure(error):
                                        print(error)
                                        completionHandler?(nil, error)
                                }
                    }

    }
    
    func parseJSON(generalInfoData: Data) -> [GeneralInformation] {
            let decoder = JSONDecoder()
            
            do {
                let decodedData = try decoder.decode([GeneralInformation].self, from: generalInfoData)
                return decodedData
            } catch  {
                print(error)
            }
        
            return []
        }
    
    private func buildEndpoint() -> URL {
        return URL(string: "\(ApiClient.baseUrl)general_informations")!
    }
}
