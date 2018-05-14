GoJek Take Home README
Hi Go-Jek folks! 👋
I'm Robin, and first of all I'd like to thank you for letting me participate in your iOS engineer challenge. It's been a lot of fun, and honestly I've learned a lot.

Goals

Our aim in this challenge was to build a Contacts app similar to the iOS contacts app, but with a smaller feature set.

![](https://thumbs.gfycat.com/ObedientVigorousAdeliepenguin-size_restricted.gif)

Things I think I’ve done well
- State management - there’s proper well-defined loading states and single sources of truth.
- For proper a11y, all labels in the app have full Dynamic Type support.
- Stays true to the design goals. (Even double checked things with flawlessapp.io!) 
- The app is architected using MVC + Coordinators - an architecture suggested by Khanlou | Coordinators Redux . More on this in the Coordinators section.
- The API layer is 100% unit tested and decoupled - from building requests to ensuring my `Codable` implementations work as expected.
- Proper Localization support with all strings encoded in the `Constants.swift` file.
- Each file is < 200 lines. (No Massive View Controllers here. 😉)

Coordinators
In MVC-C, every View Controller in the flow is managed by a high level `Coordinator` object that handles pushing, presentation, model mutation and a host of other responsibilities.

The app uses Coordinators to ensure decoupling in the View Controllers and easy testability. Since Coordinators talk to View Controllers (and coordinators talk to their children) via delegates, this architecture is inherently testable, owing to the fact that we can pass in our own objects conforming to a protocol.

Considerations
- In the contacts listing, I’ve used an embeddable child view controller approach (as suggested by John Sundell’s post here). This lets me reuse the LoadingViewController in as many places as possible in the future. In order to make the app feel faster, the activity indicator doesn’t appear for the first 1.5 seconds - the less time the user spends staring at a spinner, the faster the app feels.
- For now, all state mutation operations are synchronous. Any operation like editing contacts, adding etc waits for a request to complete and shows the user a spinner in the nav bar.(Check out the Things I can improve section for more on how we might improve this.)
- The API layer relies on a decoupled `APIRequestBuilder` that creates requests for the actual `APIClient`. Do note that the `APIClient` runs on pure `URLSession`, thus allowing for easy testability without swizzling (unlike, say Alamofire).
- Remote images are handled via `AlamofireImage`, for now.  I did attempt writing my own `imageDownloader` but there's a lot of intricacies involved that I'd rather _not_ reinvent the wheel for.
- Interestingly, getting `UICollation` to work with my `Contact` structs was easier than I expected: using `#selector(getter: NSString.lowercased))` seems to trigger the necessary bridging magic.
- I’ve used Autolayout in code instead of xibs or storyboards. In a real world app, I’d probably use a library like Anchorage or SnapKit (or, if I was allowed, Texture/AsyncDisplayKit).
Things I can improve
- There’s some state management + UI issues I’d like to improve on.  For example, I’d like saving and updating contacts to feel more asynchronous - no user likes seeing spinners in their app! But doing so would require a ton of investment in a sync engine, an observable contacts store, an offline data persistence layer - things that are beyond the scope of a simple take home project.
- There’s some broken constraints in `UITableViewSectionHeader`s (it seems to add a constraint for `height == 28` in-spite of me using `UITableViewAutomaticDimension` . But that’s UIKit and Autolayout for you ¯_(ツ)_/¯
- The Loading state for the `ContactDetailsViewController` could be a _lot_ better. I’d considered using 2 activity indicators, but that didn’t quite feel right. I’d also thought of just adding a `LoadingViewController`, but we’ve already downloaded some contact information - why not show it to the user?