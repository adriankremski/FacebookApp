//
//  ViewController.swift
//  FacebokFeedbackApp
//
//  Created by Adrian Kremski on 25/10/2019.
//  Copyright © 2019 Adrian Kremski. All rights reserved.
//

import UIKit

let cellId = "cellId"

struct Post {
    var name: String?
    var statusText: String?
    var statusImageUrl: String?
    var profileImageName: String?
    var numLikes: Int?
    var numComments: Int?
}

class FeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout{

    private var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let memoryCapacity = 50 * 1024 * 1024
        let diskCapacity = 500 * 1024 * 1024
        let urlCache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity)
        URLCache.shared = urlCache
        
        let postMark = Post(name: "Mark Zuckerberg",
                            statusText: "Some random status text for Mark",
                            statusImageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQJsDFjxUAb2eQkZYBo63yhOYV73F_KhvPtnuWcI8x00WMOy_Vn",
                            profileImageName: "zuck_profile",
                            numLikes: 100,
                            numComments: 100)
        
        let postSteve = Post(name: "Steve Jobs", statusText: "Some random status text for Steve which is very very long but should be displayed in full",
                             statusImageUrl: "https://i.wpimg.pl/O/644x420/d.wpimg.pl/1967451042--1153246732/jobs.jpg",
                             profileImageName: "steve_jobs",
                             numLikes: 1000,
                             numComments: 100)
        
        let postGandhi = Post(name: "Mahatma Gandhi", statusText: "Some random status text for Gandhi which is very very long but should be displayed in full, XKJhkjdlhfj adajdkhsgdkls ghsd kfglhskd fgdhsfgk jsdhlfghs djkfhlsgkdjs ",
                              statusImageUrl: "https://www.hindustantimes.com/rf/image_size_960x540/HT/p2/2019/09/15/Pictures/resistance-national-archived-opposition-satyagraha-syndicated-peaceful_8b0f1afc-d7db-11e9-98d7-43b78744c7ea.jpg",
                              profileImageName: "gandi",
                              numLikes: 100,
                              numComments: 200)
        
        posts.append(postMark)
        posts.append(postSteve)
        posts.append(postGandhi)
        posts.append(postMark)
        posts.append(postSteve)
        posts.append(postGandhi)
        posts.append(postMark)
        posts.append(postSteve)
        posts.append(postGandhi)
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        
        navigationItem.title = "Facebook Feed"
        
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        // Do any additional setup after loading the view.
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
        
        cell.post = posts[indexPath.row]
        cell.feedController = self
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let statusText = posts[indexPath.row].statusText {
            let size = CGSize(width: view.frame.width, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
            
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(14))]
            let rect = NSString(string: statusText).boundingRect(with: size, options: options, attributes: attributes, context: nil)
            
            let knownHeight : CGFloat = 8 + 44 + 4 + 4 + 200 + 8 + 24 + 8 + 44 + 24
            
            return CGSize(width: view.frame.width, height: knownHeight + rect.height)
        }
        
        return CGSize(width: view.frame.width, height: 400)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    let blackBacgroundView = UIView()
    var statusImageView: UIImageView?
    var zoomImageView: UIImageView?
    var navBarCoverView = UIView()
    var tabBarCoverView = UIView()
    
    func animateImageView(_ statusImageView: UIImageView) {
        self.statusImageView = statusImageView
        
        if let startingFrame = statusImageView.superview?.convert(statusImageView.frame, to: nil) {
            zoomImageView = UIImageView()
            
            statusImageView.alpha = 0
            
            blackBacgroundView.frame = self.view.frame
            blackBacgroundView.backgroundColor = .black
            blackBacgroundView.alpha = 0
            view.addSubview(blackBacgroundView)
                    
            navBarCoverView.frame = CGRect(x:0, y: 0, width: 1000, height: 100)
            navBarCoverView.backgroundColor = UIColor.black
            navBarCoverView.alpha = 0
            
            if let keyWindow = UIApplication.shared.keyWindow {
                keyWindow.addSubview(navBarCoverView)
                
                tabBarCoverView.frame = CGRect(x: 0, y: keyWindow.frame.height - 90, width: 1000, height: 90)
                tabBarCoverView.backgroundColor = UIColor.black
                tabBarCoverView.alpha = 0
                keyWindow.addSubview(tabBarCoverView)
            }
            
            zoomImageView!.backgroundColor = UIColor.red
            zoomImageView!.frame = startingFrame
            zoomImageView!.isUserInteractionEnabled = true
            zoomImageView!.image = statusImageView.image
            zoomImageView!.contentMode = .scaleAspectFill
            zoomImageView!.clipsToBounds = true
            view.addSubview(zoomImageView!)
            
            zoomImageView!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOut)))
            
            UIView.animate(withDuration: 0.75) {
                let width = self.view.frame.width
                let height = startingFrame.height * (width / startingFrame.width)
                
                let y = self.view.frame.height / 2 - height / 2
                self.zoomImageView!.frame = CGRect(x: 0, y: y, width: width, height: height)
                
                self.blackBacgroundView.alpha = 1
                self.navBarCoverView.alpha = 1
                self.tabBarCoverView.alpha = 1
            }
        }
    }
    
    @objc func zoomOut() {
        if let startingFrame = statusImageView!.superview?.convert(statusImageView!.frame, to: nil), let zoomImageView = self.zoomImageView {
            UIView.animate(withDuration: 0.75
                , animations: {
                zoomImageView.frame = startingFrame
                self.blackBacgroundView.alpha = 0
                self.navBarCoverView.alpha = 0
                self.tabBarCoverView.alpha = 0
            }) { (didComplete) in
                self.statusImageView?.alpha = 1
                self.tabBarCoverView.removeFromSuperview()
                self.navBarCoverView.removeFromSuperview()
                zoomImageView.removeFromSuperview()
                self.blackBacgroundView.removeFromSuperview()
            }
        }
    }
}

