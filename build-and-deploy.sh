#!/bin/bash

# FTC Robot Controller - Build and Deploy Script
# This script builds the TeamCode APK and installs it to the connected robot

set -e  # Exit on error

echo "======================================"
echo "FTC Robot Controller - Build & Deploy"
echo "======================================"
echo ""

# Build the APK
echo "📦 Building APK..."
./gradlew assembleDebug -x lint -x lintVitalAnalyzeRelease -x lintVitalReportRelease

if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    exit 1
fi

echo ""
echo "✅ Build successful!"
echo ""

# Check for connected devices
echo "🔍 Checking for connected devices..."
DEVICES=$(adb devices | grep -v "List of devices" | grep "device$" | wc -l)

if [ $DEVICES -eq 0 ]; then
    echo "❌ No FTC robot connected via ADB!"
    echo "Please connect your robot and try again."
    exit 1
fi

echo "✅ Found $DEVICES connected device(s)"
echo ""

# Install the APK
echo "🚀 Installing APK to robot..."
APK_PATH="./TeamCode/build/outputs/apk/debug/TeamCode-debug.apk"

if [ ! -f "$APK_PATH" ]; then
    echo "❌ APK not found at $APK_PATH"
    exit 1
fi

adb install -r "$APK_PATH"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Deployment successful!"
    echo "======================================"
    echo "Your robot is ready to use!"
    echo "======================================"
else
    echo "❌ Deployment failed!"
    exit 1
fi
