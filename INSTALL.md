## Installation Instructions

### Requirements
1. A mac computer running MacOS 12 or greater.
2. Xcode 13 or later installed.
3. [Cocoapods](https://cocoapods.org/) installed.
4. A [Mapbox](https://www.mapbox.com/) account and access token.
5. A [Firebase](http://firebase.google.com) account with Cloud Firestore, Cloud Storage, and Sign in With Apple Authentication enabled.

### Setup

1. Clone the repository to your local computer.
2. Follow the directions outlined [here](https://docs.mapbox.com/ios/maps/guides/install/) to get your Mapbox *access token* and configure your machine to be able to download the mapbox library using that token.
3. Follow the instructions in the [CardinalKit documentation](https://cardinalkit.org/cardinalkit-docs/1-cardinalkit-app/2-setup.html) regarding configuring your Firebase account for the iOS application. You will also need to configure `Sign In With Apple` as [documented here](https://cardinalkit.org/cardinalkit-docs/1-cardinalkit-app/2-setup.html#_4-setting-up-sign-in-with-apple-optional).
3. In the terminal, navigate to the `LifeSpace` folder, which contains `LifeSpace.xcworkspace`.
5. Install dependencies by running `pod install` in this folder.
6. Open `LifeSpace.xcworkspace` in Xcode. (Do not open `LifeSpace.xcodeproj` as the dependencies will not be included.)
7. In Xcode, copy the `GoogleService-Info.plist` file you generated in *Step 2* from your Firebase account into the `Supporting Files` folder.
8. In the `Supporting Files` folder, click on the `Info.plist` file and in the `MBXAccessToken` field, paste in the *access token* you obtained in *Step 2*.

### Testing

Now that your environment and application are set up, you can start testing the application. The authors recommend testing on a physical iOS device.