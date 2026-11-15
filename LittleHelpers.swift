// Little Helpers — pixel pets that run across the screen with gentle reminders.
import AppKit
import QuartzCore

// MARK: - Colours

func rgb(_ r: Int, _ g: Int, _ b: Int) -> NSColor {
    NSColor(srgbRed: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: 1)
}

let ink = rgb(91, 74, 74)        // flag outline and lettering
let pink = rgb(247, 168, 184)

let catPalette: [Character: NSColor] = [
    "o": rgb(22, 19, 28),    // outline
    "k": rgb(54, 48, 66),    // black fur
    "h": rgb(84, 76, 102),   // fur highlight
    "g": rgb(126, 226, 120), // green eyes
    "p": pink,               // ears and nose
]
let dogPalette: [Character: NSColor] = [
    "o": rgb(92, 62, 40),    // outline
    "g": rgb(232, 178, 92),  // golden fur
    "h": rgb(196, 136, 62),  // ear / shade
    "l": rgb(252, 224, 166), // muzzle and feathering
    "e": rgb(48, 34, 28),    // eye and nose
    "p": rgb(247, 150, 170), // tongue
]

// MARK: - Sprites (24 x 16 grid, two running frames each)

let catA = [
    "..............o....o..",
    ".............opoooopo.",
    ".............okkkkkko.",
    "..o..........okgkkgko.",
    ".oko.........okkkkkko.",
    ".oko.........okkppkko.",
    "..oko.oooooooohkkkkko.",
    "...okhhhhhhhhhkoooooo.",
    "....okkkkkkkkkkko.....",
    "....okkkkkkkkkkko.....",
    "....okkkkkkkkkkko.....",
    "...okoooooooookoo.....",
    "..oko.........oko.....",
    ".ooo...........ooo....",
]
let catB = Array(catA[0..<11]) + [
    "....ookoooooookoo.....",
    ".....oko....oko.......",
    ".....ooo....ooo.......",
]
let dogA = [
    "...............oooo.....",
    "..............oggggo....",
    ".............oggggggo...",
    ".............ohgggegoooo",
    ".............ohhgggglllo",
    ".............ohhggglllle",
    ".............ohhhggooooo",
    ".............ohhhgggpo..",
    "..oo.........oohhggggo..",
    ".ogho..ooooooooogggggo..",
    ".ohhgooggggggggggggggo..",
    "..ohggggggggggggggggo...",
    "...oggggggggggggggggo...",
    "....olllllllllllllllo...",
    "...ogo..........ogo.....",
    "..ooo..........ooo......",
]
let dogB = Array(dogA[0..<14]) + [
    "....ogo.......ogo.......",
    "....ooo.......ooo.......",
]

enum Animal: String {
    case cat, dog
    var frames: [[String]] { self == .cat ? [catA, catB] : [dogA, dogB] }
    var palette: [Character: NSColor] { self == .cat ? catPalette : dogPalette }
    var flagColour: NSColor { self == .cat ? rgb(255, 221, 230) : rgb(214, 236, 255) }
    /// Grid row (from the top of the 16-row grid) where the pole disappears behind the back.
    var poleEndRow: Int { self == .cat ? 9 : 10 }
}

// MARK: - Pixel font (9 rows: 2 ascender, 5 x-height, 2 descender)

