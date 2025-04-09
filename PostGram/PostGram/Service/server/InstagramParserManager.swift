//
//  InstagramParserManager.swift
//  PostGram
//
//  Created on 7.04.2025.
//

import Foundation
import UIKit
import WebKit

class InstagramParserManager {
    
    // MARK: - Singleton Instance
    static let shared = InstagramParserManager()
    private init() {}
    
    // MARK: - Properties
    private let session = URLSession.shared
    
    // MARK: - Public Methods
    
    /// Parses an Instagram post URL and creates a PostModel
    /// - Parameters:
    ///   - urlString: The Instagram post URL string
    ///   - completion: Completion handler with Result type containing PostModel or Error
    func parseInstagramPost(from urlString: String, completion: @escaping (Result<PostModel, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(ParserError.invalidURL))
            return
        }
        
        fetchHTMLContent(from: url) { [weak self] result in
            switch result {
            case .success(let htmlContent):
                self?.parseHTML(htmlContent, from: url) { result in
                    completion(result)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// Fetches HTML content from a URL
    private func fetchHTMLContent(from url: URL, completion: @escaping (Result<String, Error>) -> Void) {
        // Create a request with browser-like headers to avoid being blocked
        var request = URLRequest(url: url)
        request.addValue("Mozilla/5.0 (iPhone; CPU iPhone OS 15_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.5 Mobile/15E148 Safari/604.1", forHTTPHeaderField: "User-Agent")
        request.addValue("text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", forHTTPHeaderField: "Accept")
        request.addValue("en-US,en;q=0.9", forHTTPHeaderField: "Accept-Language")
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(ParserError.invalidResponse))
                return
            }
            
            print("HTTP Status Code: \(httpResponse.statusCode)")
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(ParserError.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(ParserError.invalidData))
                return
            }
            
            // Try multiple encodings if UTF-8 fails
            if let htmlContent = String(data: data, encoding: .utf8) {
                completion(.success(htmlContent))
            } else if let htmlContent = String(data: data, encoding: .isoLatin1) {
                completion(.success(htmlContent))
            } else if let htmlContent = String(data: data, encoding: .ascii) {
                completion(.success(htmlContent))
            } else {
                print("Failed to decode HTML with any encoding")
                
                // Log partial data for debugging
                if let partialContent = String(data: data.prefix(1000), encoding: .utf8) {
                    print("First 1000 bytes: \(partialContent)")
                }
                
                completion(.failure(ParserError.invalidData))
            }
        }
        
