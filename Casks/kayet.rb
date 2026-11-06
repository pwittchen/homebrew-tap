cask "kayet" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.15.0"
  sha256 arm:   "2db2c0d6cf1ae869ff3b549ec98abcb5e0ff8d0c414189d433f34699697fdb27",
         intel: "4e11761d8b2f335c6d67330c6b6da4e4e37b3a6437f3a6fccbccc2ff2356f359"

  url "https://github.com/pwittchen/kayet/releases/download/v#{version}/kayet-macos-#{arch}.dmg"
  name "kayet"
  desc "Minimalistic text editor"
  homepage "https://getkayet.app/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on :macos

  app "kayet.app"
  binary "#{appdir}/kayet.app/Contents/Resources/kayet"

  # ~/.kayet itself stays: the default workspace, with the user's notes, lives there.
  zap trash: [
    "~/.kayet/cache",
    "~/Library/Caches/com.github.pwittchen.kayet",
    "~/Library/Preferences/com.github.pwittchen.kayet.plist",
    "~/Library/WebKit/com.github.pwittchen.kayet",
  ]
end
