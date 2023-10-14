//
// Listener+CoreDataClass.swift
// HZ24
// 
// Created by jin on 2023-10-13
// 


//

import Foundation
import CoreData

/// An object that listens to a specific set of events.
///
/// This is a Core Data parent entity that represents a _listener_ that the user creates. The Core Data stack fetches all the ``Listener``s that the user has enabled, and uses the additional attributes of their child entities (``NewTokenListener`` and ``ExistingTokenListener``) to capture the relevant ``Event``s from the network..
@objc(Listener)
public class Listener: NSManagedObject {

}