        task.resume()
    }
    
    /// Parses HTML content to extract Instagram post data
    private func parseHTML(_ html: String, from url: URL, completion: @escaping (Result<PostModel, Error>) -> Void) {
        // Extract metadata from HTML
        do {
            // Multiple patterns to try for robustness
            let mediaURLPatterns = [
                "\"display_url\":\"(.*?)\"",
                "\"display_src\":\"(.*?)\"",
                "property=\"og:image\" content=\"(.*?)\"",
                "<meta property=\"og:image\" content=\"(.*?)\"",
                "content=\"(https:\\/\\/[^\"]*\\.cdninstagram\\.com[^\"]*)\""
            ]
            
            let videoURLPatterns = [
                "\"video_url\":\"(.*?)\"",
                "property=\"og:video\" content=\"(.*?)\"",
                "\"video_versions\":\\[\\{\"type\":.*?,\"url\":\"(.*?)\"",
                "<meta property=\"og:video\" content=\"(.*?)\"",
                "content=\"(https:\\/\\/[^\"]*\\.cdninstagram\\.com[^\"]*.mp4[^\"]*)\""
            ]
            
            // Extract post information with multiple pattern attempts
            let captionPatterns = [
                "\"text\":\"(.*?)\"",
                "\"caption\":\"(.*?)\"",
                "<meta property=\"og:description\" content=\"(.*?)\"",
                "property=\"og:description\" content=\"(.*?)\""
            ]
            
            let ownerNamePatterns = [
                "\"username\":\"(.*?)\"",
                "@([a-zA-Z0-9._]{1,30})",
                "\"owner\":\\{\"id\":\".*?\",\"username\":\"(.*?)\"\\}",
                "<meta property=\"og:title\" content=\"(.*?) on Instagram\""
            ]
            
            let ownerProfilePicPatterns = [
                "\"profile_pic_url\":\"(.*?)\"",
                "\"profile_pic_url_hd\":\"(.*?)\"",
                "\"user\":{[^}]*\"profile_pic_url\":\"(.*?)\""
            ]
            
            let timestampPatterns = [
                "\"taken_at_timestamp\":(\\d+)",
                "\"taken_at\":(\\d+)",
                "\"date\":(\\d+)"
            ]
                        
            // Find media URL (try multiple patterns)
            let mediaURL = try findFirstMatch(from: html, patterns: mediaURLPatterns)
                .replacingOccurrences(of: "\\u0026", with: "&")
                .replacingOccurrences(of: "\\", with: "")
            
            // Debug info
            print("Found media URL: \(mediaURL)")
            
            // Try to find video URL (if exists)
            var videoData: Data? = nil
            var isVideo = false
            
            if let videoURLString = try? findFirstMatch(from: html, patterns: videoURLPatterns)
                .replacingOccurrences(of: "\\u0026", with: "&")
                .replacingOccurrences(of: "\\", with: ""),
               let videoURL = URL(string: videoURLString) {
                isVideo = true
                print("Found video URL: \(videoURLString)")
                
                // Download video data
                if let data = try? Data(contentsOf: videoURL) {
                    videoData = data
                    print("Downloaded video data: \(data.count) bytes")
                }
            }
            
            // Extract other post info (with fallbacks)
            let caption = (try? findFirstMatch(from: html, patterns: captionPatterns)
                .replacingOccurrences(of: "\\n", with: "\n")
                .replacingOccurrences(of: "\\", with: "")) ?? ""
            
            let ownerName = (try? findFirstMatch(from: html, patterns: ownerNamePatterns)) ?? "unknown_user"
            
            let ownerProfilePicURLString = (try? findFirstMatch(from: html, patterns: ownerProfilePicPatterns)
                .replacingOccurrences(of: "\\u0026", with: "&")
                .replacingOccurrences(of: "\\", with: "")) ?? ""
            
            // Default to current timestamp if not found
            let timestamp = (try? findFirstMatch(from: html, patterns: timestampPatterns)) ?? "\(Int(Date().timeIntervalSince1970))"
            let date = Date(timeIntervalSince1970: Double(timestamp) ?? Date().timeIntervalSince1970)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            let createdAt = dateFormatter.string(from: date)
            
            // Fetch images asynchronously
            let dispatchGroup = DispatchGroup()
            
            var postImage: UIImage = UIImage(named: "placeholder") ?? UIImage()
            var ownerImage: UIImage = UIImage(named: "user_placeholder") ?? UIImage()
            
            // Always download the thumbnail image (for both video and image posts)
            dispatchGroup.enter()
            downloadImage(from: mediaURL) { image in
                if let image = image {
                    postImage = image
                    print("Downloaded post thumbnail: \(image.size.width)x\(image.size.height)")
                } else {
                    print("Failed to download thumbnail image")
                }
                dispatchGroup.leave()
            }
            
            // Download owner profile image if available
            if !ownerProfilePicURLString.isEmpty {
                dispatchGroup.enter()
                downloadImage(from: ownerProfilePicURLString) { image in
                    if let image = image {
                        ownerImage = image
                    }
                    dispatchGroup.leave()
                }
            } else {
                print("Owner profile picture URL not found")
            }
            
            dispatchGroup.notify(queue: .main) {
                // Create and return the PostModel
                let postID = url.lastPathComponent.components(separatedBy: "?").first ?? "unknown_id"
                
                let postModel = PostModel(
                    id: postID,
                    video: videoData,
                    image: postImage,
                    ownerImage: ownerImage,
                    owner: ownerName,
                    postDescription: caption,
                    link: url.absoluteString,
                    cratedAt: createdAt
                )
                
                completion(.success(postModel))
            }
            
        } catch {
            print("HTML Parsing error: \(error.localizedDescription)")
            print("URL was: \(url.absoluteString)")
            completion(.failure(ParserError.cannotParseResponse(detail: error.localizedDescription)))
        }
    }
    
    /// Attempts to find a match using multiple regex patterns
    private func findFirstMatch(from html: String, patterns: [String]) throws -> String {
        for pattern in patterns {
            if let result = try? extractString(from: html, pattern: pattern) {
                return result
            }
        }
        throw ParserError.dataNotFound
    }
    
    /// Extracts string data based on a regex pattern
    private func extractString(from html: String, pattern: String) throws -> String {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            throw ParserError.regexError
        }
        
        guard let match = regex.firstMatch(in: html, options: [], range: NSRange(location: 0, length: html.count)) else {
            throw ParserError.dataNotFound
        }
        
        guard let range = Range(match.range(at: 1), in: html) else {
            throw ParserError.rangeError
        }
        
        return String(html[range])
    }
    
    /// Downloads an image from a URL string
    private func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil,
                  let data = data,
                  let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            completion(image)
        }
        
        task.resume()
    }
    
    // MARK: - Error Definitions
    enum ParserError: Error, LocalizedError {
        case invalidURL
        case invalidResponse
        case invalidData
        case dataNotFound
        case regexError
        case rangeError
        case cannotParseResponse(detail: String)
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "The Instagram URL is invalid."
            case .invalidResponse:
                return "Instagram returned an invalid response."
            case .invalidData:
                return "The data received from Instagram is invalid."
            case .dataNotFound:
                return "The required data was not found in the Instagram post."
            case .regexError:
                return "An error occurred with the regular expression pattern."
            case .rangeError:
                return "An error occurred with the content extraction."
            case .cannotParseResponse(let detail):
                return "Cannot parse Instagram response: \(detail)"
            }
        }
    }
}
