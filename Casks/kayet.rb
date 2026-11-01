cask "kayet" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.13.0"
  sha256 arm:   "c7597a89d0a55f02c870601a759431b9c7ba21941ea4f059e13388388ce424f0",
         intel: "b72daf2897405e00675eba8b5307b47db62e1dd8137a977ff719ef6aa85bd8e0"

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
