//
// Scanner.swift
// HZ24
// 
// Created by jin on 2023-10-14
// 



import Foundation

/// An `ObservableObject` that publishes the value of a QR code found by an `AVCaptureSession`.
class Scanner: ObservableObject {
    
    /// The rate at which the scanner should check for a QR code.
    let scanInterval: Double = 1.0
    
    /// A property that represents the last QR code found by an `AVCaptureSession`
    @Published var lastQrCode: String = ""
    
    /// A method that performs an action when a qr code is found.
    func onQrCodeFound(_ code: String) -> Void {
        self.lastQrCode = code
        // FIXME: Debugging
        print(lastQrCode)
    }
}
