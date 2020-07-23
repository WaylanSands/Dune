//
//  BackgroundMusicOptions.swift
//  Dune
//
//  Created by Waylan Sands on 26/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import Foundation

struct BackgroundMusic {
    
    static let options: [MusicOption] =
        [
            MusicOption(
                color: hexStringToUIColor(hex: "#735DFF"),
                artist: "Jeremy Blake",
                title: "Stardrive",
                loudAudioID: "stardriveLoud.mp3",
                lowAudioID: "stardriveLow.mp3",
                time: "1:00",
                duration: 60),
            MusicOption(
                color: hexStringToUIColor(hex: "#499DD9"),
                artist: "Side Steppin",
                title: "Otis McDonald",
                loudAudioID: "sideSteppinLoud.mp3",
                lowAudioID: "sideSteppinLow.mp3",
                time: "1:00",
                duration: 60),
            MusicOption(
                color: hexStringToUIColor(hex: "#00CE8C"),
                artist: "Millennials",
                title: "WaveToys",
                loudAudioID: "millennialsLoud.mp3",
                lowAudioID: "millennialsLow.mp3",
                time: "1:00",
                duration: 60),
            MusicOption(
                color: hexStringToUIColor(hex: "#005EFF"),
                artist: "Star Funker",
                title: "WaveToys",
                loudAudioID: "starFunkerLoud.mp3",
                lowAudioID: "starFunkerLow.mp3",
                time: "1:00",
                duration: 60),
            MusicOption(
                color: hexStringToUIColor(hex: "#FF7562"),
                artist: "Sport Drums",
                title: "WaveToys",
                loudAudioID: "sportDrumsLoud.mp3",
                lowAudioID: "sportDrumsLow.mp3",
                time: "1:00",
                duration: 60),
            MusicOption(
                color: hexStringToUIColor(hex: "#FF318C"),
                artist: "Inspirational Uplifting",
                title: "Alexander MGreat",
                loudAudioID: "inspiringCinematicLoud.mp3",
                lowAudioID: "inspiringCinematicLow.mp3",
                time: "1:00",
                duration: 60),
            MusicOption(
                color: hexStringToUIColor(hex: "#54E45A"),
                artist: "Meditation Spa",
                title: "Alexander MGreat",
                loudAudioID: "meditationSpaLoud.mp3",
                lowAudioID: "meditationSpaLow.mp3",
                time: "1:00",
                duration: 60),
    ]
}
