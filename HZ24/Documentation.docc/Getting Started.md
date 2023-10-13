# Getting Started

@Metadata {
    @PageImage(purpose: card, source: "getting-started-card", alt: "A stylized text branding of 24HZ.")
}

Understanding the 24HZ codebase.

## Overview

This article will describe the essential components of the 24HZ project's codebase.

## Assumed Knowledge

This article assume's the reader's knowledge about building, running, and working on a project in Xcode. For further information, see the official Apple documentation on [Building and running an app](https://developer.apple.com/documentation/xcode/building-and-running-an-app).

## Requirements and Dependencies

### Deployment Target

The current deployment target is iOS 15.2. Your development environment must meet the minimum requirements to support this SDK. See [Minimum requirements](https://developer.apple.com/support/xcode#minimum-requirements).

### Dependencies

The current version of the app relies on the `web3.swift` package for some convenient network methods. Make sure this package dependency is added to the project by ensuring it is included in the project settings for both the app and the test suite, specifically under the "Link Binary With Libraries" section in "Build Phases", as shown below.

![Screenshot showing the web3.swift package is included in the iOS app target](web3-package-app.png)

![Screenshot showing the web3.swift package is included in the test target](web3-package-test-suite.png)

For further information on adding packages, see the official Apple documentation [Adding package dependencies to your app](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app).

To learn more about the `web3.swift` package, visit their page on [GitHub](https://github.com/argentlabs/web3.swift) or 
[Swift Package Index](https://swiftpackageindex.com/argentlabs/web3.swift).

## Project Architecture

This project is built with the Model-View pattern for separation of concerns and code maintainability.

### Model

Files related to the model are found in the following groups:
- `Core Data`: This group represents the **data layer**. The ``CoreDataProvider`` class is responsible for managing the CRUD operations of Core Data entitites, and fetching the necessary data from the network layer.
- `Networking`: This group represents the **networking layer**. The ``EventsProvider`` protocol describes the required methods to provide blockchain event data to the Core Data layer. The ``DefaultEventsProvider`` is the default implementation of this protocol and utilizes the aforementioned `web3.swift` package, along with internal JSON-RPC methods to gather the necessary blockchain data.
- `Enums`: This group contains useful enums for the project.

To learn more about each group, see the documentation for the symbols highlighted under `Core Data Layer` and `Network Layer` in the <doc:HZ24> landing page. In the codebase, readers are expected to "option-click" on any additional symbols that are not highlighted in this document catalog.

### View

Files related to the UI are grouped as `Views`. This group represents the **view layer**. 24HZ leverages the SwiftUI provided `TabView` for navigation. The tab view consists of 3 main tabs, namely ``ListeningTab``, ``FeedTab``, and ``SavedTab``. Views used in each tab are grouped by their tab's title (e.g. `Listening` for the ``ListeningTab``). The reader is expected to refer to the documentation of each view via "option-clicking" on each symbol as they discover them in the view hierarchy. 

## Core Data Entities

The 24HZ Core Data model consists of 2 parent entities, ``Listener`` and ``Event``. The _listener_ represents the entity that the user manages and the _event_ represents the entity that the app retrieves from the blockchain. The child entities for each of these parent entities have additional attributes that are applicable for different types of listeners and events. To get an overview of "blockchain events", see <doc:Getting-Familiar-with-Blockchain-Events>. 
