# GoJek Take home README
Hi Go-Jek folks! 👋

I'm Robin, and first of all I'd like to thank you for letting me participate in your iOS engineer challenge. It's been a lot of fun, and honestly I've learned a lot.

## Goals
Our aim in this challenge is to build a Contacts app that uses a Webservice to persist data

![](https://thumbs.gfycat.com/ObedientVigorousAdeliepenguin-size_restricted.gif)

## Things I think I’ve done well
- State management
- Dynamic Type support
- Staying true to the design goals
- The app is architected using MVC + Coordinators - an architecture suggested by [Khanlou | Coordinators Redux](http://khanlou.com/2015/10/coordinators-redux/) . Here, every View Controller in the flow is managed by a high level `Coordinator` object that handles pushing, presentation, model mutation and a host of other responsibilities. More on this in the **Coordinators** section
- The API layer is 100% unit tested and decoupled - from building requests to ensuring my `Codable` implementations work as expected
- Proper Localization support with all strings encoded in the `Constants.swift` file 
- Each file is < 200 lines (No Massive View Controllers here 😉)

## Coordinators
The app uses Coordinators to ensure decoupling in the View Controllers and easy testability.  Since Coordinators talk to View Controllers (and coordinators talk to their children) via delegates, this architecture is inherently testable, owing to the fact that we can pass in our own objects conforming to a protocol.

## Things I think can improve
- There’s some state management + UI issues I’d like to improve on
- There’s some broken constraints in `UITableViewSectionHeader`s  (it seems to add a constraint for `height == 28` in-spite of me using `UITableViewAutomaticDimension` . But that’s UIKit and Autolayout for you  ¯\_(ツ)_/¯ 
- Image downloads still depend on a third party library (AlamofireImage). I did attempt writing my own [imageDownloader](https://github.com/codeOfRobin/GoJekAssignment/blob/9904b80713ca1ffda4351ca69c3c459b6d587985/GoJekTakeHome/ProfilePictureStorage.swift) but there's a lot of intricacies involved that I'd rather _not_ reinvent the wheel for.