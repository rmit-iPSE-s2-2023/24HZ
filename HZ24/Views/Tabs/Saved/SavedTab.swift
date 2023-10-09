//
//  SavedTab.swift
//  a1-s3713342
//
//  Created by Min on 22/8/23.
//

import SwiftUI

struct SavedTab: View {
    // Fetch saved events from Core Data
    @FetchRequest(entity: Event.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Event.timestamp, ascending: false)],
                  predicate: NSPredicate(format: "saved == %@", NSNumber(value: true)))
    private var savedEvents: FetchedResults<Event>
    
    @State private var selectedEvent: Event?
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                HStack {
                    Text("Your saved events will show up on this page")
                        .multilineTextAlignment(.leading)
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .padding(.leading, 10)
                    Spacer()
                }

                // Display the list of saved events.
                ScrollView {
                    VStack(alignment: .leading) {
                        
                        ForEach(savedEvents, id: \.id) { event in
                            EventRowItem(event: event)
                                .onTapGesture {
                                    self.selectedEvent = event
                                }
                                .background(Color.orange)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                    }
                }
                .sheet(item: $selectedEvent) { event in
                    EventDetailViewWithCoreData(event: event)
                }
                
                Spacer()
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

struct SavedTab_Previews: PreviewProvider {
    static var previews: some View {
        SavedTab()
    }
}


