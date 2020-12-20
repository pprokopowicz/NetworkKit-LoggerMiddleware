//
//  NetworkingLoggerPlugin+EventLogValue.swift
//  
//
//  Created by Piotr Prokopowicz on 20/12/2020.
//

import Foundation
import Networking

extension NetworkingLoggerPlugin.Element {
    
    private enum Constants {
        static let libraryName: String = "Networking"
        static let successEmoji: String = "🟢"
        static let failureEmoji: String = "🔴"
    }
    
    func dataRequestedLogValue<Service: NetworkingService>(service: Service, event: NetworkingPluginEvent, encoder: JSONEncoder) -> String? {
        switch self {
        case .date:
            return "\(Date())"
        case .libraryName:
            return Constants.libraryName
        case .emoji:
            return Constants.successEmoji
        case .statusCode:
            return nil
        case .httpMethod:
            return Service.method.rawValue
        case .url:
            return service.url
        case .headers:
            return "\n\(Service.headers ?? [:])"
        case .data:
            guard Service.method != .get else { return nil }
            return "\n\(dataLog(data: try? service.input?.data(encoder: encoder)))"
        }
    }
    
    func unableToParseRequestLogValue<Service: NetworkingService>(service: Service, event: NetworkingPluginEvent) -> String? {
        switch self {
        case .date:
            return "\(Date())"
        case .libraryName:
            return Constants.libraryName
        case .emoji:
            return Constants.failureEmoji
        case .statusCode:
            return ""
        case .httpMethod:
            return Service.method.rawValue
        case .url:
            return service.url
        case .headers:
            return "\n\(Service.headers ?? [:])"
        case .data:
            return nil
        }
    }
    
    func responseErrorLogValue<Service: NetworkingService>(service: Service, event: NetworkingPluginEvent, data: Data, status: NetworkingStatus) -> String? {
        switch self {
        case .date:
            return "\(Date())"
        case .libraryName:
            return Constants.libraryName
        case .emoji:
            return Constants.failureEmoji
        case .statusCode:
            return "\(status.rawValue)"
        case .httpMethod:
            return Service.method.rawValue
        case .url:
            return service.url
        case .headers:
            return nil
        case .data:
            return "\n\(dataLog(data: data))"
        }
    }
    
    func successLogValue<Service: NetworkingService>(service: Service, event: NetworkingPluginEvent, data: Data, status: NetworkingStatus) -> String? {
        switch self {
        case .date:
            return "\(Date())"
        case .libraryName:
            return Constants.libraryName
        case .emoji:
            return Constants.successEmoji
        case .statusCode:
            return "\(status.rawValue)"
        case .httpMethod:
            return Service.method.rawValue
        case .url:
            return service.url
        case .headers:
            return nil
        case .data:
            return "\n\(dataLog(data: data))"
        }
    }
    
    private func dataLog(data: Data?) -> String {
        guard let data = data else { return .emptyJSON }
        return String(data: data, encoding: .utf8) ?? .emptyJSON
    }
    
}

fileprivate extension Encodable {
    
    func data(encoder: JSONEncoder) throws -> Data {
        try encoder.encode(self)
    }
    
}

fileprivate extension String {
    
    static var emptyJSON: String { "{}" }
    
}
