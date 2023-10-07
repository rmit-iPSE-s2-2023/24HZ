//
//  EventDetailView.swift
//  a1-s3713342
//
//  Created by Jin on 2023-08-26.
//

import SwiftUI

struct EventDetailViewWithCoreData: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var event: Event
    
    @Environment(\.dismiss) var dismiss
    
    private func title() -> String {
        if let _ = event as? NewTokenEvent {
            return "New Token"
        } else if let event = event as? MetadataEvent {
            return event.abiEventName ?? "Metadata Update"
        } else if let event = event as? MintCommentEvent {
            return event.abiEventName ?? "Mint w/ Comment"
        } else {
            return event.entity.name ?? "Event"
        }
    }
    
    private func timestamp() -> String {
        if let date = event.timestamp {
            return dateToHourmarkLabel(date: date)
        } else {
            return "Unknown"
        }
    }
    
    private func saveEvent() -> Void {
        /// Save event
        event.saved = true
        dismiss()
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    
    // MARK: - Return body
    var body: some View {
        
        // MARK: Event Details
        NavigationView {
            VStack {
                
                /// Heading: title
                HStack {
                    Text(title())
                        .font(.largeTitle.bold())
    //                    .padding(8)
                    
                    Spacer()
                }
                
                HStack {
                    /// Symbol
                    if let symbol = event.tokenSymbol {
                        Text(symbol)
                            .opacity(0.5)
                    }
                    Spacer()
                    
                    /// Timestamp

                    Text("Captured at")
                        .font(.subheadline)
                    Text(timestamp())
                        .font(.subheadline)
                }

                
                // MARK: Event-specific info
                /// Event specific information
                VStack {
                    
                    /// for ``NewTokenEvent``
                    if let event = event as? NewTokenEvent {
                        /// Contract deployer's address
                        // TODO: Also display ENS, if available
                        HStack {
                            Text("Deployer")
                            Spacer()
                            Text(event.deployerAddress ?? "Unknown")
                        }
                    }
                    
                    /// for ``metadataEvent``
                    if let event = event as? MetadataEvent {
                        /// ABI event name
                        HStack {
                            Text("Event type")
                            Spacer()
                            Text(event.abiEventName ?? "Unknown")
                        }
                        /// Updated Animation
                        if let update = event.updatedAnimationURI {
                            HStack {
                                Text("Updated Animation URI")
                                Spacer()
                                Text(update)
                            }
                        }
                        /// Updated Contract URI
                        if let update = event.updatedContractURI {
                            HStack {
                                Text("Updated Contract URI")
                                Spacer()
                                Text(update)
                            }
                        }
                        /// Updated Freeze At
                        if let update = event.updatedContractURI {
                            HStack {
                                Text("Updated Freeze At")
                                Spacer()
                                Text(update)
                            }
                        }
                        /// Updated Image URI
                        if let update = event.updatedImageURI {
                            HStack {
                                Text("Updated Image URI")
                                Spacer()
                                Text(update)
                            }
                        }
                        /// Updated Metadata Base
                        if let update = event.updatedImageURI {
                            HStack {
                                Text("Updated Metadata Base")
                                Spacer()
                                Text(update)
                            }
                        }
                        /// Updated Metadata Base
                        if let update = event.updatedMetadataBase {
                            HStack {
                                Text("Updated Metadata Base")
                                Spacer()
                                Text(update)
                            }
                        }
                        /// Updated Metadata Extension
                        if let update = event.updatedMetadataExtension {
                            HStack {
                                Text("Updated Metadata Extension")
                                Spacer()
                                Text(update)
                            }
                        }
                        /// Updated Name
                        if let update = event.updatedName {
                            HStack {
                                Text("Updated Name")
                                Spacer()
                                Text(update)
                            }
                        }
                        /// Updated Description
                        if let update = event.updatedNewDescription {
                            HStack {
                                Text("Updated Description")
                                Spacer()
                                Text(update)
                            }
                        }
                    }
                    
                }
                .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.black, lineWidth: 2)
                }

                
                // MARK: On-chain info
                /// Section showing technical blockchain info
                // TODO: This section should be expandable to abstract away technical information for more friendly experience
                Section {
                    VStack {
                        /// Block hash
                        if let value = event.blockHash {
                            HStack {
                                Text("Block Hash")
                                Spacer()
                                Text(value)
                            }
                        }
                        /// Block number
                        HStack {
                            Text("Block Number")
                            Spacer()
                            Text(String(event.blockNumber))
                        }

                        /// Contract address
                        if let value = event.contractAddress {
                            HStack {
                                Text("Contract Address")
                                Spacer()
                                Text(value)
                            }
                        }
                        /// ``ERCInterfaceId``
                        if let value = event.ercInterfaceId {
                            HStack {
                                Text("ERC Interface")
                                Spacer()
                                Text(value)
                            }
                        }
                        /// times
                        if let value = event.transactionHash {
                            HStack {
                                Text("Transaction Hash")
                                Spacer()
                                Text(value)
                            }
                        }
                    }
                    .padding(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.black, lineWidth: 2)
                    }
                } header: {
                    HStack {
                        Text("Additional info")
                            .font(.callout.bold())
                        Spacer()
                    }
                }
                
                Spacer()

                // MARK: Save button
                Button(action: saveEvent) {
                    Label("Save", systemImage: "bookmark")
                }
                .buttonStyle(.bordered)
                
                
            }
            .padding()
            // TODO: Customize background?
//            .background(Color("brownBackground"))
//            .background(LinearGradient(colors: [.orange, Color("gradientTrailingBrown")], startPoint: .top, endPoint: .bottomTrailing))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.black)
                    }
                }
            }
            .navigationTitle("Event Details")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
        }

        
    }
}

struct EventDetailViewWithCoreData_Previews: PreviewProvider {
    static let coredataProvider = CoreDataProvider.preview
    //    static let event = NewTokenEvent(context: coredataProvider.container.viewContext)
    static let newTokenEvent = PreviewModels.newTokenEvent
    static let metadataEvent = PreviewModels.metadataEvent

    static var previews: some View {
        
        NavigationView {
            Text("Parent View")
                .sheet(item: .constant(newTokenEvent)) { event in
                    EventDetailViewWithCoreData(event: event)
                    
                }
                .preferredColorScheme(.dark)
        }
        .environment(\.managedObjectContext, coredataProvider.container.viewContext)
        .previewDisplayName("NewTokenEvent")
        
        Text("Parent View")
            .sheet(item: .constant(metadataEvent)) { event in
                EventDetailViewWithCoreData(event: event)
                
            }
            .preferredColorScheme(.dark)
            .previewDisplayName("MetadataEvent")
        
    }
}


