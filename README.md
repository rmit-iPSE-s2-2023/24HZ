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

## Running Tests
Make sure to link any dependencies in test target:
1. Go to project settings
2. Click on `24HZTests` under `TARGETS` in left sidebar
3. Expand `Link Binary With Libraries`
4. Click on the `+` plus sign to add dependencies (e.g. `web3.swift`)

**Example:**
<img width="1122" alt="image" src="https://github.com/rmit-iPSE-s2-2023/a2-s3491222/assets/79826279/d512ba4a-19c6-4058-8141-3454335a3544">


## Project Architecture

The current project architecture is similar to the Container pattern found in React projects. However, this will be updated to an MV pattern to leverage the SwiftUI framework. This README will reflect the change in project architecture.

### Current Repo Structure
- `a1_s3713342App.swift`: App entry point
- `ContentView.swift`: Root UI View
- Models: contains data models of database objects
- Enums: contains useful enums
- Tabs: contains relevant views for each Tab
- Layouts: contains custom layouts
- Preview Content: contains dummy JSON data for prototyping purposes
- `JSON.swift`: contains dummy data fetching code
- `utils.swift`: contains utility code e.g. TimeInterval conversions
- `constants.swift`: contains useful constants
- `Assets.xcassets`: contains Static assets for the project

## Contributors
- Jin Heock Huh
- Min Chul Shin

## Credits
- Hacking with Swift for Swift best practices (https://www.hackingwithswift.com/)
- *Apple* for the useful [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- AzamSharp for SwiftUI design pattern analyses (https://azamsharp.com/)

## Acknowledgements
- Shekhar Kalra for approving our initial app idea and motivation
- James Dale for helping us iterate on our initial app designs
- Mazen Kourouche for teaching us SwiftUI tips & tricks

