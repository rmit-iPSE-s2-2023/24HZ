//
//  EventDetailView.swift
//  a1-s3713342
//
//  Created by Jin on 2023-08-26.
//

import SwiftUI

struct EventDetailView: View {
    
    var event: EventData
    
    @Environment(\.dismiss) var dismiss
    let overlayHeight: CGFloat = 60

    var body: some View {
            
            ZStack {
                
                // MARK: - Background
                LinearGradient(colors: [.orange, Color("gradientTrailingBrown")], startPoint: .top, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)

                // MARK: - Event Details
                VStack {
                    
                    /// Heading: Event type name
                    HStack {
                        Text("\(event.eventType.name)")
                            .foregroundStyle(.black)
                            .font(.largeTitle.bold())
                            .padding(20)
                        
                        Spacer()
                    }
                    
                    /// Section showing Smart Contract details
                    Section {
                        VStack {
                            HStack {
                                Text("Name")
                                Spacer()
                                Text("\(event.smartContract.tokenName)")
                            }
                            HStack {
                                Text("Address")
                                Spacer()
                                Text("\(event.smartContract.address)")
                            }
                        }
                        .padding(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.black, lineWidth: 2)
                        }
                    } header: {
                        HStack {
                            Text("Smart Contract")
                                .font(.callout.bold())
                            Spacer()
                        }
                    }
                    
                    /// Section showing Event details
                    Section {
                        VStack {
                            HStack {
                                Text("Name")
                                Spacer()
                                Text("\(event.eventType.name)")
                            }
                            HStack {
                                Text("Description")
                                Spacer()
                                Text("\(event.eventType.description)")
                            }
                            HStack {
                                Text("Timestamp")
                                Spacer()
                                Text("\(timeIntervalToHourmarkLabel(timeInterval: event.eventTimestamp))")
                            }
                            HStack {
                                Text("Block Number")
                                Spacer()
                                Text("\(event.eventLog.blockNumber)")
                            }
                            HStack {
                                Text("Tx Hash")
                                Spacer()
                                Text("\(event.eventLog.txHash)")
                            }
                        }
                        .padding(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.black, lineWidth: 2)
                        }
                    } header: {
                        HStack {
                            Text("Event")
                                .font(.callout.bold())
                            Spacer()
                        }
                    }
                    
                    Spacer()

                    Button {
                        // TODO: - Adding event saving functionality.
                    } label: {
                        Text("Save")
                            .font(.title2)
                            .foregroundStyle(.gray)
                            .frame(width: 200, height: 50)
                            .background(.black)
                            .cornerRadius(10)
                            .overlay {
                                HStack {
                                    Spacer()
                                    Image(systemName: "bookmark.circle")
                                        .font(.title)
                                        .foregroundStyle(.gray)
                                        .padding(10)
                                }
                            }
                    }

                    
                }
                .padding(.top, overlayHeight)
                .padding([.bottom, .horizontal], 30)

            }
            .overlay(
                /// Button overlay to dismiss presentation
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.largeTitle)
                                .foregroundStyle(.black)
                        }
                        .padding(.trailing, 15)
                        .padding(.top, 8)
                        
                    }
                    .frame(height: overlayHeight)

                    Spacer()
                }
            )

    }
}

struct EventDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let event = getRandomDummyEventData()
        EventDetailView(event: event)
    }
}


