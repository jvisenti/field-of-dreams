//
//  BuildType+API.swift
//  FieldofDreams
//
//  Created by Jay Clark on 11/2/16.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import UIKit

extension BuildType {
    var baseURL: URL {
        let baseURL: URL
        switch self {
        case .debug:
            baseURL = URL(string: "https://FieldofDreams-dev.raizlabs.xyz")!
        case .internal:
            baseURL = URL(string: "https://FieldofDreams-sprint.raizlabs.xyz")!
        case .release:
            fatalError("Specify the release server")
        }
        return baseURL
    }

    func identifier(suffix: String) -> String {
        guard let bundleIdentifier = Bundle(for: APIClient.self).bundleIdentifier else {
            fatalError("Unable to determine bundle identifier")
        }
        return bundleIdentifier.appending(".").appending(suffix)
    }
}

extension BuildType {
    var oathClientToken: String { return "OAUTH_CLIENT_TOKEN_NEEDED" }
    var oathClientID: String { return "OAUTH_CLIENT_ID_NEEDED" }
}
