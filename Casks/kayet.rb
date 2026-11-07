cask "kayet" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.15.3"
  sha256 arm:   "69ad38483ec3450f11e5adb662679a5584e096b2153230aaaa9ad09fe2397399",
         intel: "574f9e40e5b95be2e26259e1fdc4c1c3ecccf63a607f61576a5eadae15cd612d"

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
