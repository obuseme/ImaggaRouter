/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation
import Alamofire

public enum ImaggaRouter: URLRequestConvertible {
    static let baseURLPath = "http://api.imagga.com/v1"
    static let authenticationToken = "Basic YWNjX2YxYzg3NTE4YThiOGE2Yzo4YTllYTg0YmZiZTQxNDI1YjU0Njk5ZTM3OTA3YmNmYQ=="

    case content
    case tags(String)
    case colors(String)

    var method: HTTPMethod {
        switch self {
        case .content:
            return .post
        case .tags, .colors:
            return .get
        }
    }

    var path: String {
        switch self {
        case .content:
            return "/content"
        case .tags:
            return "/tagging"
        case .colors:
            return "/colors"
        }
    }

    public func asURLRequest() throws -> URLRequest {
        let parameters: [String: Any] = {
            switch self {
            case .tags(let contentID):
                return ["content": contentID]
            case .colors(let contentID):
                return ["content": contentID, "extract_object_colors": 0]
            default:
                return [:]
            }
        }()

        let url = try ImaggaRouter.baseURLPath.asURL()

        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.setValue(ImaggaRouter.authenticationToken, forHTTPHeaderField: "Authorization")
        request.timeoutInterval = TimeInterval(10 * 1000)
        
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
