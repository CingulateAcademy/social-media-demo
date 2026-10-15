import UIKit

class ProfileViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .plain)
    private var userPosts: [Post] = []
    
    // Header views
    private let headerContainer = UIView()
    private let coverView = UIView()
    private let avatarView = UIView()
    private let avatarLabel = UILabel()
    private let nameLabel = UILabel()
    private let handleLabel = UILabel()
    private let bioLabel = UILabel()
    private let statsStack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        
        setupTableView()
        setupHeader()
        loadUserPosts()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadUserPosts), name: .postsDidUpdate, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func loadUserPosts() {
        userPosts = PostStore.shared.userPosts()
        tableView.reloadData()
        // Update post count in stats
        if let postsLabel = statsStack.arrangedSubviews.first?.subviews.first as? UILabel {
            postsLabel.text = "\(userPosts.count)"
        }
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGroupedBackground
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.reuseID)
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Header height will be set after layout
        tableView.tableHeaderView = headerContainer
    }

    private func setupHeader() {
        headerContainer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 320)
        
        // Cover – adapts to light/dark with a subtle gradient feel
        coverView.backgroundColor = UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor.systemIndigo.withAlphaComponent(0.7) : .systemBlue
        }
        coverView.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(coverView)
        
        // Avatar
        avatarView.backgroundColor = .systemIndigo
        avatarView.layer.cornerRadius = 48
        avatarView.layer.borderWidth = 4
        avatarView.layer.borderColor = UIColor.systemBackground.cgColor
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(avatarView)
        
        avatarLabel.text = "G"
        avatarLabel.font = .systemFont(ofSize: 36, weight: .bold)
        avatarLabel.textColor = .white
        avatarLabel.textAlignment = .center
        avatarLabel.translatesAutoresizingMaskIntoConstraints = false
        avatarView.addSubview(avatarLabel)
        
        nameLabel.text = "Cingulate Developer"
        nameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        handleLabel.text = "@cingulate_dev"
        handleLabel.font = .systemFont(ofSize: 16)
        handleLabel.textColor = .secondaryLabel
        handleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        bioLabel.text = "Building thoughtful interfaces with UIKit.\nDesign systems · Accessibility · Craft"
        bioLabel.font = .systemFont(ofSize: 15)
        bioLabel.textAlignment = .center
        bioLabel.numberOfLines = 0
        bioLabel.textColor = .secondaryLabel
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Stats
        statsStack.axis = .horizontal
        statsStack.distribution = .equalSpacing
        statsStack.translatesAutoresizingMaskIntoConstraints = false
        
        let statsData = [("0", "Posts"), ("1.2K", "Followers"), ("340", "Following")]
        for (value, title) in statsData {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.alignment = .center
            stack.spacing = 2
            
            let valueLabel = UILabel()
            valueLabel.text = value
            valueLabel.font = .systemFont(ofSize: 17, weight: .bold)
            
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = .systemFont(ofSize: 13)
            titleLabel.textColor = .secondaryLabel
            
            stack.addArrangedSubview(valueLabel)
            stack.addArrangedSubview(titleLabel)
            statsStack.addArrangedSubview(stack)
        }
        
        headerContainer.addSubview(nameLabel)
        headerContainer.addSubview(handleLabel)
        headerContainer.addSubview(statsStack)
        headerContainer.addSubview(bioLabel)
        
        NSLayoutConstraint.activate([
            coverView.topAnchor.constraint(equalTo: headerContainer.topAnchor),
            coverView.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor),
            coverView.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor),
            coverView.heightAnchor.constraint(equalToConstant: 130),
            
            avatarView.centerXAnchor.constraint(equalTo: headerContainer.centerXAnchor),
            avatarView.centerYAnchor.constraint(equalTo: coverView.bottomAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 96),
            avatarView.heightAnchor.constraint(equalToConstant: 96),
            
            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 14),
            nameLabel.centerXAnchor.constraint(equalTo: headerContainer.centerXAnchor),
            
            handleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            handleLabel.centerXAnchor.constraint(equalTo: headerContainer.centerXAnchor),
            
            statsStack.topAnchor.constraint(equalTo: handleLabel.bottomAnchor, constant: 18),
            statsStack.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 48),
            statsStack.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -48),
            
            bioLabel.topAnchor.constraint(equalTo: statsStack.bottomAnchor, constant: 16),
            bioLabel.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 32),
            bioLabel.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -32),
            bioLabel.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: -20)
        ])
        
        // Force layout so tableHeaderView has correct height
        headerContainer.layoutIfNeeded()
        let height = headerContainer.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        headerContainer.frame.size.height = height
        tableView.tableHeaderView = headerContainer
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userPosts.isEmpty ? 1 : userPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if userPosts.isEmpty {
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            var config = cell.defaultContentConfiguration()
            config.text = "No posts yet"
            config.secondaryText = "Tap the + button to share something"
            config.textProperties.alignment = .center
            config.secondaryTextProperties.alignment = .center
            config.textProperties.color = .secondaryLabel
            cell.contentConfiguration = config
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.reuseID, for: indexPath) as! PostCell
        cell.configure(with: userPosts[indexPath.row])
        return cell
    }
}
