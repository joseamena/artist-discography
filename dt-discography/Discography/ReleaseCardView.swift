//
//  ReleaseCardView.swift
//  dt-discography
//
//  Created by Jose A. Mena on 3/28/24.
//

import Kingfisher
import SwiftUI

struct ReleaseCardView: View {
    // MARK: - Properties -

    let release: Release

    // MARK: - UI Content -

    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground)
            HStack(alignment: .center) {
                thumbnail
                releaseInfo
                Spacer()
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.primary.opacity(0.2), radius: 12, x: 8, y: 8)
        .padding()
    }

    private var thumbnail: some View {
        KFImage(URL(string: release.thumb))
            .placeholder { progress in
                ProgressView(progress)
            }
            .onFailureImage(UIImage(named: "cd"))
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 100, height: 100)
            .clipShape(
                RoundedRectangle(cornerRadius: 12)
            )
    }

    private var releaseInfo: some View {
        VStack(alignment: .leading) {
            Text("Title: \(release.title)").multilineTextAlignment(.leading)
            if let year = release.year {
                Text(verbatim: "Released: \(year)").multilineTextAlignment(.leading)
            }
        }
    }
}

// MARK: - Previews -

#Preview {
    ReleaseCardView(
        release: Release(
            id: 0,
            mainRelease: 0,
            format: "12\", Maxi",
            title: "Title",
            label: "Capitol",
            resourceUrl: "https://mock.com",
            year: 1500,
            thumb: "https://i.discogs.com/otrB6zRwRDNhznIkjQ5_DwLO3dNjNvWxdbYV4g6tXTs/rs:fit/g:sm/q:40/h:150/w:150/czM6Ly9kaXNjb2dz/LWRhdGFiYXNlLWlt/YWdlcy9SLTkwNDc1/NjEtMTQ3Mzg1NzUz/NS01Mzc0LmpwZWc.jpeg"
        )
    )
    .previewLayout(.sizeThatFits)
    .previewDisplayName("Default")
}
