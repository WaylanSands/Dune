////
////  StubbedPrograms.swift
////  Dune
////
////  Created by Waylan Sands on 2/3/20.
////  Copyright © 2020 Waylan Sands. All rights reserved.
////
//
//import Foundation
//
//
//struct StubbedPrograms {
//    static let programs: [Program] =
//        [
//            Program(name: "alfa",
//                    handel: "@alfaConnection",
//                    image: #imageLiteral(resourceName: "daily-hack"),
//                    summary: "Librarians interview authors, share reading suggestions and explore literary topics and lively conversations. Each episode is based on reading challenge categories, which encourage listeners to expand their reading horizons.",
//                    tags: ["Bssooks", "teacsssssshing", "educatiosssssssssssssssssn"]
//            ),
//            Program(name: "Bravo",
//                    handel: "@brva201",
//                    image: #imageLiteral(resourceName: "makeup-den"),
//                    summary: "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz",
//                    tags: ["People", "radio", "awards"]
//            ),
//            Program(name: "Charlie",
//                    handel: "@charliesAngles",
//                    image:  #imageLiteral(resourceName: "fast-news"),
//                    summary: "Your new ritual: Immerse yourself in a single poem, guided by Pádraig Ó Tuama. Short and unhurried; contemplative and energizing.",
//                    tags: ["news", "sports", "tech"]
//            ),
//            Program(name: "Delta",
//                    handel: "@deltafoxtrot",
//                    image:  #imageLiteral(resourceName: "momentum"),
//                    summary: "Jason Weiser tells stories from myths, legends, and folklore that have shaped cultures throughout history. Some, like the stories of Aladdin, King Arthur, and Hercules are stories you think you know, but with surprising origins.",
//                    tags: ["motivation", "discovery"]
//            ),
//            Program(name: "Cienna",
//                    handel: "@theprojectDirary",
//                    image:  #imageLiteral(resourceName: "lumo"), summary: "The world's top authors and critics join host Pamela Paul and editors at The New York Times Book Review to talk about the week's top books, what we're reading and what's going on in the literary world.",
//                    tags: ["money", "power", "news"]
//            ),
//            Program(name: "Nixon",
//                    handel: "@presidents",
//                    image:  #imageLiteral(resourceName: "hollywood"), summary: "This is what the news should sound like. The biggest stories of our time, told by the best journalists in the world. ",
//                    tags: ["love", "passion", "peace"]
//            ),
//            Program(name: "Karly",
//                    handel: "@klossMedia", image:  #imageLiteral(resourceName: "morning-shot"),
//                    summary: "Radically empathic advice, Co-hosted by BFFs Ann Friedman and Aminatou Sow. Produced by Gina Delvac. Brand new every Friday.",
//                    tags: ["TV", "personas"]
//            ),
//            Program(name: "Roger",
//                    handel: "@Roger_that",
//                    image:  #imageLiteral(resourceName: "our-planet"),
//                    summary: "A podcast for long distance besties everywhere. Co-hosted by BFFs Ann Friedman and Aminatou Sow. Produced by Gina Delvac. Brand new every Friday.",
//                    tags: ["Planets", "space", "discovery"]
//            ),
//            Program(name: "Mickey",
//                    handel: "@DisneyWorld",
//                    image:  #imageLiteral(resourceName: "kylie"),
//                    summary: "If you've ever wanted to know about champagne, satanism, the Stonewall Uprising, chaos theory, LSD, El Nino, true crime and Rosa Parks, then look no further. Josh and Chuck have you covered.",
//                    tags: ["its", "all", "me"]
//            ),
//            Program(name: "Max",
//                    handel: "@MAXBRENNER",
//                    image:  #imageLiteral(resourceName: "french-minute"),
//                    summary: "Shankar Vedantam uses science and storytelling to reveal the unconscious patterns that drive human behavior, shape our choices and direct our relationships.",
//                    tags: ["French", "lessons"])
//    ]
//}
//
////    func fetchData() ->[Program] {
////        let first = Program(name: "alfa", handel: "@alfaConnection", image: #imageLiteral(resourceName: "daily-hack"), summary: "Librarians interview authors, share reading suggestions and explore literary topics and lively conversations. Each episode is based on reading challenge categories, which encourage listeners to expand their reading horizons.", tags: ["Bssooks", "teacsssssshing", "educatiosssssssssssssssssn"])
////        let second = Program(name: "Bravo", handel: "@brva201", image: #imageLiteral(resourceName: "makeup-den"), summary: "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz", tags: ["People", "radio", "awards"])
////        let third = Program(name: "Charlie", handel: "@charliesAngles", image:  #imageLiteral(resourceName: "fast-news"), summary: "Your new ritual: Immerse yourself in a single poem, guided by Pádraig Ó Tuama. Short and unhurried; contemplative and energizing.", tags: ["news", "sports", "tech"])
////        let fourth = Program(name: "Delta", handel: "@deltafoxtrot", image:  #imageLiteral(resourceName: "momentum"), summary: "Jason Weiser tells stories from myths, legends, and folklore that have shaped cultures throughout history. Some, like the stories of Aladdin, King Arthur, and Hercules are stories you think you know, but with surprising origins.", tags: ["motivation", "discovery"])
////        let fifth = Program(name: "Cienna", handel: "@theprojectDirary", image:  #imageLiteral(resourceName: "lumo"), summary: "The world's top authors and critics join host Pamela Paul and editors at The New York Times Book Review to talk about the week's top books, what we're reading and what's going on in the literary world.", tags: ["money", "power", "news"])
////        let sixth = Program(name: "Nixon", handel: "@presidents", image:  #imageLiteral(resourceName: "hollywood"), summary: "This is what the news should sound like. The biggest stories of our time, told by the best journalists in the world. ", tags: ["love", "passion", "peace"])
////        let seventh = Program(name: "Karly", handel: "@klossMedia", image:  #imageLiteral(resourceName: "morning-shot"), summary: "Radically empathic advice, Co-hosted by BFFs Ann Friedman and Aminatou Sow. Produced by Gina Delvac. Brand new every Friday.", tags: ["TV", "personas"])
////        let eighth = Program(name: "Roger", handel: "@Roger_that", image:  #imageLiteral(resourceName: "our-planet"), summary: "A podcast for long distance besties everywhere. Co-hosted by BFFs Ann Friedman and Aminatou Sow. Produced by Gina Delvac. Brand new every Friday.", tags: ["Planets", "space", "discovery"])
////        let ninth = Program(name: "Mickey", handel: "@DisneyWorld", image:  #imageLiteral(resourceName: "kylie"), summary: "If you've ever wanted to know about champagne, satanism, the Stonewall Uprising, chaos theory, LSD, El Nino, true crime and Rosa Parks, then look no further. Josh and Chuck have you covered.", tags: ["its", "all", "me"])
////        let tenth = Program(name: "Max", handel: "@MAXBRENNER", image:  #imageLiteral(resourceName: "french-minute"), summary: "Shankar Vedantam uses science and storytelling to reveal the unconscious patterns that drive human behavior, shape our choices and direct our relationships.", tags: ["French", "lessons"])
////        return [first, second, third, fourth, fifth, sixth, seventh, eighth, ninth, tenth]
////    }
