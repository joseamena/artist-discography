//
//  ReleaseDetailView.swift
//  dt-discography
//
//  Created by Jose A. Mena on 3/28/24.
//

import SwiftUI

struct ReleaseDetailView: View {
    
    @StateObject private var viewModel = ReleaseDetailViewModel(client: DTDiscographyClient())
    
    let release: Release
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                title
                image
                    .padding(.bottom)
                maybeTrackListing
                    .padding(.bottom)
                maybeRating
                Spacer()
            }
        }
        .padding(.horizontal)
        .task {
            await viewModel.fetchReleaseDetails(uri: release.resourceUrl)
        }
    }
    
    private var image: some View {
        AsyncImage(
            url: viewModel.imageUrl,
            content: { image in
                image
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 12)
                    )
            },
            placeholder: {}
        )
    }
    
    private var title: some View {
        HStack {
            Text(viewModel.title).font(.title2).bold()
            Spacer()
        }
    }
    
    @ViewBuilder
    private var maybeTrackListing: some View {
        if !viewModel.trackListing.isEmpty {
            VStack {
                HStack {
                    Text("Track Listing").font(.title2).bold()
                    Spacer()
                }
                .background(
                    LinearGradient.accent
                        .opacity(0.6)
                )
                
                ForEach(viewModel.trackListing, id: \.title) { track in
                    HStack {
                        Text("\(track.title)")
                        Spacer()
                        Text(track.duration)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var maybeRating: some View {
        if let rating = viewModel.rating {
            HStack {
                Text("Rating:")
                RatingView(rating: rating)
                Spacer()
            }
        }
    }
}

#Preview {
    ReleaseDetailView(
        release: Release(
            id: 0,
            mainRelease: 0,
            format: "12\", Maxi",
            title: "Title",
            label: "Capitol",
            resourceUrl: "https://api.discogs.com/releases/3930221",
            year: 1500,
            thumb: "https://i.discogs.com/otrB6zRwRDNhznIkjQ5_DwLO3dNjNvWxdbYV4g6tXTs/rs:fit/g:sm/q:40/h:150/w:150/czM6Ly9kaXNjb2dz/LWRhdGFiYXNlLWlt/YWdlcy9SLTkwNDc1/NjEtMTQ3Mzg1NzUz/NS01Mzc0LmpwZWc.jpeg"
        )
    )
}