let pixelFont: [Character: [String]] = [
    "a": ["....", "....", ".##.", "...#", ".###", "#..#", ".###", "....", "...."],
    "b": ["#...", "#...", "###.", "#..#", "#..#", "#..#", "###.", "....", "...."],
    "c": ["...", "...", ".##", "#..", "#..", "#..", ".##", "...", "..."],
    "d": ["...#", "...#", ".###", "#..#", "#..#", "#..#", ".###", "....", "...."],
    "e": ["....", "....", ".##.", "#..#", "####", "#...", ".###", "....", "...."],
    "f": [".##", "#..", "###", "#..", "#..", "#..", "#..", "...", "..."],
    "g": ["....", "....", ".###", "#..#", "#..#", "#..#", ".###", "...#", ".##."],
    "h": ["#...", "#...", "###.", "#..#", "#..#", "#..#", "#..#", "....", "...."],
    "i": ["#", ".", "#", "#", "#", "#", "#", ".", "."],
    "j": ["..#", "...", "..#", "..#", "..#", "..#", "..#", "..#", "##."],
    "k": ["#...", "#...", "#..#", "#.#.", "##..", "#.#.", "#..#", "....", "...."],
    "l": ["#.", "#.", "#.", "#.", "#.", "#.", ".#", "..", ".."],
    "m": [".....", ".....", "####.", "#.#.#", "#.#.#", "#.#.#", "#.#.#", ".....", "....."],
    "n": ["....", "....", "###.", "#..#", "#..#", "#..#", "#..#", "....", "...."],
    "o": ["....", "....", ".##.", "#..#", "#..#", "#..#", ".##.", "....", "...."],
    "p": ["....", "....", "###.", "#..#", "#..#", "#..#", "###.", "#...", "#..."],
    "q": ["....", "....", ".###", "#..#", "#..#", "#..#", ".###", "...#", "...#"],
    "r": ["...", "...", "#.#", "##.", "#..", "#..", "#..", "...", "..."],
    "s": ["....", "....", ".###", "#...", ".##.", "...#", "###.", "....", "...."],
    "t": [".#.", ".#.", "###", ".#.", ".#.", ".#.", "..#", "...", "..."],
    "u": ["....", "....", "#..#", "#..#", "#..#", "#..#", ".###", "....", "...."],
    "v": [".....", ".....", "#...#", "#...#", ".#.#.", ".#.#.", "..#..", ".....", "....."],
    "w": [".....", ".....", "#...#", "#...#", "#.#.#", "#.#.#", ".#.#.", ".....", "....."],
    "x": ["....", "....", "#..#", "#..#", ".##.", "#..#", "#..#", "....", "...."],
    "y": ["....", "....", "#..#", "#..#", "#..#", "#..#", ".###", "...#", ".##."],
    "z": ["....", "....", "####", "..#.", ".#..", "#...", "####", "....", "...."],
    "'": ["#", "#", ".", ".", ".", ".", ".", ".", "."],
    "!": ["#", "#", "#", "#", "#", ".", "#", ".", "."],
    "&": [".##..", "#..#.", "#.#..", ".#...", "#.#.#", "#..#.", ".##.#", ".....", "....."],
    "<": ["...", "...", "..#", ".#.", "#..", ".#.", "..#", "...", "..."],
    "3": ["###.", "...#", "...#", ".##.", "...#", "...#", "###.", "....", "...."],
    "0": [".##.", "#..#", "#..#", "#..#", "#..#", "#..#", ".##.", "....", "...."],
    "1": [".#.", "##.", ".#.", ".#.", ".#.", ".#.", "###", "...", "..."],
    "2": [".##.", "#..#", "...#", "..#.", ".#..", "#...", "####", "....", "...."],
    "4": ["#..#", "#..#", "#..#", "####", "...#", "...#", "...#", "....", "...."],
    "5": ["####", "#...", "###.", "...#", "...#", "#..#", ".##.", "....", "...."],
    "6": [".##.", "#...", "#...", "###.", "#..#", "#..#", ".##.", "....", "...."],
    "7": ["####", "...#", "..#.", "..#.", ".#..", ".#..", ".#..", "....", "...."],
    "8": [".##.", "#..#", "#..#", ".##.", "#..#", "#..#", ".##.", "....", "...."],
    "9": [".##.", "#..#", "#..#", ".###", "...#", "...#", ".##.", "....", "...."],
    "+": ["...", "...", "...", ".#.", "###", ".#.", "...", "...", "..."],
    "-": ["...", "...", "...", "...", "###", "...", "...", "...", "..."],
    ".": [".", ".", ".", ".", ".", ".", "#", ".", "."],
    ",": ["..", "..", "..", "..", "..", "..", ".#", "#.", ".."],
    ":": [".", ".", ".", "#", ".", "#", ".", ".", "."],
    "?": [".##.", "#..#", "...#", "..#.", ".#..", "....", ".#..", "....", "...."],
    " ": ["..", "..", "..", "..", "..", "..", "..", "..", ".."],
]

/// Builds the flag as columns of cells: 0 empty, 1 outline, 2 cloth, 3 lettering.
func buildFlag(_ text: String) -> [[UInt8]] {
    var letterColumns: [[Bool]] = []
    let chars = Array(text.lowercased())
    for (i, ch) in chars.enumerated() {
        let glyph = pixelFont[ch] ?? pixelFont[" "]!
        let rows = glyph.map { Array($0) }
        for x in 0..<rows[0].count {
            letterColumns.append((0..<9).map { rows[$0][x] == "#" })
        }
        if i < chars.count - 1 { letterColumns.append(Array(repeating: false, count: 9)) }
    }

    let height = 15, notch = 6, padLeft = 5, padRight = 4
    let width = 1 + notch + padLeft + letterColumns.count + padRight
    let mid = Double(height - 1) / 2

    func inside(_ c: Int, _ r: Int) -> Bool {
        if c < 0 || c >= width || r < 0 || r >= height { return false }
        if c < notch && abs(Double(r) - mid) < Double(notch - c) * (mid / Double(notch)) { return false }
        return true
    }

    var grid = Array(repeating: Array(repeating: UInt8(0), count: height), count: width)
    for c in 0..<width {
        for r in 0..<height where inside(c, r) {
            let edge = !inside(c + 1, r) || !inside(c - 1, r) || !inside(c, r + 1) || !inside(c, r - 1)
            grid[c][r] = edge ? 1 : 2
        }
    }
    let x0 = 1 + notch + padLeft
    for (i, column) in letterColumns.enumerated() {
        for r in 0..<9 where column[r] { grid[x0 + i][3 + r] = 3 }
    }
    return grid
}

