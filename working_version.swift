import Cocoa

class QuackApp: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusItem.button?.title = "🦆"
        statusItem.button?.action = #selector(duckClicked)
        statusItem.button?.target = self
    }
    
    @objc func duckClicked() {
        showEmojiSelector()
    }
    
    func showEmojiSelector() {
        showEmojiWindow()
    }
    
    func showEmojiWindow() {
        let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width:500, height: 580),
                             styleMask: [.titled, .closable, .resizable],
                             backing: .buffered,
                             defer: false)
        window.title = "🦆 QuackQuack - Select Emoji"
        window.center()
        
        let contentView = NSView(frame: window.contentView!.bounds)
        window.contentView = contentView
        
        // Scroll view for emojis (reduced height to make room for credits)
        let scrollView = NSScrollView(frame: NSRect(x: 20, y: 50, width: 460, height: 510))
        scrollView.hasVerticalScroller = true
        scrollView.autohidesScrollers = false
        contentView.addSubview(scrollView)
        
        // Add credits text at the bottom
        let creditsLabel = NSTextField(frame: NSRect(x: 20, y: 20, width: 460, height: 20))
        creditsLabel.stringValue = "Created by Jesse & Christine ❤️"
        creditsLabel.isEditable = false
        creditsLabel.isBordered = false
        creditsLabel.backgroundColor = NSColor.clear
        creditsLabel.textColor = NSColor.secondaryLabelColor
        creditsLabel.font = NSFont.systemFont(ofSize: 12)
        creditsLabel.alignment = .center
        contentView.addSubview(creditsLabel)
        
        // Create emoji grid with all emojis
        createEmojiGrid(in: scrollView, searchTerm: "")
        
        // Store references
        objc_setAssociatedObject(self, "scrollView", scrollView, .OBJC_ASSOCIATION_RETAIN)
        objc_setAssociatedObject(self, "window", window, .OBJC_ASSOCIATION_RETAIN)
        
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    
    func createEmojiGrid(in scrollView: NSScrollView, searchTerm: String) {
        let allEmojis = [
            "😀", "😃", "😄", "😁", "😆", "😅", "🤣", "😂", "🙂", "🙃", "😉", "😊", "😇", "🥰", "😍", "🤩", "😘", "😗", "☺️", "😚",
            "😙", "🥲", "😋", "😛", "😜", "🤪", "😝", "🤑", "🤗", "🤭", "🤫", "🤔", "🤐", "🤨", "😐", "😑", "😶", "😏", "😒", "🙄",
            "😬", "🤥", "😌", "😔", "😪", "🤤", "😴", "😷", "🤒", "🤕", "🤢", "🤮", "🤧", "🥵", "🥶", "🥴", "😵", "🤯", "🤠", "🥳",
            "🥸", "😎", "🤓", "🧐", "😕", "😟", "🙁", "☹️", "😮", "😯", "😲", "😳", "🥺", "😦", "😧", "😨", "😰", "😥", "😢", "😭",
            "😱", "😖", "😣", "😞", "😓", "😩", "😫", "🥱", "😤", "😡", "😠", "🤬", "😈", "👿", "💀", "☠️", "💩", "🤡", "👹", "👺",
            "👻", "👽", "👾", "🤖", "😺", "😸", "😹", "😻", "😼", "😽", "🙀", "😿", "😾", "❤️", "🧡", "💛", "💚", "💙", "💜", "🤎",
            "🖤", "🤍", "💯", "💢", "💥", "💫", "💦", "💨", "🕳️", "💣", "💬", "👁️‍🗨️", "🗨️", "🗯️", "💭", "💤", "👋", "🤚", "🖐️", "✋",
            "🖖", "👌", "🤌", "🤏", "✌️", "🤞", "🤟", "🤘", "🤙", "👈", "👉", "👆", "🖕", "👇", "☝️", "👍", "👎", "✊", "👊", "🤛",
            "🤜", "👏", "🙌", "👐", "🤲", "🤝", "🙏", "✍️", "💅", "🤳", "💪", "🦾", "🦿", "🦵", "🦶", "👂", "🦻", "👃", "🧠", "🫀",
            "🫁", "🦷", "🦴", "👀", "👁️", "👅", "👄", "💋", "🩸", "👶", "🧒", "👦", "👧", "🧑", "👱", "👨", "🧔", "👩", "🧓", "👴",
            "👵", "🙍", "🙎", "🙅", "🙆", "💁", "🙋", "🧏", "🙇", "🤦", "🤷", "👮", "🕵️", "💂", "🥷", "👷", "🤴", "👸", "👳", "👲",
            "🧕", "🤵", "👰", "🤰", "🤱", "👼", "🎅", "🤶", "🦸", "🦹", "🧙", "🧚", "🧛", "🧜", "🧝", "🧞", "🧟", "💆", "💇", "🚶",
            "🏃", "💃", "🕺", "🕴️", "👯", "🧖", "🧗", "🏇", "⛷️", "🏂", "🏌️", "🏄", "🚣", "🏊", "⛹️", "🏋️", "🚴", "🚵", "🤸", "🤼",
            "🤽", "🤾", "🤹", "🧘", "🛀", "🛌", "👭", "👫", "👬", "💏", "💑", "👪", "👨‍👩‍👧", "👨‍👩‍👧‍👦", "👨‍👩‍👦‍👦", "👨‍👩‍👧‍👧", "👨‍👦", "👨‍👦‍👦", "👨‍👧", "👨‍👧‍👦",
            "👨‍👧‍👧", "👩‍👦", "👩‍👦‍👦", "👩‍👧", "👩‍👧‍👦", "👩‍👧‍👧", "🗣️", "👤", "👥", "🫂", "👣", "🐵", "🐒", "🦍", "🦧", "🐶",
            "🐕", "🦮", "🐕‍🦺", "🐩", "🐺", "🦊", "🦝", "🐱", "🐈", "🐈‍⬛", "🦁", "🐯", "🐅", "🐆", "🐴", "🐎", "🦄", "🦓", "🦌", "🦬",
            "🐮", "🐂", "🐃", "🐄", "🐷", "🐖", "🐗", "🐽", "🐏", "🐑", "🐐", "🐪", "🐫", "🦙", "🦒", "🐘", "🦣", "🦏", "🦛", "🐭",
            "🐁", "🐀", "🐹", "🐰", "🐇", "🐿️", "🦫", "🦔", "🦇", "🐻", "🐻‍❄️", "🐨", "🐼", "🦥", "🦦", "🦨", "🦘", "🦡", "🐾", "🦃",
            "🐔", "🐓", "🐣", "🐤", "🐥", "🐦", "🐧", "🕊️", "🦅", "🦆", "🦢", "🦉", "🦤", "🪶", "🦩", "🦚", "🦜", "🐸", "🐊", "🐢",
            "🦎", "🐍", "🐲", "🐉", "🦕", "🦖", "🐳", "🐋", "🐬", "🦭", "🐟", "🐠", "🐡", "🦈", "🐙", "🐚", "🐌", "🦋", "🐛", "🐜",
            "🐝", "🪲", "🐞", "🦗", "🕷️", "🦂", "🦟", "🪰", "🪱", "🦠", "💐", "🌸", "💮", "🏵️", "🌹", "🥀", "🌺", "🌻", "🌼", "🌷",
            "🌱", "🪴", "🌲", "🌳", "🌴", "🌵", "🌶️", "🫑", "🥒", "🥬", "🥦", "🧄", "🧅", "🍄", "🥜", "🌰", "🍞", "🥐", "🥖", "🫓",
            "🥨", "🥯", "🥞", "🧇", "🧀", "🍖", "🍗", "🥩", "🥓", "🍔", "🍟", "🍕", "🌭", "🥪", "🌮", "🌯", "🫔", "🥙", "🧆", "🥚",
            "🍳", "🥘", "🍲", "🫕", "🥣", "🥗", "🍿", "🧈", "🧂", "🥫", "🍱", "🍘", "🍙", "🍚", "🍛", "🍜", "🍝", "🍠", "🍢", "🍣",
            "🍤", "🍥", "🥮", "🍡", "🥟", "🥠", "🥡", "🦀", "🦞", "🦐", "🦑", "🦪", "🍆", "🍅", "🥑", "🌽", "🌶️", "🫒", "🥕", "🧄",
            "🧅", "🥔", "🍠", "🥐", "🥖", "🍞", "🥨", "🧀", "🥚", "🍳", "🧈", "🥞", "🧇", "🥓", "🥩", "🍗", "🍖", "🌭", "🍔", "🍟",
            "🍕", "🥪", "🥙", "🧆", "🌮", "🌯", "🫔", "🥗", "🥘", "🫕", "🥫", "🍝", "🍜", "🍲", "🍛", "🍣", "🍱", "🥟", "🦪", "🍤",
            "🍙", "🍚", "🍘", "🍥", "🥠", "🥮", "🍢", "🍡", "🍧", "🍨", "🍦", "🥧", "🧁", "🍰", "🎂", "🍮", "🍭", "🍬", "🍫", "🍿",
            "🍩", "🍪", "🌰", "🥜", "🍯", "🥛", "🍼", "☕", "🫖", "🍵", "🧃", "🥤", "🧋", "🍶", "🍾", "🍷", "🍸", "🍹", "🧉", "🍺",
            "🍻", "🥂", "🥃", "🥤", "🧊", "🥢", "🍽️", "🍴", "🥄", "🔪", "🏺", "⚽", "🏀", "🏈", "⚾", "🥎", "🎾", "🏐", "🏉",
            "🥏", "🎱", "🪀", "🏓", "🏸", "🏑", "🏒", "🥍", "🏏", "🪃", "🥅", "⛳", "🪁", "🏹", "🎣", "🤿", "🥊", "🥋", "🎽",
            "🛹", "🛷", "⛸️", "🥌", "🎿", "⛷️", "🏂", "🪂", "🏋️", "🤸", "🤺", "🤾", "🏌️", "🧘", "🏇", "🏊", "🏄", "🚣", "🧗", "🚵",
            "🚴", "🏆", "🥇", "🥈", "🥉", "🏅", "🎖️", "🎗️", "🎫", "🎟️", "🎪", "🤹", "🎭", "🩰", "🎨", "🎬", "🎤", "🎧", "🎼",
            "🎵", "🎶", "🥁", "🪘", "🎹", "🥖", "🎺", "🎷", "🎸", "🪕", "🎻", "🎲", "♟️", "🎯", "🎳", "🎮", "🎰", "🧩", "🚗",
            "🚕", "🚙", "🚌", "🚎", "🏎️", "🚓", "🚑", "🚒", "🚐", "🛻", "🚚", "🚛", "🚜", "🏍️", "🛵", "🚲", "🛴", "🛼", "🛹", "🚁",
            "🛸", "🚀", "🛰️", "💺", "🛶", "⛵", "🚤", "🛥️", "🛳️", "⛴️", "🚢", "⚓", "⛽", "🚧", "🚦", "🚥", "🚏", "🗺️", "🗿",
            "🗽", "🗼", "🏰", "🏯", "🏟️", "🎡", "🎢", "🎠", "⛱️", "🏖️", "🏝️", "🏜️", "🌋", "⛰️", "🏔️", "🗻", "🏕️", "⛺", "🛖",
            "🏠", "🏡", "🏘️", "🏚️", "🏗️", "🏭", "🏢", "🏬", "🏣", "🏤", "🏥", "🏦", "🏨", "🏪", "🏫", "🏩", "💒", "🏛️", "⛪",
            "🕌", "🛕", "🕍", "⛩️", "🕋", "⛲", "⛱️", "🌁", "🌃", "🏙️", "🌄", "🌅", "🌆", "🌇", "🌉", "♨️", "🎠", "🎡", "🎢",
            "💈", "🎪", "🚂", "🚃", "🚄", "🚅", "🚆", "🚇", "🚈", "🚉", "🚊", "🚝", "🚞", "🚋", "🚌", "🚍", "🚎", "🚐", "🚑",
            "🚒", "🚓", "🚔", "🚕", "🚖", "🚗", "🚘", "🚙", "🚚", "🚛", "🚜", "🏎️", "🏍️", "🛵", "🦽", "🦼", "🛺", "🚲", "🛴",
            "🛹", "🛼", "🚁", "🛸", "🚀", "🛰️", "💎", "💍", "💄", "👑", "👒", "🎩", "🎓", "🧢", "👢", "👡", "👠", "👞",
            "👟", "🥾", "🥿", "👯", "🧦", "🧤", "🧣", "🧥", "👗", "👔", "👕", "👖", "🧳", "☂️", "🌂", "💼", "👜", "👝",
            "🎒", "👛", "👕", "👖", "👗", "👘", "🥻", "🩴", "👙", "👚", "👛", "👜", "👝", "🎒", "👞", "👟", "🥾", "🥿",
            "👠", "👡", "👢", "👑", "👒", "🎩", "🎓", "🧢", "⛑️", "📱", "📲", "💻", "⌨️", "🖥️", "🖨️", "🖱️", "🖲️", "🕹️",
            "🗜️", "💽", "💾", "💿", "📀", "📼", "📷", "📸", "📹", "🎥", "📽️", "🎞️", "📞", "☎️", "📟", "📠", "📺", "📻",
            "🎙️", "🎚️", "🎛️", "⏱️", "⏲️", "⏰", "🕰️", "⌛", "⏳", "📡", "🔋", "🔌", "💡", "🔦", "🕯️", "🪔", "🧯", "🛢️",
            "💸", "💵", "💴", "💶", "💷", "💰", "💳", "💎", "⚖️", "🔧", "🔨", "⚒️", "🛠️", "⛏️", "🔩", "⚙️", "⛓️", "🔫", "💣"
        ]
        
        let emojiKeywords: [String: String] = [
            "😀": "grin happy smile face",
            "😃": "smiley happy joy face",
            "😄": "smile happy laugh face",
            "😁": "grin happy beam face",
            "😆": "laughing happy haha face",
            "😅": "sweat laugh nervous face",
            "🤣": "rofl rolling laughing face",
            "😂": "tears joy cry laugh face",
            "🙂": "slight smile happy face",
            "🙃": "upside down silly face",
            "😉": "wink flirt face",
            "😊": "blush happy smile face",
            "😇": "innocent angel halo face",
            "🥰": "love hearts adore heart face",
            "😍": "heart eyes love face",
            "🤩": "star eyes wow face",
            "😘": "kiss love face",
            "😗": "kiss pucker face",
            "☺️": "smile happy face",
            "😚": "kiss closed eyes face",
            "🦆": "duck quack bird animal",
            "❤️": "red heart love romance",
            "💛": "yellow heart love",
            "💚": "green heart love",
            "💙": "blue heart love",
            "💜": "purple heart love",
            "🤎": "brown heart love",
            "🖤": "black heart love",
            "🤍": "white heart love",
            "🧡": "orange heart love",
            "👋": "wave hello goodbye hand",
            "👍": "thumbs up good yes hand",
            "👎": "thumbs down bad no hand",
            "🔥": "fire hot flame",
            "💯": "100 hundred perfect",
            "⭐": "star favorite",
            "⚡": "lightning bolt electric",
            "🌟": "star sparkle shine",
            "🎉": "party celebrate",
            "🎊": "confetti party",
            "🎈": "balloon party",
            "🎂": "cake birthday",
            "💐": "flowers bouquet",
            "🌹": "rose flower",
            "🌸": "cherry blossom flower",
            "🌺": "hibiscus flower",
            "🌻": "sunflower flower",
            "🌷": "tulip flower"
        ]
        
        let filteredEmojis: [String]
        if searchTerm.isEmpty {
            filteredEmojis = allEmojis
        } else {
            filteredEmojis = allEmojis.filter { emoji in
                let keywords = emojiKeywords[emoji] ?? ""
                return keywords.contains(searchTerm) || emoji.contains(searchTerm)
            }
        }
        
        let contentView = NSView()
        let itemsPerRow = 8
        let itemSize: CGFloat = 44
        let spacing: CGFloat = 8
        let padding: CGFloat = 12
        
        let rowCount = (filteredEmojis.count + itemsPerRow - 1) / itemsPerRow
        let totalHeight = CGFloat(rowCount) * (itemSize + spacing) + padding * 2
        let totalWidth = CGFloat(itemsPerRow) * (itemSize + spacing) + padding * 2
        
        contentView.frame = NSRect(x: 0, y: 0, width: max(totalWidth, 300), height: max(totalHeight, 100))
        
        for (index, emoji) in filteredEmojis.enumerated() {
            let row = index / itemsPerRow
            let col = index % itemsPerRow
            
            let x = padding + CGFloat(col) * (itemSize + spacing)
            let y = totalHeight - padding - CGFloat(row + 1) * (itemSize + spacing)
            
            let button = NSButton(frame: NSRect(x: x, y: y, width: itemSize, height: itemSize))
            button.title = emoji
            button.bezelStyle = .rounded
            button.target = self
            button.action = #selector(emojiButtonClicked(_:))
            button.font = NSFont.systemFont(ofSize: 28)
            button.isBordered = false
            
            contentView.addSubview(button)
        }
        
        scrollView.documentView = contentView
    }
    
    @objc func emojiButtonClicked(_ sender: NSButton) {
        let emoji = sender.title
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(emoji, forType: .string)
        
        // Show green flash feedback
        showGreenFlash(at: sender.frame.origin, in: sender.superview!)
        
        // Close the window after a brief delay to show the flash
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if let window = objc_getAssociatedObject(self, "window") as? NSWindow {
                window.close()
            }
        }
    }
    
    func showGreenFlash(at point: NSPoint, in parentView: NSView) {
        // Create green checkmark emoji
        let checkmarkLabel = NSTextField(frame: NSRect(x: point.x + 10, y: point.y + 10, width: 24, height: 24))
        checkmarkLabel.stringValue = "✅"
        checkmarkLabel.isEditable = false
        checkmarkLabel.isBordered = false
        checkmarkLabel.backgroundColor = NSColor.clear
        checkmarkLabel.font = NSFont.systemFont(ofSize: 20)
        checkmarkLabel.alignment = .center
        checkmarkLabel.alphaValue = 0.0
        
        parentView.addSubview(checkmarkLabel)
        
        // Animate flash
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.15
            checkmarkLabel.animator().alphaValue = 1.0
        }, completionHandler: {
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.15
                checkmarkLabel.animator().alphaValue = 0.0
            }, completionHandler: {
                checkmarkLabel.removeFromSuperview()
            })
        })
    }
}

let app = NSApplication.shared
let delegate = QuackApp()
app.delegate = delegate

// Set the app name properly
if let bundle = Bundle.main.infoDictionary {
    // This won't work for Swift scripts, but we can try other approaches
}

// Alternative: Set process name
ProcessInfo.processInfo.processName = "QuackQuack"

app.setActivationPolicy(.regular)
app.run()