import UIKit

class CreatePostViewController: UIViewController {
    
    private let textView = UITextView()
    private let characterCountLabel = UILabel()
    private let toolbar = UIToolbar()
    private let maxCharacters = 280
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New Post"
        
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post",style: .prominent, target: self, action: #selector(postTapped))
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        
        setupTextView()
        
        setupToolbar()
        
        setupCharacterCount()
    }
    
    
    private func setupTextView(){
        textView.font = .systemFont(ofSize: 18)
        textView.textContainerInset = UIEdgeInsets(top:16, left:12, bottom:16, right:12)
        textView.delegate = self
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(textView)
        
        textView.text = "What's happening?"
        
        textView.textColor = .placeholderText
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textView.heightAnchor.constraint(equalToConstant: 200)
            
        ])
        
    }
    
    
    private func setupToolbar(){
        let photo = UIBarButtonItem(image: UIImage(systemName: "photo"), style: .plain,target: nil, action: nil)
        
        let camera = UIBarButtonItem(image:UIImage(systemName: "camera"), style: .plain,target: nil, action: nil)
        
        let location = UIBarButtonItem(image:UIImage(systemName: "location"), style: .plain,target: nil, action: nil)
        
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.items = [photo,camera,location,flex]
        
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(toolbar)
        
        NSLayoutConstraint.activate([
            toolbar.topAnchor.constraint(equalTo: textView.bottomAnchor),
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        
        
        
    }
    
    
    private func setupCharacterCount(){
        characterCountLabel.font = .monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        characterCountLabel.textColor = .secondaryLabel
        characterCountLabel.text = "280"
        
        characterCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(characterCountLabel)
        
        NSLayoutConstraint.activate([
            characterCountLabel.topAnchor.constraint(equalTo: toolbar.bottomAnchor, constant: 12),
            characterCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            
        ])
        
    }
    
    
    @objc private func postTapped(){
        
        guard let text = textView.text, !text.isEmpty, text != "What's happening" else{return}
        
       let newPost = Post(
        id: UUID(),
        username: "Cingulate Developer",
        handle: "@cingulate_dev",
        text: text,
        timestamp: Date(),
        likes: 0,
        comments: 0,
        avatarColorHex: "#5856D6"
        
       )
        
        PostStore.shared.add(newPost)
        
//        haptic feedback
        
        let generator = UINotificationFeedbackGenerator()
        
        generator.notificationOccurred(.success)
        
        dismiss(animated: true)
        
        
        
    }
    
    @objc private func cancelTapped(){
        dismiss(animated: true)
    }
    

}


extension CreatePostViewController: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderText{
            textView.text = ""
            textView.textColor = .label
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let count = textView.text.count
        
        let remaining = maxCharacters - count
        
        characterCountLabel.text = "\(remaining)"
        
        characterCountLabel.textColor = remaining < 20 ? .systemRed : .secondaryLabel
        navigationItem.rightBarButtonItem?.isEnabled = count > 0 && count <= maxCharacters
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            textView.text = "What's happening?"
            textView.textColor = .placeholderText
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText string: String) -> Bool{
        if string.isEmpty {return true}
        
        if textView.textColor == .placeholderText {return true}
        
        guard let currentText = textView.text,
              let stringRange = Range(range, in: currentText) else {return false}
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        
        return updatedText.count <= maxCharacters
    }
    
    
}