// MARK: - Pixel text (used by the menu)

func pixelGlyph(_ ch: Character) -> [String] {
    pixelFont[ch] ?? pixelFont[" "]!
}

func pixelTextWidth(_ text: String, unit: CGFloat) -> CGFloat {
    var columns = 0
    for ch in text.lowercased() { columns += pixelGlyph(ch)[0].count + 1 }
    return CGFloat(max(columns - 1, 0)) * unit
}

func drawPixelText(_ text: String, x: CGFloat, y: CGFloat, unit: CGFloat, colour: NSColor) {
    colour.setFill()
    var cx = x
    for ch in text.lowercased() {
        let glyph = pixelGlyph(ch)
        for (r, row) in glyph.enumerated() {
            for (c, mark) in row.enumerated() where mark == "#" {
                NSBezierPath(rect: NSRect(x: cx + CGFloat(c) * unit, y: y + CGFloat(r) * unit,
                                          width: unit, height: unit)).fill()
            }
        }
        cx += CGFloat(glyph[0].count + 1) * unit
    }
}

// MARK: - Reminders

final class Reminder {
    var text: String
    var animal: Animal
    var minutes: Int
    var enabled: Bool
    var done: Int            // how many times it was obeyed today
    let custom: Bool         // written by the user (can be deleted)
    var next: Date

    init(_ text: String, _ animal: Animal, minutes: Int,
         enabled: Bool = true, done: Int = 0, custom: Bool = false) {
        self.text = text
        self.animal = animal
        self.minutes = minutes
        self.enabled = enabled
        self.done = done
        self.custom = custom
        self.next = Date().addingTimeInterval(TimeInterval(minutes) * 60)
    }

    func reschedule() { next = Date().addingTimeInterval(TimeInterval(minutes) * 60) }
}

struct SavedReminder: Codable {
    var text: String
    var animal: String
    var minutes: Int
    var enabled: Bool
    var done: Int
    var custom: Bool
}

struct SavedState: Codable {
    var reminders: [SavedReminder]
    var dark: Bool
    var day: String
    var height: String?      // "bottom", "middle" or "custom" (missing in older saves)
    var customY: Double?     // screen height of the pet's middle, for "custom"
}

// MARK: - The drawing (pet + flag)

let px: CGFloat = 4      // one sprite pixel  = 4 points (pet is about 64 pt tall)
let fp: CGFloat = 2      // one flag pixel    = 2 points (lettering stays crisp and readable)
let gridCols = 24
let gridRows = 16

final class HelperView: NSView {
    let animal: Animal
    let flag: [[UInt8]]
    let margin: CGFloat = 12
    var frameIndex = 0
    var bob: CGFloat = 0
    var phase: CGFloat = 0

    var flagW: CGFloat { CGFloat(flag.count) * fp }
    var flagH: CGFloat { CGFloat(flag[0].count) * fp }
    var poleX: CGFloat { margin + flagW }
    var spriteX: CGFloat { poleX - 7 * px }
    var flagTop: CGFloat { margin }
    var spriteTop: CGFloat { flagTop + flagH + 14 }

    init(animal: Animal, text: String) {
        self.animal = animal
        self.flag = buildFlag(text)
        super.init(frame: .zero)
        setFrameSize(NSSize(width: spriteX + CGFloat(gridCols) * px + 4,
                            height: spriteTop + CGFloat(gridRows) * px + 2))
    }

    required init?(coder: NSCoder) { fatalError("not used") }

    override var isFlipped: Bool { true }

    private func cell(_ x: CGFloat, _ y: CGFloat, _ size: CGFloat, _ colour: NSColor) {
        colour.setFill()
        NSBezierPath(rect: NSRect(x: x, y: y, width: size, height: size)).fill()
    }

