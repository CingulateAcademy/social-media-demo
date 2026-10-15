import UIKit

struct Post: Codable, Equatable {
    let id: UUID
    let username: String
    let handle: String
    let text: String
    let timestamp: Date
    var likes: Int
    var comments: Int
    let avatarColorHex: String

    var avatarColor: UIColor {
        UIColor(hex: avatarColorHex) ?? .systemBlue
    }

    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
}


final class PostStore {
    static let shared = PostStore()
    private let key = "com.socialapp.posts"
    private var posts: [Post] = []

    private init() {
        load()
        if posts.isEmpty {
            seedSamplePosts()
        }
    }

    func allPosts() -> [Post] {
        posts.sorted { $0.timestamp > $1.timestamp }
    }

    func userPosts(handle: String = "@cingulate_dev") -> [Post] {
        posts.filter { $0.handle == handle }
             .sorted { $0.timestamp > $1.timestamp }
    }

    func add(_ post: Post) {
        posts.insert(post, at: 0)
        save()
        NotificationCenter.default.post(name: .postsDidUpdate, object: nil)
    }

    private func save() {
        if let data = try? JSONEncoder().encode(posts) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([Post].self, from: data) else { return }
        posts = decoded
    }

    private func seedSamplePosts() {
        let samples: [Post] = [
            Post(id: UUID(), username: "Muhammed Barku", handle: "@muhabaku",
                 text: "Just shipped a major UI overhaul. Clean typography + thoughtful spacing really makes a difference.",
                 timestamp: Date().addingTimeInterval(-7200), likes: 128, comments: 24, avatarColorHex: "#007AFF"),
            Post(id: UUID(), username: "Sam Chen", handle: "@samc",
                 text: "UITabBarController still feels like the most natural navigation pattern for social apps. Agree?",
                 timestamp: Date().addingTimeInterval(-14400), likes: 89, comments: 31, avatarColorHex: "#AF52DE"),
            Post(id: UUID(), username: "Jordan Lee", handle: "@jlee",
                 text: "Morning coffee + deep work session. Building something beautiful today.",
                 timestamp: Date().addingTimeInterval(-21600), likes: 214, comments: 12, avatarColorHex: "#5AC8FA"),
            Post(id: UUID(), username: "Taylor Kim", handle: "@tkim",
                 text: "The best interfaces disappear. Users should feel the content, not the chrome.",
                 timestamp: Date().addingTimeInterval(-28800), likes: 342, comments: 47, avatarColorHex: "#FF9500")
        ]
        posts = samples
        save()
    }
}

extension Notification.Name {
    static let postsDidUpdate = Notification.Name("postsDidUpdate")
}

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255
        let b = CGFloat(rgb & 0x0000FF) / 255
        self.init(red: r, green: g, blue: b, alpha: 1)
    }

    var hexString: String {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(format: "#%02X%02X%02X", Int(r*255), Int(g*255), Int(b*255))
    }
}
