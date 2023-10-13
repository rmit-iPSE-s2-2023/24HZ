//
// Event+CoreDataClass.swift
// HZ24
// 
// Created by jin on 2023-10-13
// 


//

import Foundation
import CoreData

/// An object that describes a particular event that happened on the blockchain.
///
/// This is a Core Data parent entity that represents a particular event captured by a ``Listener``. As events are captured by a particular listener, it forms a relationship between the two entities.
///
/// As there are multiple types of events that can be captured, the child entities (``NewTokenEvent``, ``MetadataEvent`` and ``MintCommentEvent``) contain additional attributes that are particular to each of these different types of events.
@objc(Event)
public class Event: NSManagedObject {

}
