//
//  BackgroundMusicOptions.swift
//  Dune
//
//  Created by Waylan Sands on 26/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import Foundation

struct BackgroundMusicOptions {
    
static let musicOptions: [MusicOption] =
    [
        MusicOption(
            color: hexStringToUIColor(hex: "#735DFF"),
                    artist: "Jeremy Blake",
                    title: "Stardive",
                    file: Bundle.main.url(forResource: "stardrive", withExtension: "mp3")!,
                    time: "1:00"),
        MusicOption(
                   color: hexStringToUIColor(hex: "#499DD9"),
                           artist: "Jeremy Blake",
                           title: "Stardive",
                           file: Bundle.main.url(forResource: "stardrive", withExtension: "mp3")!,
                           time: "1:00"),
        MusicOption(
                   color: hexStringToUIColor(hex: "#00CE8C"),
                           artist: "Jeremy Blake",
                           title: "Stardive",
                           file: Bundle.main.url(forResource: "stardrive", withExtension: "mp3")!,
                           time: "1:00"),
        MusicOption(
                   color: hexStringToUIColor(hex: "#005EFF"),
                           artist: "Jeremy Blake",
                           title: "Stardive",
                           file: Bundle.main.url(forResource: "stardrive", withExtension: "mp3")!,
                           time: "1:00"),
        MusicOption(
                   color: hexStringToUIColor(hex: "#FF7562"),
                           artist: "Jeremy Blake",
                           title: "Stardive",
                           file: Bundle.main.url(forResource: "stardrive", withExtension: "mp3")!,
                           time: "1:00"),
        MusicOption(
                   color: hexStringToUIColor(hex: "#FF318C"),
                           artist: "Jeremy Blake",
                           title: "Stardive",
                           file: Bundle.main.url(forResource: "stardrive", withExtension: "mp3")!,
                           time: "1:00"),
        MusicOption(
                   color: hexStringToUIColor(hex: "#54E45A"),
                           artist: "Jeremy Blake",
                           title: "Stardive",
                           file: Bundle.main.url(forResource: "stardrive", withExtension: "mp3")!,
                           time: "1:00"),
    ]
}
