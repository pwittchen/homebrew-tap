cask "nox" do
  version "0.1.3"
  sha256 "f5e529134573e6a6037b9517e6ba26e9c989aab85c2b3dfd8fe7a0f0f2c3dc80"

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
