//
//  Persistence.swift
//  dt-discography
//
//  Created by Jose A. Mena on 3/27/24.
//

import CoreData

protocol PersistenceController {
    func fetchArtist(with id: String) throws -> Artist
    func saveArtist(artist: Artist)
    func fetchReleases(for artistWithId: String) throws -> [Release]
    func saveReleases(releases: [Release], for artistId: String)
    func fetchReleaseDetails(with id: String) throws -> ReleaseDetails
    func saveReleaseDetails(releaseDetails: ReleaseDetails)
}

struct CoreDataPersistenceController: PersistenceController {
    static let shared = CoreDataPersistenceController()

    private let container: NSPersistentContainer

    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "dt_discography")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
    }

    func fetchArtist(with id: String) throws -> Artist {
        let request = NSFetchRequest<ArtistEntity>(entityName: "ArtistEntity")
        request.predicate = NSPredicate(format: "id == %@", id)

        guard let artistEntity = try container.viewContext.fetch(request).first else {
            throw AppError.unknown
        }

        return Artist(
            id: Int(artistEntity.id),
            name: artistEntity.name ?? "",
            profile: artistEntity.profile ?? "",
            imageUrl: artistEntity.imageUrl ?? "",
            urls: artistEntity.urls?.allObjects.compactMap { ($0 as? UrlEntity)?.url }
        )
    }

    func saveArtist(artist: Artist) {
        let artistEntity = ArtistEntity(context: container.viewContext)
        artistEntity.id = Int32(artist.id)
        artistEntity.name = artist.name
        artistEntity.profile = artist.profile
        artistEntity.currentMembers = artist.currentMembers
        artistEntity.imageUrl = artist.imageUrl

        let urlEntities = artist.urls?.map {
            let urlEntity = UrlEntity(context: container.viewContext)
            urlEntity.url = $0
            return urlEntity
        }

        artistEntity.urls = NSSet(array: urlEntities ?? [])

        do {
            try container.viewContext.save()
        } catch {
            print("Error saving.", error)
        }
    }

    func fetchReleases(for artistWithId: String) throws -> [Release] {
        let request = NSFetchRequest<ReleaseEntity>(entityName: "ReleaseEntity")
        request.predicate = NSPredicate(format: "artist.id == %@", artistWithId)
        let releaseEntities = try container.viewContext.fetch(request)
        return releaseEntities.map {
            Release(
                id: Int($0.id),
                mainRelease: Int($0.mainRelease),
                format: $0.format,
                title: $0.title ?? "",
                label: "",
                resourceUrl: $0.resourceUrl ?? "",
                year: Int($0.year),
                thumb: $0.thumbnailUrl ?? ""
            )
        }
    }

    func saveReleases(releases: [Release], for artistId: String) {
        let request = NSFetchRequest<ArtistEntity>(entityName: "ArtistEntity")
        request.predicate = NSPredicate(format: "id == %@", artistId)

        let artistEntity: ArtistEntity?

        do {
            artistEntity = try container.viewContext.fetch(request).first
        } catch {
            print("Error fetchig artist", error)
            return
        }

        let releaseEntities = releases.map { release in
            let entity = ReleaseEntity(context: container.viewContext)
            entity.id = Int32(release.id)
            entity.artist = artistEntity
            entity.format = release.format
            entity.mainRelease = Int32(release.mainRelease ?? 0)
            entity.resourceUrl = release.resourceUrl
            entity.thumbnailUrl = release.thumb
            entity.title = release.title
            entity.year = Int16(release.year ?? 0)

            return entity
        }

        artistEntity?.releases = NSSet(array: releaseEntities)

        do {
            try container.viewContext.save()
        } catch {
            print("Error saving.", error)
        }
    }

    func fetchReleaseDetails(with id: String) throws -> ReleaseDetails {
        let request = NSFetchRequest<ReleaseDetailsEntity>(entityName: "ReleaseDetailsEntity")
        request.predicate = NSPredicate(format: "id == %@", id)

        guard let releaseDetailsEntity = try container.viewContext.fetch(request).first else {
            throw AppError.unknown
        }

        let width = CGFloat(releaseDetailsEntity.imageWidth)
        let height = CGFloat(releaseDetailsEntity.imageHeight)
        let tracks = releaseDetailsEntity.tracks?.allObjects.compactMap {
            print($0)
            return $0 as? TrackEntity
        }
        .map { (trackEntity: TrackEntity) in
            Track(
                position: trackEntity.position ?? "",
                title: trackEntity.title ?? "",
                duration: trackEntity.duration ?? ""
            )
        } ?? []

        return ReleaseDetails(
            id: Int(releaseDetailsEntity.id),
            imageUrl: releaseDetailsEntity.imageUrl,
            imageSize: CGSize(width: width, height: height),
            title: releaseDetailsEntity.title ?? "Unknown",
            rating: Int(releaseDetailsEntity.rating),
            tracks: tracks // releaseDetailsEntity.tracks?.allObjects.compactMap { ($0 as? TrackEntity) } ?? []
        )
    }

    func saveReleaseDetails(releaseDetails: ReleaseDetails) {
        let request = NSFetchRequest<ReleaseEntity>(entityName: "ReleaseEntity")
        request.predicate = NSPredicate(format: "id == %@", "\(releaseDetails.id)")

        let releaseEntity: ReleaseEntity?

        do {
            releaseEntity = try container.viewContext.fetch(request).first
        } catch {
            print("Error fetchig release", error)
            return
        }

        let releaseDetailsEntity = ReleaseDetailsEntity(context: container.viewContext)

        let trackEntities = releaseDetails.tracks.map {
            let trackEntity = TrackEntity(context: container.viewContext)
            trackEntity.duration = $0.duration
            trackEntity.position = $0.position
            trackEntity.title = $0.title
            trackEntity.releaseDetails = releaseDetailsEntity
            return trackEntity
        }

        releaseDetailsEntity.id = Int32(releaseDetails.id)
        releaseDetailsEntity.title = releaseDetails.title
        releaseDetailsEntity.imageUrl = releaseDetails.imageUrl
        releaseDetailsEntity.imageHeight = Float(releaseDetails.imageSize.height)
        releaseDetailsEntity.imageWidth = Float(releaseDetails.imageSize.width)
        releaseDetailsEntity.tracks = NSSet(array: trackEntities)
        if let rating = releaseDetails.rating {
            releaseDetailsEntity.rating = Int16(rating)
        }

        releaseEntity?.releaseDetails = releaseDetailsEntity
        releaseDetailsEntity.releaseEntity = releaseEntity

        do {
            try container.viewContext.save()
        } catch {
            print("Error saving release details", error)
        }
    }
}
