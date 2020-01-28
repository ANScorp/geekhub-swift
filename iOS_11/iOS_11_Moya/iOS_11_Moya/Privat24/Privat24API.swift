//
//  Privat24API.swift
//  iOS_11_Moya
//
//  Created by Alex on 1/27/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import Moya

enum Privat24API {
    case pubinfo(coursid: Int)
    case pboffice(city: String)
}

extension Privat24API: TargetType {
    var baseURL: URL {
        URL(string: "https://api.privatbank.ua/p24api/")!
    }

    var path: String {
        switch self {
        case .pubinfo:
            return "pubinfo"
        case .pboffice:
            return "pboffice"
        }
    }

    var method: Method {
        .get
    }

    var sampleData: Data {
        Data()
    }

    var task: Task {
        switch self {
        case let .pubinfo(ccoursid):
            return .requestParameters(
                parameters: ["exchange": "", "json": "", "coursid": ccoursid],
                encoding: URLEncoding.queryString
            )
        case let .pboffice(city):
            return .requestParameters(
                parameters: ["json": "", "city": city],
                encoding: URLEncoding.default
            )
        }
    }

    var headers: [String: String]? {
        ["": ""]
    }
}
