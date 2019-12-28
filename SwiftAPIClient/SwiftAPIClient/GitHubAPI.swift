//
//  GitHubAPI.swift
//  SwiftAPIClient
//
//  Created by 前田　和樹 on 2019/12/28.
//  Copyright © 2019 kzk_maeda. All rights reserved.
//

import Foundation

struct GitHubZen {
    let text: String
    
    static func from(response: Response) -> Either<TransformError, GitHubZen> {
        switch response.statusCode {
        case .ok:
            guard let string = String(data: response.payload, encoding: .utf8) else {
                return .left(.malformedData(debugInfo: "not UTF-8 string"))
            }
            return .right(GitHubZen(text: string))
        default:
            return .left(.unexpectedStatusCode(debugInfo: "\(response.statusCode)"))
        }
    }
    
    enum TransformError {
        case unexpectedStatusCode(debugInfo: String)
        case malformedData(debugInfo: String)
    }
}


enum GitHubZenResponse {
    case success(GitHubZen)
    case failuer(GitHubZen.TransformError)
}
