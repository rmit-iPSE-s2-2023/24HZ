//
// CameraDelegate.swift
// HZ24
// 
// Created by jin on 2023-10-14
// 



import Foundation
import AVFoundation

/// This class represents the delegate used to handle MetadataOutputs of an `AVCaptureSession`.
class CameraDelegate: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    
    /// Time between scans in seconds.
    var scanInterval: Double = 1.0
    /// The last time a code was scanned.
    ///
    /// This should be updated everytime a barcode (QR code) is scanned.
    var lastTime = Date(timeIntervalSince1970: 0)
    
    /// A method to be specified by the delegating object.
    var onResult: (String) -> Void = { _  in }
    
    var mockData: String?
    
    /// handle the metadata output from the Camera
    ///
    /// This is the optional method of the `AVCaptureMetadataOutputObjectsDelegate` protocol
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // If there is metadata output, update result.
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            foundBarcode(stringValue)
        }
    }
    
    /// Simulating a scan for use in Previews.
    @objc func onSimulateScanning(){
        foundBarcode(mockData ?? "Simulated QR-code result.")
    }
    
    /// Method to be called when a barcode is found.
    func foundBarcode(_ stringValue: String) {
        let now = Date()
        if now.timeIntervalSince(lastTime) >= scanInterval {
            lastTime = now
            self.onResult(stringValue)
        }
    }
}

