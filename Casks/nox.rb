cask "nox" do
  version "0.1.2"
  sha256 "7f886e486a0acaeb8d11d672fda162ab4826c0697b76f941c45a0f2395ee6b2e"

  url "https://github.com/pwittchen/nox/releases/download/v#{version}/nox-macos-aarch64.dmg"
  name "nox"
  desc "Minimalistic, fast, native terminal"
  homepage "https://github.com/pwittchen/nox"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :ventura

  app "nox.app"
  binary "#{appdir}/nox.app/Contents/Resources/bin/nox"

  zap trash: [
    "~/.nox",
    "~/Library/Caches/com.pwittchen.nox",
    "~/Library/Preferences/com.pwittchen.nox.plist",
    "~/Library/Saved Application State/com.pwittchen.nox.savedState",
  ]
end
