#!/bin/bash

# Build QuackQuack as a proper app bundle
echo "Building QuackQuack.app..."

# Create app bundle structure
mkdir -p QuackQuack.app/Contents/MacOS
mkdir -p QuackQuack.app/Contents/Resources

# Compile Swift to executable
swiftc -o QuackQuack.app/Contents/MacOS/QuackQuack working_version.swift -framework Cocoa

# Create Info.plist
cat > QuackQuack.app/Contents/Info.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>QuackQuack</string>
    <key>CFBundleIdentifier</key>
    <string>com.example.quackquack</string>
    <key>CFBundleName</key>
    <string>QuackQuack</string>
    <key>CFBundleDisplayName</key>
    <string>QuackQuack</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>LSUIElement</key>
    <false/>
</dict>
</plist>
EOF

echo "✅ QuackQuack.app built successfully!"
echo "To run: open QuackQuack.app"