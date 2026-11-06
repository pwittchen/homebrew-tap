cask "kayet" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.15.2"
  sha256 arm:   "9521ccabdb491791f82982cebb46b2ea14d1bccbd7f13108bad177d2b867dba3",
         intel: "b5971f74eba898172de6a68274a24b0de4d012b2eabd23c7c49c0d44f4c99cff"

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
