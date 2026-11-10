cask "nox" do
  version "0.2.1"
  sha256 "5a162d8102f432127c091eccc0facb1b1c8f5ef6985a81093833d8bec2c48a46"

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
