//
// CameraPreview.swift
// HZ24
// 
// Created by jin on 2023-10-14
// 



import Foundation
import UIKit
import AVFoundation

/// A view that shows the camera input or a fallback view.
///
/// A fallback view allows this view to be used in Xcode previews.
class CameraPreview: UIView {
    
    var session = AVCaptureSession()
    
    /// A fallback view  to be used in Xcode previews/simulator.
    private var label: UILabel?
    /// The camera preview layer when running on real device.
    var previewLayer: AVCaptureVideoPreviewLayer?
    /// A weak reference to the ``CameraDelegate`` to avoid memory leaks.
    weak var delegate: CameraDelegate?
    
    // MARK: Initializer
    init(session: AVCaptureSession) {
        // Initialize the View frame with 0 dimensions
        super.init(frame: .zero)
        self.session = session
    }
    
    // UIView requirement
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// A method to create a simulator view for use in Xcode previews.
    func createSimulatorView(delegate: CameraDelegate){
        self.delegate = delegate
        self.backgroundColor = UIColor.systemBackground
        label = UILabel(frame: self.bounds)
//        label?.numberOfLines = 4
        label?.text = "Click here to simulate scan"
        label?.textColor = UIColor.red
        label?.textAlignment = .center
        if let label = label {
            addSubview(label)
        }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onClick))
        self.addGestureRecognizer(gesture)
    }
    
    @objc func onClick(){
        delegate?.onSimulateScanning()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        #if targetEnvironment(simulator)
            label?.frame = self.bounds
        #else
            previewLayer?.frame = self.bounds
        #endif
    }

}
