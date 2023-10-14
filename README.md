# 24HZ

This repository houses the *24HZ* codebase, an iOS App built with SwiftUI.

## RMIT Assessment 2

Miro board: https://miro.com/app/board/uXjVMpMwtAc=/?share_link_id=916731394061

## Description
*24HZ* is an iOS app that alerts users about events on the Zora blockchain.

## Dependencies
- `web3.swift`: https://github.com/argentlabs/web3.swift
  - Ethereum RPC convenience classes

## Getting Started
1. Clone the repo
2. Open the project using Xcode
3. Build and run via the Simulator or physical iPhone device with iOS version 15.2 and above

> The minimum deployment target for this project is iOS 15.2

> Please refer to the Documentation Catalog (`Documentation.docc`) in the codebase for more detailed information on getting started as well as conceptual guidance on domain-specific knowledge.

## Running Tests
Make sure to link any dependencies in test target:
1. Go to project settings
2. Click on `24HZTests` under `TARGETS` in left sidebar
3. Expand `Link Binary With Libraries`
4. Click on the `+` plus sign to add dependencies (e.g. `web3.swift`)

**Example:**
<img width="1122" alt="image" src="https://github.com/rmit-iPSE-s2-2023/a2-s3491222/assets/79826279/d512ba4a-19c6-4058-8141-3454335a3544">


## Project Architecture

The current project architecture is using the MV pattern.

### Current Repo Structure
- `Main.swift`: App entry point
- `ContentView.swift`: Root UI View
- Validation: contains code to validate Ethereum addresses
- Enums: contains useful enums for the project
- Scanner: contains UIKit integration for QR code scanning functionality
- Core Data: contains code to manage the Core Data stack
- Preview Content: contains code to create preview objects for debugging purposes
- Views: contains code related to creating UI components

## Contributors
- Jin Heock Huh
- Min Chul Shin

## Credits
- Hacking with Swift for Swift best practices (https://www.hackingwithswift.com/)
- *Apple* for the useful [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- AzamSharp for SwiftUI design pattern analyses (https://azamsharp.com/)
- Konstantin for tutorial on creating a QR code scanning feature for a SwiftUI app (https://blog.devgenius.io/camera-preview-and-a-qr-code-scanner-in-swiftui-48b111155c66)

## Acknowledgements
- Shekhar Kalra for approving our initial app idea and motivation
- James Dale for helping us iterate on our initial app designs
- Mazen Kourouche for teaching us SwiftUI tips & tricks

