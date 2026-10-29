class Jrs < Formula
  desc "Java build system written in Rust"
  homepage "https://getjrs.dev"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/pwittchen/jrs/releases/download/v0.14.7/jrs-aarch64-apple-darwin.tar.gz"
      sha256 "ae5812f6693fb9bb9b8c520bbe9b38982a33e78dc43148a6a4bae1de6a9492a6"
    end
    on_intel do
      url "https://github.com/pwittchen/jrs/releases/download/v0.14.7/jrs-x86_64-apple-darwin.tar.gz"
      sha256 "0b76d4b4de2376d8be26ad1e17bee185f7a977ff4643a1a083a690ff688df4d1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/pwittchen/jrs/releases/download/v0.14.7/jrs-aarch64-unknown-linux-musl.tar.gz"
      sha256 "b99b3c8c2949216a0b60f932651b8b9e52244c49f9dc9a9b5cfdcbe7ff6cdd60"
    end
    on_intel do
      url "https://github.com/pwittchen/jrs/releases/download/v0.14.7/jrs-x86_64-unknown-linux-musl.tar.gz"
      sha256 "a251abae91fc1cba2cb7312ff6ff8e736dbabfbfb44976df414e161e602d569c"
    end
  end

  def install
    bin.install "jrs"
    generate_completions_from_executable(bin/"jrs", "completions")
  end

  def caveats
    <<~TEXT
      jrs drives the JDK's own tools: it needs a JDK 17 or newer on PATH or
      at JAVA_HOME, such as `brew install openjdk`.
    TEXT
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jrs --version")
  end
end
