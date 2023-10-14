//
// Validation.swift
// HZ24
// 
// Created by jin on 2023-10-14
// 

import Foundation

func isValidEthereumAddress(_ address: String) -> Bool {
    // Check for empty string
    guard !address.isEmpty else {
        return false
    }
    
    // Check for '0x' in string and grab the 0x part. e.g. for "ethereum:0xef53ec517fa2dF33F2bee7c6E5084C56c28C3B09", the resulting String should not include "ethereum:"
    guard let range = address.range(of: "0x") else {
        return false
    }
    let substring = address[range.lowerBound...]
        
    // Check for valid hexadecimal string
    let cleanedAddress = substring.dropFirst(2)
    let isHex = cleanedAddress.range(of: "^[0-9a-fA-F]+$", options: .regularExpression) != nil
    guard isHex else {
        return false
    }
    
    // Check for correct length (42 characters)
    let isCorrectLength = substring.count == 42
    return isCorrectLength
}

enum ValidationError : Error {
    case not0xString
}

func cleanEthAddress(_ address: String) throws -> String {
    guard let range = address.range(of: "0x") else {
        throw ValidationError.not0xString
    }
    return String(address[range.lowerBound...])
}
