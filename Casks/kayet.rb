cask "kayet" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.12.1"
  sha256 arm:   "e35bbe895bba059fe91dfb165817e3b80e9193d9d44db365d2a84f524db140a5",
         intel: "39a1c370ab30565e3f13d8e39ba1a7bc1f21f305df9df2ba6c5aab94650ea3bf"

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