    override func draw(_ dirtyRect: NSRect) {
        NSGraphicsContext.current?.shouldAntialias = false
        let lift = NSAffineTransform()
        lift.translateX(by: 0, yBy: -bob)
        lift.concat()

        // Pole (its lower end disappears behind the pet's back)
        let poleTop = flagTop - 6
        rgb(150, 112, 92).setFill()
        NSBezierPath(rect: NSRect(x: poleX, y: poleTop, width: px,
                                  height: spriteTop + CGFloat(animal.poleEndRow) * px - poleTop)).fill()

        // Pixel knob on top of the pole
        cell(poleX - fp, poleTop - 3 * fp, 4 * fp, ink)
        cell(poleX, poleTop - 2 * fp, 2 * fp, pink)

        // Flag: every column waves, lettering included; the free end waves most
        let n = flag.count
        for c in 0..<n {
            let amplitude = 2.0 * (1.0 - CGFloat(c) / CGFloat(n))
            let dy = (sin(phase + CGFloat(c) * 0.18) * amplitude).rounded() * fp
            for r in 0..<flag[c].count {
                let v = flag[c][r]
                if v == 0 { continue }
                let colour = v == 2 ? animal.flagColour : ink
                cell(margin + CGFloat(c) * fp, flagTop + CGFloat(r) * fp + dy, fp, colour)
            }
        }

        // Pixel pet
        let rows = animal.frames[frameIndex]
        let offset = gridRows - rows.count
        let palette = animal.palette
        for (r, line) in rows.enumerated() {
            for (c, ch) in line.enumerated() {
                guard let colour = palette[ch] else { continue }
                cell(spriteX + CGFloat(c) * px, spriteTop + CGFloat(r + offset) * px, px, colour)
            }
        }
    }
}

// MARK: - One run across the screen

final class HelperRun {
    let panel: NSPanel
    let view: HelperView
    let fromX: CGFloat
    let toX: CGFloat
    let y: CGFloat
    let speed: CGFloat = 170     // points per second
    let onFinish: () -> Void
    var timer: Timer?
    var startTime: CFTimeInterval = 0

    /// `centreY` is where the middle of the pet should be on screen; nil means the bottom.
    init(animal: Animal, text: String, centreY: CGFloat?, onFinish: @escaping () -> Void) {
        let v = HelperView(animal: animal, text: text)
        let screen = NSScreen.main ?? NSScreen.screens[0]
        let visible = screen.visibleFrame          // excludes the Dock and the menu bar
        let size = v.frame.size
        view = v
        fromX = visible.minX - size.width
        toX = visible.maxX
        if let centre = centreY {
            // The pet's middle sits 2 + 8 sprite pixels (34 pt) above the bottom of its window.
            let wanted = centre - (2 + CGFloat(gridRows) * px / 2)
            y = min(max(wanted, visible.minY), visible.maxY - size.height)
        } else {
            y = visible.minY
        }
        self.onFinish = onFinish

        panel = NSPanel(contentRect: NSRect(x: fromX, y: y, width: size.width, height: size.height),
                        styleMask: [.borderless, .nonactivatingPanel],
                        backing: .buffered, defer: false)
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.hasShadow = false
        panel.level = .statusBar                      // above ordinary windows
        panel.ignoresMouseEvents = true               // clicks pass straight through
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary, .ignoresCycle]
        panel.hidesOnDeactivate = false
        panel.isReleasedWhenClosed = false
        panel.contentView = v
    }

    func start() {
        panel.orderFrontRegardless()
        startTime = CACurrentMediaTime()
        let t = Timer(timeInterval: 1.0 / 60.0, repeats: true) { [weak self] _ in self?.tick() }
        RunLoop.main.add(t, forMode: .common)
        timer = t
    }

    func tick() {
        let elapsed = CGFloat(CACurrentMediaTime() - startTime)
        let x = fromX + elapsed * speed
        if x > toX { finish(); return }
        panel.setFrameOrigin(NSPoint(x: x, y: y))
        let f = Int(elapsed / 0.14) % 2
        view.frameIndex = f
        view.bob = f == 1 ? px : 0
        view.phase = -elapsed * 7
        view.needsDisplay = true
    }

    func finish() {
        timer?.invalidate()
        timer = nil
        panel.orderOut(nil)
        onFinish()
    }
}

// MARK: - The pixel menu (opens from the paw icon)

final class KeyPanel: NSPanel {
    override var canBecomeKey: Bool { true }
}

final class MenuView: NSView {
    unowned let app: AppDelegate
    let panelWidth: CGFloat = 372
    let unit: CGFloat = 2          // one menu pixel = 2 points
    let margin: CGFloat = 12
    var hits: [(NSRect, () -> Void)] = []
    var painting = false
    var editing = false
    var draft = ""
    var draftAnimal: Animal = .cat
    var tick = 0

    init(app: AppDelegate) {
        self.app = app
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) { fatalError("not used") }

    override var isFlipped: Bool { true }
    override var acceptsFirstResponder: Bool { true }
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool { true }

    // Theme colours
    var bg: NSColor { app.dark ? rgb(34, 38, 74) : rgb(255, 236, 242) }
    var card: NSColor { app.dark ? rgb(48, 54, 102) : rgb(255, 248, 251) }
    var line: NSColor { app.dark ? rgb(236, 224, 240) : ink }
    var soft: NSColor { app.dark ? rgb(150, 154, 200) : rgb(176, 150, 150) }
    var stage: NSColor { app.dark ? rgb(104, 116, 184) : rgb(214, 236, 255) }
    let heart = rgb(230, 90, 130)

