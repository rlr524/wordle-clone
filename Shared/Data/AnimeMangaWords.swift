//
//  AnimeMangaWords.swift
//  WordleClone
//
//  Created by Rob Ranf on 8/10/22.
//

import Foundation

// The available words vary from three to nine Romaji characters, and the number of columns in the app will change
// depending upon which word is chosen randomly. The number of columns is the player's first clue as to what the word
// might be.
enum AnimeMangaWords {
    static var wordList: [String] = ["ANIME", "MANGA", "NARUTO", "NAKANO", "OREGAIRU"]
}
