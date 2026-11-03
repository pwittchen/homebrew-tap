cask "kayet" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.13.1"
  sha256 arm:   "d0eb55f2d85e99bed87dbaaa6f067f2ef8f0f1f4755d78fa739c0c47b24cbde0",
         intel: "7679e1fc523abb1bf4301fbb98aafe207ae19736a714965c6234666a63435867"

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
