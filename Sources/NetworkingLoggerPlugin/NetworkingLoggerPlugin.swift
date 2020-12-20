//
//  NetworkingLoggerPlugin.swift
//
//
//  Created by Piotr Prokopowicz on 20/12/2020.
//

import Foundation
import Networking

/// Plugin that logs information about  service requests being made.
public struct NetworkingLoggerPlugin: NetworkingPlugin {
    
    /// Enum that gives `NetworkingLoggerPlugin` information on what user wants to log.
    public enum Element {
        /// Responsible for logging date of an event. Example "2020-10-02 17:44:37 +0000".
        case date
        /// Responsible for logging name of this library. Can be used to filter logs in the console.
        case libraryName
        /// Emoji character used distinguish failure from success.
        case emoji
        /// HTTP status code of a given request. Only logged for `NetworkingPluginEvent.responseError` and `NetworkingPluginEvent.success`.
        case statusCode
        /// HTTP method used for a given service.
        case httpMethod
        /// URL created from a given service.
        case url
        /// Headers used for the request. Only logged for `NetworkingPluginEvent.dataRequested`.
        case headers
        /// Data associated with a request. For `NetworkingPluginEvent.dataRequested` this is the body of the request. For `NetworkingPluginEvent.responseError` and `NetworkingPluginEvent.success` it's the data that was returned from request. For `NetworkingPluginEvent.unableToParseRequest` this is not logged.
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
    
    /// Initializes the plugin with information on what the user wants to log to console.
    ///
    /// - Parameter elements: Array of `Element` enum. Based on values in this array information is being logged. Order and duplication of values does matter.
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