    // MARK: Drawing pieces (they only paint while `painting` is true)

    func pxFill(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ colour: NSColor) {
        guard painting else { return }
        colour.setFill()
        NSBezierPath(rect: NSRect(x: x, y: y, width: w, height: h)).fill()
    }

    /// A rectangle with stepped pixel corners.
    func pxBlock(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, _ colour: NSColor) {
        pxFill(x + unit, y, w - 2 * unit, h, colour)
        pxFill(x, y + unit, w, h - 2 * unit, colour)
    }

    func pxBox(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat, fill: NSColor, border: NSColor) {
        pxBlock(x, y, w, h, border)
        pxBlock(x + unit, y + unit, w - 2 * unit, h - 2 * unit, fill)
    }

    @discardableResult
    func pxText(_ text: String, _ x: CGFloat, _ y: CGFloat, _ colour: NSColor) -> CGFloat {
        if painting { drawPixelText(text, x: x, y: y, unit: unit, colour: colour) }
        return pixelTextWidth(text, unit: unit)
    }

    func buttonWidth(_ label: String) -> CGFloat { pixelTextWidth(label, unit: unit) + 14 }

    @discardableResult
    func pxButton(_ label: String, _ x: CGFloat, _ y: CGFloat, active: Bool = false,
                  action: @escaping () -> Void) -> CGFloat {
        let w = buttonWidth(label)
        pxBox(x, y, w, 24, fill: active ? pink : card, border: line)
        pxText(label, x + 7, y + 3, active ? ink : line)
        hits.append((NSRect(x: x, y: y, width: w, height: 24), action))
        return w
    }

    func pxSwitch(_ x: CGFloat, _ y: CGFloat, on: Bool, action: @escaping () -> Void) {
        pxBox(x, y, 32, 18, fill: on ? pink : soft, border: line)
        pxFill(on ? x + 18 : x + 4, y + 4, 10, 10, on ? ink : line)
        hits.append((NSRect(x: x - 2, y: y - 2, width: 36, height: 22), action))
    }

    func pxPet(_ animal: Animal, pose: Int, x: CGFloat, y: CGFloat, size: CGFloat, asleep: Bool) {
        guard painting else { return }
        let rows = animal.frames[pose]
        let offset = gridRows - rows.count
        for (r, row) in rows.enumerated() {
            for (c, ch) in row.enumerated() {
                var key = ch
                // Closed eyes while sleeping.
                if asleep && ((animal == .cat && ch == "g") || (animal == .dog && ch == "e" && r + offset == 3)) {
                    key = "h"
                }
                guard let colour = animal.palette[key] else { continue }
                pxFill(x + CGFloat(c) * size, y + CGFloat(r + offset) * size, size, size, colour)
            }
        }
    }

    func clipped(_ text: String, to width: CGFloat) -> String {
        var result = text
        while !result.isEmpty && pixelTextWidth(result, unit: unit) > width { result.removeLast() }
        return result
    }

    // MARK: Layout (also registers the clickable areas); returns the height it needs

