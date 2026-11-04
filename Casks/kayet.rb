cask "kayet" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.14.0"
  sha256 arm:   "538ebc128bdc6393200bbb5b5ce3cc7262529d5b1f072af51b14ff3cbdeb524d",
         intel: "ebff264ce95f148bab50c2e59aca4eaee5184320d163db7aeeff41bdce606d66"

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
