//
// ScannerView.swift
// HZ24
// 
// Created by jin on 2023-10-14
// 



import SwiftUI

/// A view that allows user to scan for a QR code.
///
/// This view should be used used as a modal view. If a valid contract address is found, this view should dismiss itself. If the user has scanned an invalid address, it should display an error message to try again.
struct ScannerView: View {
    
    @Environment(\.dismiss) var dismiss
    
    /// The object to update passed down from the parent view.
    @ObservedObject var scanner: Scanner
    
    @State private var showAlert = false
    
    // MARK: Return body
    var body: some View {
        ZStack {
            
            // MARK: Background
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            // MARK: Camera preview
            CameraPreviewRepresentable()
                .found(r: self.scanner.onQrCodeFound)
                .interval(delay: self.scanner.scanInterval)
            
            // MARK: Overlay
            VStack {
                VStack {
                    Text("Scan QR Code")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .overlay(alignment: .trailing) {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "xmark")
                            }
                        }
                }
                .padding(16)
                .background(.black)
                
                Spacer()
                
                Rectangle()
                    .frame(height: 60)
                    .foregroundColor(.black)
            }
            // End of VStack (overlay)
        }
        .onChange(of: scanner.lastQrCode, perform: { newValue in
            if isValidEthereumAddress(newValue) {
                dismiss()
            } else {
                showAlert.toggle()
            }
        })
        .alert("We couldn't detect a contract address. Please try again", isPresented: $showAlert, presenting: "hello") { details in
            Button {
                //
            } label: {
                Text("OK")
            }
        }
        // End of ZStack (parent)

    }
}

// MARK: - Previews
struct ScannerView_Previews: PreviewProvider {
    static let scanner = Scanner()
    static var previews: some View {
        ScannerView(scanner: scanner)
    }
}
