//
//  SavedTab.swift
//  a1-s3713342
//
//  Created by Min on 22/8/23.
//

import SwiftUI
import AVKit

/// Represents the view for the 'Saved' tab in the app.
/// This tab shows saved events, tutorial pages, and a tutorial video.
struct SavedTab: View {
    
    // Sample data for the saved events.
    // TODO: Replace with real saved events data later.
    let savedEvents = getEventData() ?? []
    
    /// Represents the currently selected event for detailed viewing.
    @State private var selectedEvent: EventData?
    
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
                
                // Display tutorial pages for the user.
                PageView(pages: tutorials.map { Tutorials(tutorial: $0) })
                    .aspectRatio(3 / 2, contentMode: .fit)
                
                // Display a tutorial video if available.
                if let videoURL = Bundle.main.url(forResource: "sample-video", withExtension: "mp4") {
                    VideoPlayerView(videoURL: videoURL)
                        .frame(width: 330, height: 200)
                } else {
                    Text("Tutorial - Video not found")
                        .foregroundColor(.white)
                        .frame(width: 330, height: 200)
                        .background(Color.gray.opacity(0.5))
                }
                
                // Display the list of saved events.
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Your Saved Events")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        ForEach(savedEvents, id: \.id) { event in
                            CapturedEventBlock(eventData: event)
                                .onTapGesture {
                                    self.selectedEvent = event
                                }
                                .background(Color.orange)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                    }
                }
                // Displays the details of a selected event.
                .sheet(item: $selectedEvent) { event in
                    EventDetailView(event: event)
                }
                
                Spacer()
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

/// Represents a view for playing a video using `AVPlayerViewController` within SwiftUI.
struct VideoPlayerView: UIViewControllerRepresentable {
    let videoURL: URL
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let player = AVPlayer(url: videoURL)
        let controller = AVPlayerViewController()
        controller.player = player
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) { }
}

struct SavedTab_Previews: PreviewProvider {
    static var previews: some View {
        SavedTab()
    }
}


