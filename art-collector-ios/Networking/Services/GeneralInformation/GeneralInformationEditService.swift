//
//  GeneralInformationEditService.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 3/4/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import Foundation
import Alamofire

struct GeneralInformationEditService {
    
    let serializer: GeneralInformationEditServiceSerializerProtocol
    let deserializer: GeneralInformationCreateServiceDeserializerProtocol
    
    init(deserializer: GeneralInformationCreateServiceDeserializerProtocol = GeneralInformationCreateServiceDeserializer(),
         serializer: GeneralInformationEditServiceSerializerProtocol = GeneralInformationEditServiceSerializer()) {
        self.deserializer = deserializer
        self.serializer = serializer
    }
    
    func updateGeneralInformation(id: String,
                                  infoLabel: String,
                                  info: String,
                                  createdAt: String,
                                  updatedAt: String,
                                  completionHandler: ((GeneralInformation?, Error?) -> Void)?) {
        
        let fullEndpoint = buildEndpoint(giId: id)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(ApiClient.authToken)"
        ]
        let parameters = buildParameters(informationLabel: infoLabel, information: info, createdAt: createdAt, updatedAt: updatedAt)
        
        var data : GeneralInformation?
        
        AF.request(fullEndpoint,
                   method: .put,
                   parameters: parameters,
                   encoding: JSONEncoding(),
                   headers: headers).responseJSON { responseJSON in
//                    debugPrint(responseJSON)
                    
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
    
    private func buildEndpoint(giId: String) -> URL {
        return URL(string: "\(ApiClient.baseUrl)general_informations/\(giId)")!
    }
    
    private func buildParameters(informationLabel: String,
                                 information: String,
                                 createdAt: String,
                                 updatedAt: String) -> Parameters {
        
        let parameters = serializer.serialize(infoLabel: informationLabel, info: information, createdAt: createdAt, updatedAt: updatedAt)
        return parameters
    }
}

