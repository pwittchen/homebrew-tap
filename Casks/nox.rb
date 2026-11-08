cask "nox" do
  version "0.1.1"
  sha256 "d05ddedc6464cea9acca9653c8f8ef98def94f0b6b1fe6df9e7c7e4e992e6c49"

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
