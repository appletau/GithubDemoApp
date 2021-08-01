//
//  JSONDecoderExtension.swift
//  GitHubDemo
//
//  Created by 黃韋韜 on 2021/7/31.
//

import Foundation

extension JSONDecoder {
  static func snakeCaseDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }
}
