//
//  GeneralInformationCreateService.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 1/20/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

struct GeneralInformationCreateService {
    
    let serializer: GeneralInformationCreateServiceSerializerProtocol
    let deserializer: GeneralInformationCreateServiceDeserializerProtocol
    
    init(deserializer: GeneralInformationCreateServiceDeserializerProtocol = GeneralInformationCreateServiceDeserializer(),
         serializer: GeneralInformationCreateServiceSerializerProtocol = GeneralInformationCreateServiceSerializer()) {
        self.deserializer = deserializer
        self.serializer = serializer
    }
    
    func createGeneralInformation(id: String,
                                  infoLabel: String,
                                  info: String,
                                  createdAt: String,
                                  updatedAt: String,
                                  completionHandler: ((GeneralInformation?, Error?) -> Void)?) {
        
        let fullEndpoint = buildEndpoint()
        let headers: HTTPHeaders = [
            "access-token": ApiClient.accessToken,
            "client": ApiClient.client,
            "uid": ApiClient.uid,
            "expiry": ApiClient.expiry,
            "token-type": ApiClient.tokenType
        ]
        let parameters = buildParameters(id: id, informationLabel: infoLabel, information: info, createdAt: createdAt, updatedAt: updatedAt)
        
        var data : GeneralInformation?
        
        AF.request(fullEndpoint,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding(),
                   headers: headers).responseJSON { responseJSON in
                    debugPrint(responseJSON)
                    
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
    
    private func parseJSON(giData: Data) -> GeneralInformation? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(GeneralInformation.self, from: giData)
            return decodedData
        } catch  {
            print(error)
        }
        
        return nil
    }
    
    private func buildEndpoint() -> URL {
        return URL(string: "\(ApiClient.baseUrl)general_informations")!
    }
    
    private func buildParameters(id: String,
                                 informationLabel: String,
                                 information: String,
                                 createdAt: String,
                                 updatedAt: String) -> Parameters {
        
        let parameters = serializer.serialize(id: id, infoLabel: informationLabel, info: information, createdAt: createdAt, updatedAt: updatedAt)
        return parameters
    }
}
