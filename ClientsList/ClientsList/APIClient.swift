//
//  APIClient.swift
//  ClientsList
//
//  Created by Konstantin Khokhlov on 07.07.17.
//  Copyright © 2017 Konstantin Khokhlov. All rights reserved.
//

import Foundation

class APIClient {

    // MARK: - Nested
    enum WebserviceError: Error {
        case dataEmptyError, responseError
    }

    // MARK: - Properties
    lazy var session: SessionProtocol = URLSession.shared

    // MARK: - Methods
    func loginUser(withName username: String, password: String, completion: @escaping (Token?, Error?) -> Void) {

        let allowedCharacters = CharacterSet(charactersIn: "/%&=?$#+-~@<>|\\*,.()[]{}^!").inverted

        guard let encodedUsername = username.addingPercentEncoding(withAllowedCharacters: allowedCharacters) else { return }
        guard let encodedPassword = password.addingPercentEncoding(withAllowedCharacters: allowedCharacters) else { return }

        let query = "username=\(encodedUsername)&password=\(encodedPassword)"
        guard let url = URL(string: "https://clientslist.io/login?\(query)") else { return }

        session.dataTask(with: url) { (data, _, error) in
            guard let data = data else {
                completion(nil, WebserviceError.dataEmptyError)
                return
            }

            guard error == nil else {
                completion(nil, WebserviceError.responseError)
                return
            }

            do {
                let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
                let token: Token?

                if let tokenString = dict?["token"] {
                    token = Token(id: tokenString)
                } else {
                    token = nil
                }
                completion(token, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
}

protocol SessionProtocol {
    func dataTask(
        with url: URL, completionHandler:
        @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: SessionProtocol {}
