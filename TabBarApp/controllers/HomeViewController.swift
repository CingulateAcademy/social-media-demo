import UIKit

class HomeViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .plain)
    private var posts: [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .systemGroupedBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]

        setupTableView()
        loadPosts()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadPosts), name: .postsDidUpdate, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func loadPosts() {
        posts = PostStore.shared.allPosts()
        tableView.reloadData()
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGroupedBackground
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.reuseID)
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 20, right: 0)
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { posts.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.reuseID, for: indexPath) as! PostCell
        cell.configure(with: posts[indexPath.row])
        return cell
    }
}

class PostCell: UITableViewCell {
    static let reuseID = "PostCell"
    
    private let cardView = UIView()
    private let avatarView = UIView()
    private let avatarLabel = UILabel()
    private let nameLabel = UILabel()
    private let handleLabel = UILabel()
    private let timeLabel = UILabel()
    private let bodyLabel = UILabel()
    private let likeButton = UIButton(type: .system)
    private let commentButton = UIButton(type: .system)
    private let shareButton = UIButton(type: .system)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        // Card
        cardView.backgroundColor = .secondarySystemGroupedBackground
        cardView.layer.cornerRadius = 16
        cardView.layer.cornerCurve = .continuous
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)
        
        // Avatar
        avatarView.layer.cornerRadius = 22
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(avatarView)
        
        avatarLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        avatarLabel.textColor = .white
        avatarLabel.textAlignment = .center
        avatarLabel.translatesAutoresizingMaskIntoConstraints = false
        avatarView.addSubview(avatarLabel)
        
        // Name + Handle + Time
        nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        handleLabel.font = .systemFont(ofSize: 14, weight: .regular)
        handleLabel.textColor = .secondaryLabel
        handleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        timeLabel.font = .systemFont(ofSize: 14, weight: .regular)
        timeLabel.textColor = .tertiaryLabel
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Body
        bodyLabel.font = .systemFont(ofSize: 16, weight: .regular)
        bodyLabel.numberOfLines = 0
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Action buttons
        configureActionButton(likeButton, systemName: "heart", title: "")
        configureActionButton(commentButton, systemName: "bubble.right", title: "")
        configureActionButton(shareButton, systemName: "square.and.arrow.up", title: "")
        
        let headerStack = UIStackView(arrangedSubviews: [nameLabel, handleLabel, timeLabel])
        headerStack.axis = .horizontal
        headerStack.spacing = 6
        headerStack.alignment = .center
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        
        let actionsStack = UIStackView(arrangedSubviews: [likeButton, commentButton, shareButton])
        actionsStack.axis = .horizontal
        actionsStack.spacing = 28
        actionsStack.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(headerStack)
        cardView.addSubview(bodyLabel)
        cardView.addSubview(actionsStack)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            avatarView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            avatarView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            avatarView.widthAnchor.constraint(equalToConstant: 44),
            avatarView.heightAnchor.constraint(equalToConstant: 44),
            
            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            
            headerStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 18),
            headerStack.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 12),
            headerStack.trailingAnchor.constraint(lessThanOrEqualTo: cardView.trailingAnchor, constant: -16),
            
            bodyLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 12),
            bodyLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            bodyLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            actionsStack.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 14),
            actionsStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            actionsStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])
    }
    
    private func configureActionButton(_ button: UIButton, systemName: String, title: String) {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: systemName)
        config.imagePadding = 6
        config.baseForegroundColor = .secondaryLabel
        config.contentInsets = .zero
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configure(with post: Post) {
        avatarView.backgroundColor = post.avatarColor
        avatarLabel.text = String(post.username.prefix(1))
        nameLabel.text = post.username
        handleLabel.text = post.handle
        timeLabel.text = "· \(post.timeAgo)"
        bodyLabel.text = post.text
        likeButton.configuration?.title = " \(post.likes)"
        commentButton.configuration?.title = " \(post.comments)"
    }
}
