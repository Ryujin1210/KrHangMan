import Foundation
//
//struct WordModelOfAPI: Codable {
//    let words, means: String?
//    let cutWords: [String]?
//
//    enum CodingKeys: String, CodingKey {
//        case words, means
//        case cutWords = "cut-words"
//    }
//
//    func convertModel() -> Word {
//        guard let words = words, let means = means, let cutWords = cutWords else {
//            return Word(words: "", means: "", cutWords: [])
//        }
//        return Word(words: words, means: means, cutWords: cutWords)
//    }
//}
//
//typealias WordAPIModel = [WordModelOfAPI]


// MARK: - WordAPIModel
struct WordAPIModel: Codable {
    let wordList: [WordList]
    let code: Int
    let message: String

    enum CodingKeys: String, CodingKey {
        case wordList = "word_list"
        case code, message
    }
}

// MARK: - WordList
struct WordList: Codable {
    let word, mean: String?
    let spell: [String]?
    
    func convertModel() -> Word {
        guard let word = word, let mean = mean, let spell = spell else {
            return Word(word: "", mean: "", spell: [])
        }
        return Word(word: word, mean: mean, spell: spell)
    }
}
