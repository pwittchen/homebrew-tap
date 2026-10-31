class Jrs < Formula
  desc "Java build system written in Rust"
  homepage "https://getjrs.dev"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/pwittchen/jrs/releases/download/v0.15.0/jrs-aarch64-apple-darwin.tar.gz"
      sha256 "4149c0078804c138b2007f5f7746b8faf07520cd8afa39cfd053ca2e95e7c054"
    end
    on_intel do
      url "https://github.com/pwittchen/jrs/releases/download/v0.15.0/jrs-x86_64-apple-darwin.tar.gz"
      sha256 "7d550d4467c712772de88ffa0088ff53c273e216995dcefe2b3df6b77fc4ad82"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/pwittchen/jrs/releases/download/v0.15.0/jrs-aarch64-unknown-linux-musl.tar.gz"
      sha256 "f756102384e993924cc9a9192fdc398fd5c74761645f8a046753441f819a5e13"
    end
    on_intel do
      url "https://github.com/pwittchen/jrs/releases/download/v0.15.0/jrs-x86_64-unknown-linux-musl.tar.gz"
      sha256 "9f772a4eb62a4b03e1061514ec7d406cdf1a4726ce90d0d3503e40ec3421aea1"
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
