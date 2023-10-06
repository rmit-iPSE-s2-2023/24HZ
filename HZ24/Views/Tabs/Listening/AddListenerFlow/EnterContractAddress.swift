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
    @State private var contractAddress = "0x6d2C45390B2A0c24d278825c5900A1B1580f9722"   // FIXME: Debugging
    @State private var showBanner = false
    @State private var errorMsg = ""
    @State private var showAlert = false
    @State private var showSheet = false
    @State private var goToNextScreen = false
    @State private var showTokenInfo = false
    
    @State private var tokenName = ""
    @State private var tokenSymbol = ""
    
    @State private var tokenInfo: TokenInfo? = nil
    @State private var newListener: ExistingTokenListener?

    var body: some View {
        VStack {
            /// In iOS 15, use a hidden NavigationLink to navigate programatically
            /// Hidden NavigationLink
            NavigationLink(destination: SelectEventTypes(newListener: newListener), isActive: $goToNextScreen) {
                EmptyView()
            }
            ProgressView(value: 0.33)
            Spacer()
            Text("Enter contract address")
                .font(.largeTitle)
            Form {
                TextField("0x", text: $contractAddress)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.plain)
                    .padding(8)

                Button {
                    // Validate input string
                    // FIXME: Debugging
//                    let isValid = isValidEthereumAddress(contractAddress)
                    
                    let isValid = isValidEthereumAddress(contractAddress)
                    if isValid {
                        // Download contract info
                        // FIXME: Use dependency injection and insert RPC provider into context in App entrypoint
                        let rpc = ThirdWebRPC(chainName: "zora")
                        Task {
                            do {
                                let tokenInfos = try await rpc.getTokenInfos(contractAddresses: [contractAddress])
                                guard let info = tokenInfos[contractAddress] else {
                                    // FIXME:
                                    print("Unable to find TokenInfo")
                                    fatalError("")
                                }
                                tokenInfo = info
                                showTokenInfo.toggle()
                                
                                /// Create new MO
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
                    Text("Confirm")
                }
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
        }
        .sheet(isPresented: $showSheet, content: {
            VStack {
                Text("Confirm Token Info")
                    .font(.largeTitle.bold())
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
                }
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
        .preferredColorScheme(.dark)


//        .overlay(
//                    VStack {
//                        if showAlert {
//                            VStack {
//                                HStack(alignment: .firstTextBaseline) {
//                                    Image(systemName: "exclamationmark.triangle.fill")
//                                    VStack(alignment: .leading) {
//                                        Text(model?.title ?? "")
//                                            .font(.headline)
//                                        if let message = model?.message {
//                                            Text(message)
//                                                .font(.footnote)
//                                        }
//                                    }
//                                }
//                                .padding()
//                                .frame(minWidth: 0, maxWidth: .infinity)
//                                .foregroundColor(.white)
//                                .background(Color.red)
//                                .cornerRadius(10)
//                                .shadow(radius: 10)
//                                Spacer()
//                            }
//                            .padding()
//                            .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
//                            .onTapGesture {
//                                withAnimation {
//                                    model = nil
//                                }
//                            }
//                            .gesture(
//                                DragGesture()
//                                    .onChanged { _ in
//                                        withAnimation {
//                                            model = nil
//                                        }
//                                    }
//                            )
//                        }
//                    }
//                    .animation(.easeInOut)         // << here !!
//                )
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