//var imageCache = NSCache<NSString, UIImage>()

class FeedCell: UICollectionViewCell {
    
    var feedController: FeedController?
    
    @objc func animate() {
        feedController?.animateImageView(statusImageView)
    }
    
    var post: Post? {
        didSet {
            if let name = post?.name {
                let attributedText = NSMutableAttributedString(string: name,
                                                               attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: CGFloat(14))])
                
                let subtextAttrs = [
                    NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: CGFloat(12)),
                    NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 155, green: 161, blue: 171)]
                
                attributedText.append(NSAttributedString(string: "\nDecember 18 | San Francisco ", attributes: subtextAttrs))
                
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 4
                
                attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.string.count))
                
                nameLabel.attributedText = attributedText
            }
            
            if let statusText = post?.statusText {
                statusTextView.text = statusText
            }
            
            if let imageName = post?.profileImageName {
                profileImageView.image = UIImage(named: imageName)
            }
            
            if let statusImageUrl = post?.statusImageUrl {
//                if let image = imageCache.object(forKey: NSString(string: statusImageUrl)) {
//                    self.statusImageView.image = image
//                }
                
                URLSession.shared.dataTask(with: URL(string: statusImageUrl)!, completionHandler: { (data, response, error) in
                    if error != nil {
                        print(error)
                        return
                    }
//
//                    let image = UIImage(data: data!)
//
//                    imageCache.setObject(image!, forKey: NSString(string: statusImageUrl))
//
                    let image = UIImage(data: data!)
                    
                    DispatchQueue.main.async {
                        self.statusImageView.image = image
                    }
                    
                }).resume()
            }
            
            if let likesCount = post?.numLikes, let commentsCount = post?.numComments {
                likesCommentsLabel.text = "\(likesCount) Likes  \(commentsCount) Comments"
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not beed implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 2

        return label
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "zuck_profile")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let statusTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: CGFloat(12))
        return textView
    }()
    
    let statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dog")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let likesCommentsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: CGFloat(12))
        label.textColor = UIColor.rgb(red: 155, green: 161, blue: 171)
        return label
    }()
    
    let dividerViewLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 226, green: 228, blue: 232)
        return view
    }()
    
    let likeButton = buttonForTitle(title: "Like", imageName: nil)
    let commentButton = buttonForTitle(title: "Comment", imageName: nil)
    let shareButton = buttonForTitle(title: "Share", imageName: nil)
    
    static func buttonForTitle(title: String, imageName: String?) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.rgb(red: 143, green: 150, blue: 163), for: .normal)
        
//        button.setImage(UIImage(named: "like"), for: .normal)
//        button.titleEdgeInsets = UIEdgeInsets(0, 8, 0, 8)
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(14))
        return button
    }
    
    func setupViews() {
        backgroundColor = UIColor.white
        
        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(statusTextView)
        addSubview(statusImageView)
        addSubview(likesCommentsLabel)
        addSubview(dividerViewLine)
        addSubview(likeButton)
        addSubview(commentButton)
        addSubview(shareButton)
        
        statusImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animate)))
        
        addConstraintsWithFormat(format: "H:|-8-[v0(44)]-8-[v1]|", views: profileImageView, nameLabel)
        addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: statusTextView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: statusImageView)
        
        addConstraintsWithFormat(format: "H:|-12-[v0]|", views: likesCommentsLabel)
        
        addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: dividerViewLine)
        
        // button constraints
        addConstraintsWithFormat(format: "H:|[v0(v1)][v1(v2)][v2]|", views: likeButton, commentButton, shareButton)
    
        addConstraintsWithFormat(format: "V:|-12-[v0]", views: nameLabel)
        
        addConstraintsWithFormat(format: "V:|-8-[v0(44)]-4-[v1]-4-[v2(200)]-8-[v3(24)]-8-[v4(0.4)][v5(44)]|" , views: profileImageView, statusTextView, statusImageView, likesCommentsLabel, dividerViewLine, likeButton)
        
        addConstraintsWithFormat(format: "V:[v0(44)]|", views: commentButton)
        addConstraintsWithFormat(format: "V:[v0(44)]|", views: shareButton)
    }
}

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions (), metrics: nil, views: viewsDictionary))
    }
}
