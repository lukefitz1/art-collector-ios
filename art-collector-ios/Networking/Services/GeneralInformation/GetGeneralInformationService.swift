//
//  GetGeneralInformationService.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/4/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

struct GetGeneralInformationService {
    var deserializer: GetGeneralInformationServiceDeserializerProtocol
    
    init(deserializer: GetGeneralInformationServiceDeserializerProtocol = GetGeneralInformationServiceDeserializer()) {
        self.deserializer = deserializer
    }
    
    func getGeneralInfo(giId: String, completionHandler: ((GeneralInformation?, Error?) -> Void)?) {
        let endpoint = buildEndpoint(id: giId)
        let headers: HTTPHeaders = [
            "access-token": ApiClient.accessToken,
            "client": ApiClient.client,
            "uid": ApiClient.uid,
            "expiry": ApiClient.expiry,
            "token-type": ApiClient.tokenType
        ]
        
        var data : GeneralInformation?
        
        AF.request(endpoint,
                   headers: headers).responseJSON { responseJSON in
                    
                    switch responseJSON.result {
                    case .success:
                        if let safeData = responseJSON.data {
                            data = self.parseJSON(giData: safeData)
                        }
                        
                        completionHandler?(data, nil)
                    case let .failure(error):
                        print(error)
                        completionHandler?(nil, error)
                    }
        }
    }
    
    func parseJSON(giData: Data) -> GeneralInformation? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(GeneralInformation.self, from: giData)
            return decodedData
        } catch  {
            print(error)
        }
        
        return nil
    }
    
    private func buildEndpoint(id: String) -> URL {
        return URL(string: "\(ApiClient.baseUrl)general_informations/\(id)")!
    }
}
