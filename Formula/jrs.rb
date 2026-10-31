class Jrs < Formula
  desc "Java build system written in Rust"
  homepage "https://getjrs.dev"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/pwittchen/jrs/releases/download/v0.16.0/jrs-aarch64-apple-darwin.tar.gz"
      sha256 "691018fc5f29eb2ae8aa1d9fa41233dd8f3a59d9359de5af12c9bd3a2277f6d2"
    end
    on_intel do
      url "https://github.com/pwittchen/jrs/releases/download/v0.16.0/jrs-x86_64-apple-darwin.tar.gz"
      sha256 "e42d9ebc434fde3248bc90965d0523c79ab3ac78792f7175e900dda60d65cd63"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/pwittchen/jrs/releases/download/v0.16.0/jrs-aarch64-unknown-linux-musl.tar.gz"
      sha256 "50188d1453e75a390ba31af9f5382b314a49a1c7d118aba13d1ae61c191c19e4"
    end
    on_intel do
      url "https://github.com/pwittchen/jrs/releases/download/v0.16.0/jrs-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ddd08ce16c3feb9209932c4486ee255c3725ab519bedd85dd7061ee00ee0684a"
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
