//
//  NetworkingLoggerPlugin.swift
//
//
//  Created by Piotr Prokopowicz on 20/12/2020.
//

import Foundation
import Networking

public struct NetworkingLoggerPlugin: NetworkingPlugin {
    
    public enum Element {
        case date
        case libraryName
        case emoji
        case statusCode
        case httpMethod
        case url
        case headers
        case data
        
        fileprivate func logValue<Service: NetworkingService>(service: Service, event: NetworkingPluginEvent, encoder: JSONEncoder, decoder: JSONDecoder) -> String? {
            switch event {
            case .dataRequested: return dataRequestedLogValue(service: service, event: event, encoder: encoder)
            case .unableToParseRequest: return unableToParseRequestLogValue(service: service, event: event)
            case .responseError(let data, let status): return responseErrorLogValue(service: service, event: event, data: data, status: status)
            case .success(let data, let status): return successLogValue(service: service, event: event, data: data, status: status)
            }
        }
    }
    
    private let logElements: [Element]
    
    public init(elements: [Element] = [.date, .libraryName, .emoji, .statusCode, .httpMethod, .url, .headers, .data]) {
        logElements = elements
    }
    
    public func body<Service: NetworkingService>(service: Service, event: NetworkingPluginEvent, encoder: JSONEncoder, decoder: JSONDecoder) {
        #if DEBUG
        let log = logElements
            .compactMap { $0.logValue(service: service, event: event, encoder: encoder, decoder: decoder) }
            .joined(separator: " - ")
        print(log)
        #endif
    }
    
}