    @discardableResult
    func build() -> CGFloat {
        hits.removeAll()
        let app = self.app
        let left = margin
        let right = panelWidth - margin
        var y = margin

        // Header: the pet and its mood
        let asleep = app.sleeping
        let cheering = Date() < app.cheerUntil
        let pose = asleep ? 0 : (cheering ? tick % 2 : (tick / 3) % 2)
        let hop: CGFloat = (cheering && tick % 2 == 1) ? 3 : 0
        pxBox(left, y, 88, 60, fill: stage, border: line)
        pxPet(app.moodAnimal, pose: pose, x: left + 8, y: y + 7 - hop, size: 3, asleep: asleep)
        if asleep {
            pxText((tick / 2) % 2 == 0 ? "z" : "zz", left + 8, y + 2, line)
        } else if cheering {
            pxText("<3", left + 8, y + 2, heart)
        }

        let titleX = left + 100
        pxText("little helpers", titleX, y + 6, line)
        var status = "on duty <3"
        if cheering {
            status = "good job! <3"
        } else if app.paused {
            status = "zzz paused"
        } else if let until = app.snoozeUntil {
            let mins = max(1, Int(ceil(until.timeIntervalSinceNow / 60)))
            status = "zzz back in \(mins)m"
        }
        pxText(status, titleX, y + 32, soft)
        y += 60 + 10

        // One card per reminder
        for r in app.reminders {
            pxBlock(left, y, right - left, 60, card)
            pxSwitch(left + 8, y + 7, on: r.enabled, action: { app.setEnabled(r, !r.enabled) })
            pxBox(left + 48, y + 9, 14, 14,
                  fill: r.animal == .cat ? rgb(54, 48, 66) : rgb(232, 178, 92), border: line)
            let goW = buttonWidth("go")
            let textX = left + 70
            pxText(clipped(r.text, to: right - 8 - goW - 8 - textX), textX, y + 7, r.enabled ? line : soft)
            pxButton("go", right - 8 - goW, y + 4, action: { app.enqueue(r.animal, r.text) })

            let y2 = y + 32
            var rowX = left + 8
            rowX += pxText("every", rowX, y2 + 3, soft) + 8
            rowX += pxButton("-", rowX, y2, action: {
                app.setMinutes(r, r.minutes > 5 ? r.minutes - 5 : max(1, r.minutes - 1))
            }) + 6
            rowX += pxText("\(r.minutes)m", rowX, y2 + 3, line) + 6
            rowX += pxButton("+", rowX, y2, action: {
                app.setMinutes(r, r.minutes < 5 ? r.minutes + 1 : min(180, r.minutes + 5))
            }) + 18
            rowX += pxText("done \(r.done)", rowX, y2 + 3, soft) + 8
            pxButton("+", rowX, y2, action: { app.markDone(r) })
            if r.custom {
                pxButton("x", right - 8 - buttonWidth("x"), y2, action: { app.remove(r) })
            }
            y += 60 + 6
        }

        // Add your own reminder
        if editing {
            pxBlock(left, y, right - left, 66, card)
            pxBox(left + 8, y + 6, right - left - 16, 24, fill: bg, border: line)
            if draft.isEmpty {
                pxText("type a reminder", left + 16, y + 9, soft)
            } else {
                let w = pxText(draft, left + 16, y + 9, line)
                if tick % 2 == 0 { pxFill(left + 16 + w + 2, y + 10, 2, 16, line) }
            }
            let y3 = y + 36
            var editX = left + 8
            editX += pxButton("cat", editX, y3, active: draftAnimal == .cat,
                              action: { [unowned self] in self.draftAnimal = .cat }) + 6
            pxButton("dog", editX, y3, active: draftAnimal == .dog,
                     action: { [unowned self] in self.draftAnimal = .dog })
            let cancelW = buttonWidth("cancel")
            let okW = buttonWidth("ok")
            pxButton("cancel", right - 8 - cancelW, y3, action: { [unowned self] in
                self.editing = false
                self.draft = ""
            })
            pxButton("ok", right - 8 - cancelW - 6 - okW, y3, active: true,
                     action: { [unowned self] in self.commitDraft() })
            y += 66 + 6
        } else if app.reminders.count < 8 {
            pxButton("+ add reminder", left, y, action: { [unowned self] in
                self.editing = true
                self.draft = ""
                app.focusPanel()
            })
            y += 24 + 10
        }

        // Where the pets run
        var runX = left
        runX += pxText("run at", runX, y + 3, soft) + 8
        runX += pxButton("bottom", runX, y, active: app.height == "bottom",
                         action: { app.setHeight("bottom") }) + 6
        runX += pxButton("middle", runX, y, active: app.height == "middle",
                         action: { app.setHeight("middle") }) + 6
        pxButton("pick", runX, y, active: app.height == "custom", action: { app.pickHeight() })
        y += 24 + 10

        // Snooze, theme and quit
        if app.sleeping {
            pxButton("wake up", left, y, active: true, action: { app.wake() })
        } else {
            var footX = left
            footX += pxText("snooze", footX, y + 3, soft) + 8
            footX += pxButton("30m", footX, y, action: { app.snooze(30) }) + 6
            footX += pxButton("60m", footX, y, action: { app.snooze(60) }) + 6
            pxButton("pause", footX, y, action: { app.pauseAll() })
        }
        let quitW = buttonWidth("quit")
        let themeLabel = app.dark ? "light" : "dark"
        pxButton("quit", right - quitW, y, action: { NSApp.terminate(nil) })
        pxButton(themeLabel, right - quitW - 6 - buttonWidth(themeLabel), y, action: { app.toggleDark() })
        y += 24 + margin
        return y
    }

    override func draw(_ dirtyRect: NSRect) {
        NSGraphicsContext.current?.shouldAntialias = false
        painting = true
        pxBox(0, 0, bounds.width, bounds.height, fill: bg, border: line)
        build()
        painting = false
    }

    // MARK: Mouse and keyboard

    override func mouseDown(with event: NSEvent) {
        let point = convert(event.locationInWindow, from: nil)
        let current = hits
        for (rect, action) in current.reversed() where rect.contains(point) {
            action()
            break
        }
        app.refreshPanel()
    }

    func commitDraft() {
        let text = draft.trimmingCharacters(in: .whitespaces)
        if !text.isEmpty { app.add(text, draftAnimal) }
        editing = false
        draft = ""
    }

