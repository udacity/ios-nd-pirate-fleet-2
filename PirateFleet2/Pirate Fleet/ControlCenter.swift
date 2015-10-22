//
//  ControlCenter.swift
//  Pirate Fleet
//
//  Created by Jarrod Parkes on 9/2/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

struct GridLocation {
    let x: Int
    let y: Int
}

struct Ship {
    let length: Int
    let location: GridLocation
    let isVertical: Bool
    let isWooden: Bool
    
    var cells: [GridLocation] {
        get {
            let start = self.location
            let end: GridLocation = ShipEndLocation(self)
            var localCells = [GridLocation]()
            for x in start.x...end.x {
                for y in start.y...end.y {
                    localCells.append(GridLocation(x: x, y: y))
                }
            }
            return localCells
        }
    }
    
    
    var hitTracker: HitTracker
    var sunk: Bool {
        get {
            for (_, hit) in hitTracker.cellsHit {
                if hit == false {
                    return false
                }
            }
            return true
        }
    }

    init(length: Int, location: GridLocation, isVertical: Bool) {
        self.length = length
        self.location = location
        self.isVertical = isVertical
        self.isWooden = false
        self.hitTracker = HitTracker()
    }
}

struct Mine: _Mine_ {
    let location: GridLocation
    let explosionText: String

    init(location: GridLocation) {
        self.location = location
        self.explosionText = "Default explosion text"
    }

    init(location: GridLocation, explosionText: String) {
        self.location = location
        self.explosionText = explosionText
    }
}

struct Seamonster {
    let location: GridLocation
}

enum Era {
    case OldThyme
    case Modern
}


struct GameSettings {
    var era : Era
}

class ControlCenter {

    func addShipsAndMines(human: Human) {
        // Code from Pirate Fleet 1 solution
        let smallShip = Ship(length: 2, location: GridLocation(x: 3, y: 4), isVertical: true )
        human.addShipToGrid(smallShip)
        
        let mediumShip1 = Ship(length: 3, location: GridLocation(x: 0, y: 0), isVertical: false)
        human.addShipToGrid(mediumShip1)
        
        let mediumShip2 = Ship(length: 3, location: GridLocation(x: 3, y: 1), isVertical: false)
        human.addShipToGrid(mediumShip2)
        
        let largeShip = Ship(length: 4, location: GridLocation(x: 6, y: 3), isVertical: true)
        human.addShipToGrid(largeShip)
        
        let xLargeShip = Ship(length: 5, location: GridLocation(x: 7, y: 2), isVertical: true)
        human.addShipToGrid(xLargeShip)
        
        let mine1 = Mine(location: GridLocation(x: 6, y: 0), explosionText: "Ka-Boom!")
        human.addMineToGrid(mine1)
        
        let mine2 = Mine(location: GridLocation(x: 3, y: 3))
        human.addMineToGrid(mine2)
    
        let seamonster1 = Seamonster(location: GridLocation(x: 5, y: 6))
        human.addSeamonsterToGrid(seamonster1)
        
        let seamonster2 = Seamonster(location: GridLocation(x: 2, y: 2))
        human.addSeamonsterToGrid(seamonster2)
    
    }
    
    func calculateFinalScore(gameStats: GameStats) -> Int {
        
        var finalScore: Int
        
        finalScore = 0                
        
        return finalScore
    }
}