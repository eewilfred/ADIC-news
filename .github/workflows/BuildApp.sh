#!/bin/bash

set -eo pipefail
echo pwd
xcodebuild -workspace ADIC-news.xcworkspace \
            -scheme Calculator\ iOS \
            -destination platform=iOS\ Simulator,OS=13.3,name=iPhone\ 11 \
            clean test | xcpretty
