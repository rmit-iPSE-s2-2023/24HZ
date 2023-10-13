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
/// This is a Core Data parent entity that represents a _listener_ that the user creates. The ``CoreDataProvider`` fetches all the ``Listener``(s) that the user has enabled, and uses the additional attributes of their child entities (``NewTokenListener`` and ``ExistingTokenListener``) to capture the corresponding set of ``Event``(s).
@objc(Listener)
public class Listener: NSManagedObject {

}
