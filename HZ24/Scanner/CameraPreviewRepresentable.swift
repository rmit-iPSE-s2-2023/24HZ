//
// CameraPreviewRepresentable.swift
// HZ24
// 
// Created by jin on 2023-10-14
// 



import Foundation
//import UIKit
import AVFoundation
import SwiftUI

/// A wrapper to integrate the ``CameraPreview`` UIView with SwiftUI.
struct CameraPreviewRepresentable: UIViewRepresentable {
    typealias UIViewType = CameraPreview
    
    private let session = AVCaptureSession()
    private let delegate = CameraDelegate()
    private let metadataOutput = AVCaptureMetadataOutput()
    
    // MARK: View modifiers
    /// Method to inject custom behaviour for delegate.
    func found(r: @escaping (String) -> Void) -> CameraPreviewRepresentable {
        delegate.onResult = r
        return self
    }
    
    /// Method to inject scan interval for delegate.
    func interval(delay: Double) -> CameraPreviewRepresentable {
        delegate.scanInterval = delay
        return self
    }
    
    /// Method to inject mock data for delegate.
    func simulator(mockData: String)-> CameraPreviewRepresentable{
        delegate.mockData = mockData
        return self
    }
    
    /// Set up the `AVCaptureSession` for the `UIView`.
    func setupCamera(_ uiView: CameraPreview) {
        // Try to configure the input/output for the AVCaptureSession
        if let backCamera = AVCaptureDevice.default(for: AVMediaType.video),
           let input = try? AVCaptureDeviceInput(device: backCamera) {
            session.sessionPreset = .photo
            
            // Add the back camera as input
            if session.canAddInput(input) {
                session.addInput(input)
            }
            // Add the metadata output as output
            if session.canAddOutput(metadataOutput) {
                session.addOutput(metadataOutput)
                
                // Configure the metadata output to scan for QR codes.
                metadataOutput.metadataObjectTypes = [.qr]
                // Configure the delegate and dispatch queue for metadata output.
                metadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
            }
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)

            // Configure the UIView
            uiView.backgroundColor = UIColor.gray
            previewLayer.videoGravity = .resizeAspectFill
            uiView.layer.addSublayer(previewLayer)
            uiView.previewLayer = previewLayer
            
            // Start the AVCaptureSession
            session.startRunning()
        }
        
    }
    
    /// Method to check for the user's camera authorization status and if allowed, set up the `AVCaptureSession`.
    private func checkCameraAuthorizationStatus(_ uiView: CameraPreview) {
        /// Get the camera authorization status.
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        // If it's authorized, set up the camera. IF not, request access then set up the camera once authorized.
        if cameraAuthorizationStatus == .authorized {
            setupCamera(uiView)
        } else {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.sync {
                    if granted {
                        self.setupCamera(uiView)
                    }
                }
            }
        }
    }
    
    // MARK: Protocol method implementations
    func makeUIView(context: UIViewRepresentableContext<CameraPreviewRepresentable>) -> CameraPreviewRepresentable.UIViewType {
        let cameraView = CameraPreview(session: session)
        /// If view is created in simulator environment, create fallback view.
        #if targetEnvironment(simulator)
        cameraView.createSimulatorView(delegate: self.delegate)
        #else
        /// If view is created on a real device, check for camera authorization status.
        checkCameraAuthorizationStatus(cameraView)
        #endif
        return cameraView
    }
    
    func updateUIView(_ uiView: CameraPreview, context: UIViewRepresentableContext<CameraPreviewRepresentable>) {
    }
    
    static func dismantleUIView(_ uiView: CameraPreview, coordinator: ()) {
        /// Termiante the `AVCaptureSession` when view disappears to avoid memory leaks.
        uiView.session.stopRunning()
    }
    
}
