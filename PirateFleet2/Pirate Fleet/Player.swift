//
//  Player.swift
//  Pirate Fleet
//
//  Created by Jarrod Parkes on 8/27/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit

// MARK: - PlayerMine
// Used to give students a clean interface 😉!

struct PlayerMine: _Mine_ {
    var location: GridLocation
    var explosionText: String
}

// MARK: - Player

class Player {
    
    // MARK: Properties
    
    var playerDelegate: PlayerDelegate?
    var playerType: PlayerType
    var skipNextTurn = false
    var takeAHit = false
    var lastHitMine: _Mine_? = nil
    var lastHitSeamonster: Seamonster? = nil
    var numberOfMisses: Int = 0
    var numberOfHits: Int = 0
    var performedMoves = Set<GridLocation>()
    var gridViewController: GridViewController
    var gridView: GridView {
        get {
            return gridViewController.gridView
        }
    }
    var grid: [[GridCell]] {
        get {
            return gridViewController.gridView.grid
        }
    }
    
    // MARK: Initializers
    
    init(frame: CGRect) {
        gridViewController = GridViewController(frame: frame)
        playerType = .Computer
    }

    func reset() {
        gridViewController.reset()
        performedMoves.removeAll(keepCapacity: true)
        skipNextTurn = false
    }
    
    // MARK: Pre-Game Check
    
    func numberOfMines() -> Int {
        return gridViewController.mineCount
    }
    
    func numberOfSeamonsters() -> Int {
        return gridViewController.seamonsterCount
    }
    
    
    func readyToPlay(checkMines checkMines: Bool = true) -> Bool {
        return (checkMines == true) ? gridViewController.hasRequiredShips() && gridViewController.hasRequiredMines() : gridViewController.hasRequiredShips()
    }
    
    // MARK: Attacking  
    
    func attackPlayer(player: Player, atLocation: GridLocation) {
        
        performedMoves.insert(atLocation)
        
        // hit a mine?
        if let mine = player.grid[atLocation.x][atLocation.y].mine {
            skipNextTurn = true
            lastHitMine = mine
            numberOfMisses++
            player.gridView.markMineHit(mine)
        }
        
        // hit a seamonster?
        if let seamonster = player.grid[atLocation.x][atLocation.y].seamonster {
            lastHitSeamonster = seamonster
            numberOfMisses++
            takeAHit = true
            //attackPlayerWithGuaranteedHit(player)
            player.gridView.markSeamonsterHit(seamonster)
        }
        
        // hit a ship?
        if !player.gridViewController.fireCannonAtLocation(atLocation) {
            numberOfMisses++
            player.gridView.markMissed(atLocation)
        } else {
            // we hit something!
            numberOfHits++
        }        
                
        if let playerDelegate = playerDelegate {
            
            if player.gridViewController.checkSink(atLocation) {
                playerDelegate.playerDidSinkAtLocation(self, location: atLocation)
            }
            
            if player.gridViewController.checkForWin() {
                playerDelegate.playerDidWin(self)
            }
            playerDelegate.playerDidMove(self)
        }
    }
    
    func canAttackPlayer(player: Player, atLocation: GridLocation) -> Bool {
        return locationInBounds(atLocation) && !performedMoves.contains(atLocation)
    }
    
    func locationInBounds(location: GridLocation) -> Bool {
        return !(location.x < 0 || location.y < 0 || location.x >= Settings.DefaultGridSize.width || location.y >= Settings.DefaultGridSize.height)
    }
    
    //MARK: Guaranteed Hit
    func attackPlayerWithGuaranteedHit(player: Player) {
        var hitShip = false
        
        while hitShip == false {
            let location = RandomGridLocation()
            if !performedMoves.contains(location) {
                // hit a mine?
                if let _ = player.grid[location.x][location.y].mine {
                    // do nothing
                }
        
                // hit a seamonster?
                if let _ = player.grid[location.x][location.y].seamonster {
                    // do nothing
                }
        
                // hit a ship?
                if !player.gridViewController.fireCannonAtLocation(location) {
                   //do nothing
                } else {
                    // we hit something!
                    hitShip = true
                    numberOfHits++
                    performedMoves.insert(location)
        
                    if let playerDelegate = playerDelegate {
                        
                        if player.gridViewController.checkSink(location) {
                            playerDelegate.playerDidSinkAtLocation(self, location: location)
                        }
                        
                        if player.gridViewController.checkForWin() {
                            playerDelegate.playerDidWin(self)
                        }
                        playerDelegate.playerDidMove(self)
                    }
                }
            }
        }
    }
    
    // MARK: Modify Grid
    
    func revealShipAtLocation(location: GridLocation) {
        let connectedCells = grid[location.x][location.y].ship?.cells
        gridView.revealLocations(connectedCells!)
    }
    
    func addPlayerShipsAndMines(numberOfMines: Int = 0) {
        
        // randomize ship placement
        for (requiredShipType, requiredNumber) in Settings.RequiredShips {
            for _ in 0..<requiredNumber {
                let shipLength = requiredShipType.rawValue
                
                var shipLocation = RandomGridLocation()
                var vertical = Int(arc4random_uniform(UInt32(2))) == 0 ? true : false
                var ship = Ship(length: shipLength, location: shipLocation, isVertical: vertical)
                
                while !gridViewController.addShip(ship, playerType: .Computer) {
                    shipLocation = RandomGridLocation()
                    vertical = Int(arc4random_uniform(UInt32(2))) == 0 ? true : false
                    ship = Ship(length: shipLength, location: shipLocation, isVertical: vertical)
                }
            }
        }
                
        // random mine placement
        for _ in 0..<numberOfMines {
            var location = RandomGridLocation()
            var mine = PlayerMine(location: location, explosionText: Settings.DefaultMineText)
            while !gridViewController.addMine(mine, playerType: .Computer) {
                location = RandomGridLocation()
                mine = PlayerMine(location: location, explosionText: Settings.DefaultMineText)
            }
        }
    }
}