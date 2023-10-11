//
// EnterContractAddress.swift
// HZ24
// 
// Created by jin on 2023-10-06
// 



import SwiftUI

/// Step 1 of adding ``ExistingTokenListener``
/// Here, user provides a contract address
/// Preferred: Validate string based on its length and `0x` prefix and retrieve information about token in the background
/// Required: User performs an action (such as pressing a button) that calls methods to retrieve via RPC calls:
/// 1. Token Symbol
/// 2. Token Name
struct EnterContractAddress: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    // MARK: State
    @State private var contractAddress = ""
    @State private var tokenName = ""
    @State private var tokenSymbol = ""
    @State private var errorMsg = ""

    @State private var showBanner = false
    @State private var showAlert = false
    @State private var showSheet = false
    @State private var goToNextScreen = false
    @State private var showTokenInfo = false

    @State private var tokenInfo: TokenInfo? = nil
    @State private var newListener: ExistingTokenListener?

    /// A method to check if the contract address the user provided is for a token contract.
    ///
    /// If a valid token contract is found, show the sheet to confirm the retrieved token contract details with user.
    ///
    /// If the given contract is not a token contract, show user a warning message.
    private func downloadContractInfo() -> Void {
        let rpc = ThirdWebRPC(chainName: ThirdWebRPC.ThirdWebChainName.zora)
        Task {
            do {
                let tokenInfos = try await rpc.getTokenInfos(contractAddresses: [contractAddress])
                guard let info = tokenInfos.first(where: { tokenInfo in
                    return tokenInfo.contractAddress == contractAddress
                }) else {
                    // FIXME: Remove fatalError and replace by throwing custom Error
                    print("Unable to find TokenInfo")
                    fatalError("")
                }
                tokenInfo = info
                showTokenInfo.toggle()
                
                // FIXME: Should the MO be created here..?
                /// Create new ``Listener`` managed object
                let existingTokenListener = ExistingTokenListener(context: viewContext)
                existingTokenListener.tokenName = info.name
                existingTokenListener.tokenSymbol = info.symbol
                existingTokenListener.createdAt = Date()
                existingTokenListener.contractAddress = contractAddress
                existingTokenListener.displayTitle = info.name
                existingTokenListener.isListening = true
                newListener = existingTokenListener
                showSheet.toggle()
                
            } catch {
                print("Network Error")
                errorMsg = "Network Error"
                showAlert.toggle()
            }
        }
    }
    
    // MARK: - Return body
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: Hidden Navigation
            // In iOS 15, use a hidden NavigationLink to navigate programatically
            /// Hidden NavigationLink
            NavigationLink(destination: SelectEventTypes(newListener: newListener), isActive: $goToNextScreen) {
                EmptyView()
            }
            
            // MARK: Progress bar
            ProgressView(value: 0.33)
            
            Spacer()
            
            // MARK: Form question
            HStack {
                Text("Enter contract address")
                    .font(.largeTitle)
                Spacer()
            }
            .padding(.leading, 20)
            
            // MARK: Form
            Form {
                HStack {
                    TextField("0x", text: $contractAddress)
                        .textFieldStyle(.plain)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    .padding(8)
//                    Spacer()
                    Image(systemName: "qrcode")
                        .overlay {
                            NavigationLink("", destination: Text("QR Scanner"))
                                .opacity(0)
                        }
                }
                
                Button {
                    // Validate input string
                    let isValid = isValidEthereumAddress(contractAddress)
                    if isValid {
                        downloadContractInfo()
                    } else {
                        withAnimation {
                            errorMsg = "Invalid contract address."
                            showBanner.toggle()
                        }
                        // Toggle back after 3 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                showBanner = false
                            }
                        }
                    }
                } label: {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                        .frame(height: 36)
                }
                .buttonStyle(.bordered)
                .padding()
                .alert(errorMsg, isPresented: $showAlert, presenting: "Unable") { details in
                    Text(details)
                    Button {
                        //
                    } label: {
                        Text("OK")
                    }
                }
                
            }
            .frame(maxHeight: 450)
            // End of Form
        }
        // End of Return body
        .sheet(isPresented: $showSheet, content: {
            VStack {
                Text("Confirm Token Info")
                    .font(.subheadline)
                    .padding()
                Text(tokenInfo?.name ?? "")
                    .font(.title)
                Text(tokenInfo?.symbol ?? "")
                    .font(.title2)
                
                Button {
                    showSheet.toggle()
                    goToNextScreen.toggle()
                } label: {
                    Text("Confirm")
                        .frame(maxWidth: .infinity)
                        .frame(height: 36)
                }
                .buttonStyle(.bordered)
                .padding()

            }
            .padding()
        })
        .safeAreaInset(edge: .top, content: {
            if showBanner {
                withAnimation {
                    Text(errorMsg)
                        .padding(.bottom, 8)
                        .frame(maxWidth: .infinity)
                        .background(.orange)
                        .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                        .onTapGesture {
                            withAnimation {
                                showBanner.toggle()
                            }
                        }
                }
            }
            
        })
        .navigationTitle("Listen to an existing token")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func isValidEthereumAddress(_ address: String) -> Bool {
        // Check for empty string
        guard !address.isEmpty else {
            return false
        }
        
        // Check for '0x' prefix
        guard address.hasPrefix("0x") else {
            return false
        }
        let cleanedAddress = address.dropFirst(2)
        
        // Check for valid hexadecimal string
        let isHex = cleanedAddress.range(of: "^[0-9a-fA-F]+$", options: .regularExpression) != nil
        guard isHex else {
            return false
        }
        
        // Check for correct length (42 characters)
        let isCorrectLength = address.count == 42
        return isCorrectLength
    }
}

struct EnterContractAddress_Previews: PreviewProvider {
    static let coreDataProvider = CoreDataProvider.preview
    static var previews: some View {
        EnterContractAddress()
            .environment(\.managedObjectContext, coreDataProvider.container.viewContext)
        

        NavigationView {
            EnterContractAddress()
                .environment(\.managedObjectContext, coreDataProvider.container.viewContext)
        }
    }
}
