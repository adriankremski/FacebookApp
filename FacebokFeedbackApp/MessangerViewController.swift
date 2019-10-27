//
//  MessangerViewController.swift
//  FacebokFeedbackApp
//
//  Created by Adrian Kremski on 27/10/2019.
//  Copyright © 2019 Adrian Kremski. All rights reserved.
//

import UIKit

struct ChatMessage {
    let text: String
    let isIncoming: Bool
    let date: Date
}

extension Date {
    static func dateFromCustomString(_ customString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.date(from: customString) ?? Date()
    }
}

class MessangerViewController: UITableViewController {

    fileprivate let cellId = "messageCellId"
    
    let messages = [
        ChatMessage(text: "Here is my first message", isIncoming: true, date: Date.dateFromCustomString("24/07/2020")),
        ChatMessage(text: "Here is my second message", isIncoming: true, date: Date.dateFromCustomString("24/07/2020")),
        ChatMessage(text: "Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.", isIncoming: false, date: Date.dateFromCustomString("26/07/2020")),
        ChatMessage(text: "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga", isIncoming: false, date: Date.dateFromCustomString("26/07/2020")),
        ChatMessage(text: "Another long message that should do a word wrap ", isIncoming: true, date: Date.dateFromCustomString("28/07/2020")),
        ChatMessage(text: "Another long message that should do a word wrap ", isIncoming: true, date: Date.dateFromCustomString("28/07/2020"))
    ]
    
    var chatMessages = [[ChatMessage]]()
    
    fileprivate func attempToAssembleGroupedMessages() {
        let groupedMessages = Dictionary(grouping: messages) { (element) -> Date in
            return Calendar.current.startOfDay(for: element.date)
        }
        
        groupedMessages.keys.sorted().forEach { (date) in
            chatMessages.append(groupedMessages[date] ?? [])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attempToAssembleGroupedMessages()
        
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return chatMessages.count
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = DateHeaderLabel()
        
        if let firstMessageInSection = chatMessages[section].first {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            label.text = "\(dateFormatter.string(from: firstMessageInSection.date))"
        }
        
        
        let containerView = UIView()
        containerView.addSubview(label)
        label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true

        
        return containerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let firstMessageInSection = chatMessages[section].first {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return "\(dateFormatter.string(from: firstMessageInSection.date))"
        } else {
            return ""
        }
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return chatMessages[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        cell.chatMessage = chatMessages[indexPath.section][indexPath.row]
        
        return cell
    }
}

class DateHeaderLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        textColor = .white
        textAlignment = .center
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override var intrinsicContentSize: CGSize {
        let originalContentSize = super.intrinsicContentSize
        let height = originalContentSize.height + 16
        layer.cornerRadius = height / 2
        layer.masksToBounds = true
        return CGSize(width: originalContentSize.width + 20, height: height)
    }
}
