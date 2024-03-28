//
//  ArtistView.swift
//  dt-discography
//
//  Created by Jose A. Mena on 3/27/24.
//

import Kingfisher
import SwiftUI

struct ArtistView: View {
    
    @StateObject private var viewModel = ArtistViewModel(client: DTDiscographyClient())
    @State private var showDiscography = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                artistImage
                mainContent
                Spacer()
            }
            .ignoresSafeArea()
            .navigationTitle(viewModel.artistName)
            .navigationBarHidden(true)
            .navigationDestination(
                isPresented: $showDiscography,
                destination: { DiscographyView() }
            )
        }
        .task(priority: .background) {
            await viewModel.fetchArtist()
        }
    }
    
    private var mainContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                summary
                viewDiscographyButton.padding(.bottom)
                links
            }
        }
        .padding()
    }
    
    private var viewDiscographyButton: some View {
        Button(action: { showDiscography = true }) {
            HStack {
                Text("Discography")
                Image(systemName: "chevron.right")
            }
        }
        .buttonStyle(PrimaryButton())
    }

    private var artistImage: some View {
        ZStack(alignment: .bottomLeading) {
            KFImage(viewModel.primaryImageUrl)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .mask(
                    LinearGradient(
                        gradient: Gradient(
                            stops: [
                                .init(color: .black, location: 0),
                                .init(color: .clear, location: 1)
                            ]
                        ),
                        startPoint: .top, endPoint: .bottom
                    )
                )
            Text(viewModel.artistName)
                .font(.title)
                .bold()
                .padding(.leading)
        }
    }
    
    private var summary: some View {
        VStack (alignment: .leading) {
            Text(viewModel.profile).font(.body)
                .padding(.bottom)
            maybeCurrentMembers
                .padding(.bottom)
        }
    }
    
    @ViewBuilder
    private var maybeCurrentMembers: some View {
        if let currentMembers = viewModel.currentMembers {
            Text("Current Members: \(currentMembers)")
        }
    }
    
    private var links: some View {
        VStack(alignment: .leading) {
            Text("Links:")
            ForEach(viewModel.urls, id: \.self) { link in
                Button(action: { linkButtonPressed(link: link)}) {
                    Text(link).font(.caption)
                }
            }
        }
    }
    
    private func linkButtonPressed(link: String) {
        if let url = URL(string: link) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    ArtistView()
        .preferredColorScheme(.dark)
}