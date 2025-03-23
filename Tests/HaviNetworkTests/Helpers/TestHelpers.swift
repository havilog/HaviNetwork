//
//  TestHelpers.swift
//  HaviNetworkTests
//
//  Created by 한상진 on 12/18/24.
//

import Foundation

extension Data {
    var asString: String {
        String(decoding: self, as: UTF8.self)
    }

    func asJSONObject() throws -> Any {
        try JSONSerialization.jsonObject(with: self, options: .allowFragments)
    }
}
