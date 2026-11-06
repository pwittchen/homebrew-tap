cask "kayet" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.15.1"
  sha256 arm:   "b1741ee2ccbb578689234397ec538e243dd763a719a78b65e81c38fa9308bf66",
         intel: "cb5bc816987ac8617cdc5c95897bbce78057763bc318ffa71931b884558ca788"

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