    override func keyDown(with event: NSEvent) {
        if event.keyCode == 53 {                      // esc
            if editing {
                editing = false
                draft = ""
                app.refreshPanel()
            } else {
                app.closePanel()
            }
            return
        }
        guard editing else { return }
        switch event.keyCode {
        case 51:                                      // delete
            if !draft.isEmpty { draft.removeLast() }
        case 36, 76:                                  // return / enter
            commitDraft()
        default:
            for ch in (event.characters ?? "").lowercased() {
                let c: Character = ch == "\u{2019}" ? "'" : ch
                if pixelFont[c] != nil && draft.count < 24 { draft.append(c) }
            }
        }
        app.refreshPanel()
    }
}

// MARK: - App (menu bar + scheduling)

final class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var paused = false
    var snoozeUntil: Date?
    var dark = false
    var height = "bottom"
    var customY: CGFloat?
    var pickMonitor: Any?
    var day = ""
    var cheerUntil = Date.distantPast
    var moodAnimal: Animal = .cat
    var current: HelperRun?
    var queue: [(Animal, String)] = []
    var reminders: [Reminder] = []
    var panel: KeyPanel?
    var menuView: MenuView?
    var clickMonitor: Any?
    var panelTimer: Timer?

    var sleeping: Bool { paused || snoozeUntil != nil }

    // The cat carries blinking and water; the dog carries posture and stretching.
    func defaultReminders() -> [Reminder] {
        [
            Reminder("don't forget to blink <3", .cat, minutes: 20),
            Reminder("fix your posture <3", .dog, minutes: 30),
            Reminder("drink water <3", .cat, minutes: 45),
            Reminder("stand up & stretch <3", .dog, minutes: 60),
        ]
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        load()

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.target = self
        statusItem.button?.action = #selector(togglePanel)
        updateIcon()

        let t = Timer(timeInterval: 5, repeats: true) { [weak self] _ in self?.check() }
        RunLoop.main.add(t, forMode: .common)

        NSWorkspace.shared.notificationCenter.addObserver(
            self, selector: #selector(didWake), name: NSWorkspace.didWakeNotification, object: nil)

        // A small hello so you can see it works.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.enqueue(.cat, "hi! i'm here to help <3")
        }
    }

    // MARK: Saving

    func load() {
        if let data = UserDefaults.standard.data(forKey: "state"),
           let state = try? JSONDecoder().decode(SavedState.self, from: data) {
            dark = state.dark
            height = state.height ?? "bottom"
            customY = state.customY.map { CGFloat($0) }
            day = state.day
            reminders = state.reminders.map {
                Reminder($0.text, Animal(rawValue: $0.animal) ?? .cat, minutes: $0.minutes,
                         enabled: $0.enabled, done: $0.done, custom: $0.custom)
            }
        }
        if reminders.isEmpty { reminders = defaultReminders() }
        rollDay()
    }

    func save() {
        let saved = reminders.map {
            SavedReminder(text: $0.text, animal: $0.animal.rawValue, minutes: $0.minutes,
                          enabled: $0.enabled, done: $0.done, custom: $0.custom)
        }
        let state = SavedState(reminders: saved, dark: dark, day: day,
                               height: height, customY: customY.map { Double($0) })
        if let data = try? JSONEncoder().encode(state) {
            UserDefaults.standard.set(data, forKey: "state")
        }
    }

    /// The "done" counters start again each day.
    func rollDay() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: Date())
        if today != day {
            day = today
            reminders.forEach { $0.done = 0 }
            save()
        }
    }

    // MARK: Menu actions

    func setEnabled(_ r: Reminder, _ on: Bool) {
        r.enabled = on
        r.reschedule()
        save()
    }

    func setMinutes(_ r: Reminder, _ minutes: Int) {
        r.minutes = minutes
        r.reschedule()
        save()
    }

    func markDone(_ r: Reminder) {
        r.done += 1
        moodAnimal = r.animal
        cheerUntil = Date().addingTimeInterval(1.6)
        save()
    }

    func add(_ text: String, _ animal: Animal) {
        reminders.append(Reminder(text, animal, minutes: 30, custom: true))
        moodAnimal = animal
        save()
    }

    func remove(_ r: Reminder) {
        reminders.removeAll { $0 === r }
        save()
    }

    func snooze(_ minutes: Int) {
        paused = false
        snoozeUntil = Date().addingTimeInterval(TimeInterval(minutes) * 60)
        queue.removeAll()
        updateIcon()
    }

    func pauseAll() {
        paused = true
        snoozeUntil = nil
        queue.removeAll()
        updateIcon()
    }

    func wake() {
        paused = false
        snoozeUntil = nil
        reminders.forEach { $0.reschedule() }
        updateIcon()
    }

    /// Where the middle of a running pet should be, or nil for the bottom of the screen.
    var runCentreY: CGFloat? {
        switch height {
        case "middle":
            let screen = NSScreen.main ?? NSScreen.screens[0]
            return screen.visibleFrame.midY
        case "custom":
            return customY
        default:
            return nil
        }
    }

    func setHeight(_ mode: String) {
        height = mode
        save()
        enqueue(.cat, mode == "middle" ? "middle it is! <3" : "back down here <3")
    }

    /// Closes the menu; the next click anywhere on screen sets the height.
    func pickHeight() {
        closePanel()
        if let monitor = pickMonitor { NSEvent.removeMonitor(monitor) }
        pickMonitor = NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDown) { [weak self] _ in
            guard let self = self else { return }
            if let monitor = self.pickMonitor { NSEvent.removeMonitor(monitor) }
            self.pickMonitor = nil
            self.customY = NSEvent.mouseLocation.y
            self.height = "custom"
            self.save()
            self.enqueue(.cat, "right here! <3")
        }
    }

    func toggleDark() {
        dark.toggle()
        save()
    }

    // MARK: The panel

    @objc func togglePanel() {
        if panel == nil { openPanel() } else { closePanel() }
    }

    func openPanel() {
        rollDay()
        let view = MenuView(app: self)
        let size = NSSize(width: view.panelWidth, height: view.build())
        view.setFrameSize(size)

        var origin = NSPoint(x: 100, y: 100)
        if let window = statusItem.button?.window {
            let anchor = window.frame
            origin = NSPoint(x: anchor.midX - size.width / 2, y: anchor.minY - size.height - 4)
            if let screen = window.screen ?? NSScreen.main {
                let area = screen.visibleFrame
                origin.x = min(max(origin.x, area.minX + 6), area.maxX - size.width - 6)
            }
        }

        let p = KeyPanel(contentRect: NSRect(origin: origin, size: size),
                         styleMask: [.borderless, .nonactivatingPanel],
                         backing: .buffered, defer: false)
        p.isOpaque = false
        p.backgroundColor = .clear
        p.hasShadow = true
        p.level = .popUpMenu
        p.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        p.hidesOnDeactivate = false
        p.isReleasedWhenClosed = false
        p.contentView = view
        panel = p
        menuView = view
        p.makeKeyAndOrderFront(nil)
        p.makeFirstResponder(view)

        // A click anywhere else closes the menu.
        clickMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] _ in
            self?.closePanel()
        }
        let t = Timer(timeInterval: 0.25, repeats: true) { [weak self] _ in
            guard let view = self?.menuView else { return }
            view.tick += 1
            view.needsDisplay = true
        }
        RunLoop.main.add(t, forMode: .common)
        panelTimer = t
    }

    func closePanel() {
        if let monitor = clickMonitor { NSEvent.removeMonitor(monitor) }
        clickMonitor = nil
        panelTimer?.invalidate()
        panelTimer = nil
        panel?.orderOut(nil)
        panel = nil
        menuView = nil
    }

    /// Resizes the panel after its contents change, keeping its top edge in place.
    func refreshPanel() {
        guard let p = panel, let view = menuView else { return }
        let height = view.build()
        var frame = p.frame
        let top = frame.maxY
        frame.size.height = height
        frame.origin.y = top - height
        p.setFrame(frame, display: true)
        view.needsDisplay = true
    }

    /// Typing needs the keyboard, so the panel takes focus when you start writing.
    func focusPanel() {
        NSApp.activate(ignoringOtherApps: true)
        panel?.makeKey()
        if let view = menuView { panel?.makeFirstResponder(view) }
    }

    // MARK: Scheduling

    func updateIcon() {
        let image = NSImage(systemSymbolName: sleeping ? "pawprint" : "pawprint.fill",
                            accessibilityDescription: "Little Helpers")
        image?.isTemplate = true
        statusItem.button?.image = image
    }

    func check() {
        rollDay()
        let now = Date()
        if let until = snoozeUntil, now >= until { wake() }
        guard !sleeping else { return }
        for r in reminders where r.enabled && r.next <= now {
            r.reschedule()
            queue.append((r.animal, r.text))
        }
        playNext()
    }

    func enqueue(_ animal: Animal, _ text: String) {
        queue.append((animal, text))
        playNext()
    }

    func playNext() {
        guard current == nil, !queue.isEmpty else { return }
        let (animal, text) = queue.removeFirst()
        let run = HelperRun(animal: animal, text: text, centreY: runCentreY) { [weak self] in
            self?.current = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { self?.playNext() }
        }
        current = run
        run.start()
    }

    @objc func didWake() {
        // Don't unleash a parade of overdue helpers after the Mac wakes up.
        reminders.forEach { $0.reschedule() }
        queue.removeAll()
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.accessory)   // menu bar only, no Dock icon
app.run()
