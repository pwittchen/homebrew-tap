cask "kayet" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.12.2"
  sha256 arm:   "f23a4ab2318daf568f43bf4bf9d1455fcb8b1fab4c57fc0ba9f23b40bdcfbdff",
         intel: "74b13710616690fc71e04dc231e9da8ad74c67e9fa9e748c5dbb03e5c8c14d75"

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
