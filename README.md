# SpotifyClone

An iOS app that **visually clones Spotify's app** and **consumes the official Spotify's Web API** to show(and play) songs, podcasts, artists and more.

The app can play a **30-second** preview of a song, otherwise, to play the full song it would be necessary to have a physical device and the real Spotify app installed(requirements of the Spotify iOS SDK).

I've built the project by myself to learn more about iOS development, and to consolidate already learnt concepts by putting them into practice. By no means the project is perfect, so feel free to open issues or make pull requests with your own new features.

I hope you enjoy the app. Feel free to hit me up! <br>

*-Gabriel*

<br>

| Home Screen | Search Screen | Track Details Screen | Playlist Details Screen |
|:---------------:|:---------------:|:---------------:|:---------------:|
| ![Screen Shot 2021-10-11 at 11 59 25 AM](https://user-images.githubusercontent.com/62707916/136813393-a3dcc218-d800-4556-aa58-11b0019fd89b.png) | ![Screen Shot 2021-10-11 at 12 00 41 PM](https://user-images.githubusercontent.com/62707916/136813456-e010e92f-2465-4f59-94a3-ecbe4bab71cf.png) | ![Screen Shot 2021-10-11 at 11 59 34 AM](https://user-images.githubusercontent.com/62707916/136813590-cbb9dd10-3798-45ac-990c-8f6ace31b36e.png) | ![Screen Shot 2021-10-11 at 12 00 36 PM](https://user-images.githubusercontent.com/62707916/136813659-5b816b8b-bcdb-4320-a166-6b203cb8ff0b.png) 
| Artist Details Screen | Podcast Details Screen | Album Details Screen | Active Searching Screen |  
![Screen Shot 2021-10-11 at 12 00 11 PM](https://user-images.githubusercontent.com/62707916/136813737-86d94816-901d-435f-9811-a3febb308024.png) | ![Screen Shot 2021-10-11 at 12 01 16 PM](https://user-images.githubusercontent.com/62707916/136813754-be65c94e-8c5e-4f47-b868-9bc861e8508e.png) | ![Screen Shot 2021-10-11 at 11 59 43 AM](https://user-images.githubusercontent.com/62707916/136813855-1a6a621d-96b9-45c3-b046-bc55c2eea414.png) | ![Screen Shot 2021-10-11 at 12 01 01 PM](https://user-images.githubusercontent.com/62707916/136819824-dfe87231-459f-42e3-a356-133b8503d6d2.png)

<br> <br>
<br> <br>

# How to set up (>5 min)

1. Fork this project and `git clone ...`
2. Create/login with your Spotify Account in the [Spotify for Developers](https://developer.spotify.com) website.
3. Go to [dashboard](https://developer.spotify.com/dashboard/applications) and select '**Create an app**'.
4. Give the name and description that you want and in the dashboard select the app that you've just created.
5. Go to your local clone of the project in your machine and open '**YourSensitiveData.swift**' (./SpotifyClone/SpotifyCloneProject/YourSensitiveData).
6. Back in your application page of the dashboard, copy the '**Client ID**' and '**Client Secret**' and paste them in '**YourSensitiveData.swift**'.
7. Again in the dashboard select '**Users and access**' an then click in '**Add new user**'*(if you try to log-in into an account in the app without adding it here, your app will crash with error 403 because Spotify's API doesn't allow that)*. 
8. In the dashboard select 'EDIT SETTINGS', in the field `redirect_uri` paste `https://www.github.com` (can be any website, but needs to match the `redirect_uri` set in `AuthViewModel.swift`, that by default was set to `https://www.github.com`)
9. **Great! Now you just need to run the app!**

If you have any problem, feel free to contact me on [github](https://github.com/gabrieldenoni)

<br> <br>
<br> <br>

## Concepts & Technologies Used
 - Swift
 - Consuming a REST API
 - Caching
 - AVFoundation to play and control audio
 - Combine *(minor use)*
 - SwiftUI
 - XCode Instruments
 - Memory Management and Cache Cleaning
 - Grand Central Dispatch
 - Dependency Injection
 - CocoaPods

 **External Dependencies:**
 - Alamofire
 - Introspect *(really small use)*
 - SwiftLint


<br> <br>


## Turn on the video volume
| | | | |
| :-: | :-: | :-: | :- |
<video src='https://user-images.githubusercontent.com/62707916/138572032-636c1182-92f0-408d-9ed9-bf143e556fd5.mov' width=180/> | <video src='https://user-images.githubusercontent.com/62707916/136820651-4d632ea2-e952-4b4f-afde-cbd3becf3b1a.mov' width=180/> | <video src='https://user-images.githubusercontent.com/62707916/136820663-5bf7d61d-57ac-4fe7-9b47-2aca33516611.mov' width=180/> | <video src='https://user-images.githubusercontent.com/62707916/136820671-a5aece22-3a97-4cdd-9a4f-6b4ef77311ff.mov' width=180/>

*Stuttering is due to simulator lag and shouldn't happen on real device.*

<br> <br>

## Code Overview

### ViewModels

#### Main
- Navigation
- Source of the Spotify's Authentication Key to the subviewmodels

#### Auth
- *`Coordinator`*: Controls the WebView responses
- Contacts Service(`/APIAuthentication`) to get the Authentication Key
- Controls the state of AuthScreen

#### Home
- Contacts Service(`/HomePageAPICalls`) to get media(tracks, podcasts, playlists, albums, artists and episodes) data from the API
- Controls HomeSubpages(playlistDetail, trackDetail, etc…)
- Controls the state of HomeScreen

#### Search
- *`ActiveSearchViewModel`*: Contacts Service(`/SearchPageAPICalls`) to get response data(based on what the user searched) from the API ¹ 
- Contacts Service(`/SearchPageAPICalls`) to get media data from API ²
- Controls SearchSubpages(activeSearching, playlistDetail, trackDetail, etc…)
- Controls the state of DetailScreen

#### Details
- Contacts Service(`/MediaDetailsPageAPICalls`) to get the detailed data, for a specific item(the item that was clicked), from the API
- Controls the state of DetailScreen


<sup> ¹ The viewmodel for when the user is actively searching for an item. <br>
² The viewmodel for when the user just opened the SearchScreen, it's similar to a discover screen.


## Things to do/improve
  
- [ ] Use protocols to reduce code duplication.
- [ ] Add more animations(like, follow, navigation, etc).
- [ ] Play playlists(one song after another).
- [ ] Use navigation link for navigation.
- [ ] Save that the user is already logged.
- [ ] Unit testing.
- [ ] Solve animation hitches when scrolling in the playlist tracks.
- [ ] Better project architecture.
- [ ] Make the currently playing track bottom bar work.
- [ ] Make the three dots work to open more options.


<br> <br> <br>
  
![DeC-SV5W4AEDegt](https://user-images.githubusercontent.com/62707916/136847961-b1d23d4c-2f2a-4a1c-b34b-e726997204af.png)

