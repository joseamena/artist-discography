# Musical Artist Discography App

Welcome to the Musical Artist Discography App! This app is designed to provide users with a seamless and immersive experience for exploring the discography of their favorite musical artists and bands.

## Features

- **Artist Details Screen**: Short summary of the artist.
- **Discography Screen**: Dive into the complete discography of the artist.
- **Relese Details Screen**: Track listing and other details about the artist's release.
- **Caching**: The app will cache the data to prevent making requests.
- **Offline mode**: If the app has been ran before, the data is stored locally to persist between launches.

## Testing

- **Unit Testing**: Some basic unit testing for view models.
- **UI Testing**: Only a basic test navigating to the Discography Screen.

## Manual Testing

1. Start the app.
2. Navigate to Artist Discography.
3. On the Artisti Discography screen tap a release.
4. Scroll Down if necessary to view track listing.
5. Disconnect from the network. 
6. The visited screens should show the same information, as the network fetches is cached. An unvisited release would give an error message
7. With the network still off, stop the app and relaunch
8. Verify the app still shows content, verifying that the data was saved to persistent storage. Note: Some Images will not show because Kingfisher library is doing the caching/storage of images, this could be improved by increasing the Dis Cache Size


## Dependencies

- **Kingfisher**: For asynchonous image loading and caching.
