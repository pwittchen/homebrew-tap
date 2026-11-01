cask "kayet" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.12.0"
  sha256 arm:   "912b7ea0442c9c7229eae1fe599d2ee97fa467e1c6d2e02f8a25783a7603a9dd",
         intel: "e50a8c3e25257215f3b89d0371891fb404ab830a93e5974260e667f2c02544c2"

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
