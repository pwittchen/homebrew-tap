cask "nox" do
  version "0.1.0"
  sha256 "4b05ccf6562e1994c083f49e6d77c09d0eb510b7c0231fc58901abd82afac31d"

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
