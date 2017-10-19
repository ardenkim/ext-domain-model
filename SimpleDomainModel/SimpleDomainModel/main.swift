//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

protocol Mathematics {
    func add(_: Money) -> Money
    func subtract(_: Money) -> Money
}

extension Double {
    var USD : Money { return Money(amount: Int(self), currency: "USD") }
    var EUR : Money { return Money(amount: Int(self), currency: "EUR") }
    var GBP : Money { return Money(amount: Int(self), currency: "GBP") }
    var YEN : Money { return Money(amount: Int(self), currency: "YEN") }
}
////////////////////////////////////
// Money
//
public struct Money : CustomStringConvertible, Mathematics {
  public var amount : Int
  public var currency : String
  
    public var description: String {
        return "\(currency)\(amount)"
    }

  public func convert(_ to: String) -> Money {
    if (to == self.currency) {
        return self
    }
    
    var convertedAmount = Double(self.amount);
    // convert to GBP
    switch self.currency {
    case "USD":
        convertedAmount /= 2
    case "EUR":
        convertedAmount /= 3
    case "CAN":
        convertedAmount /= 2.5
    default:
        convertedAmount *= 1
    }
    
    switch to {
    case "USD":
        convertedAmount *= 2
    case "EUR":
        convertedAmount *= 3
    case "CAN":
        convertedAmount *= 2.5
    default:
        convertedAmount *= 1
    }

    return Money(amount: Int(convertedAmount), currency: to)
  }
  
  public func add(_ to: Money) -> Money {
    if (to.currency != self.currency) {
        return Money(amount: self.convert(to.currency).amount + to.amount, currency: to.currency)
    } else {
        return Money(amount: self.amount + to.amount, currency: to.currency)
    }
  }
  public func subtract(_ from: Money) -> Money {
    if (from.currency != self.currency) {
        return Money(amount: from.amount - self.convert(from.currency).amount, currency: from.currency)
    } else {
        return Money(amount: from.amount - self.amount, currency: from.currency)
    }
  }
}

////////////////////////////////////
// Job
//
open class Job : CustomStringConvertible {
    public var description: String {
        return "Job Title:\(title)"
    }
    
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
    
    mutating func increase(_ amt: Double) {
        switch self {
        case .Hourly(let val):
            self = .Hourly(val + amt)
        case .Salary(let val):
            self = .Salary(Int(Double(val) + amt))
        }
    }
  }
  
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    switch self.type {
    case .Hourly(let val):
        return Int(val * Double(hours))
    case .Salary(let val):
        return val
    }
  }
  
  open func raise(_ amt : Double) {
    type.increase(amt)
  }
}

////////////////////////////////////
// Person
//
open class Person : CustomStringConvertible {
    public var description: String {
        return "\(firstName) \(lastName) Age:\(age)"
    }
    
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get { return _job }
    set(value) {
        if (self.age > 15) {
            self._job = value
        }
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get { return _spouse }
    set(value) {
        if (self.age > 17) {
            self._spouse = value
        }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
    return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(String(describing: _job?.title)) spouse:\(String(describing: _spouse?.firstName))]"
  }
}

////////////////////////////////////
// Family
//
open class Family : CustomStringConvertible {
    public var description: String {
        return "There are \(members.count) members in \(members[0])\'s family"
    }
    
  fileprivate var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    if (spouse1.spouse == nil && spouse2.spouse == nil) {
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
        members.append(spouse1)
        members.append(spouse2)
    }
  }
  
  open func haveChild(_ child: Person) -> Bool {
    var legal = false
    for member in members {
        if (member.age > 21) {
            legal = true
        }
    }
    if (legal) {
        members.append(child)
    }
    return legal
  }
  
  open func householdIncome() -> Int {
    var income = 0
    for member in members {
        if (member.job != nil) {
            income += member.job!.calculateIncome(2000)
        }
    }
    return income
  }
}





