class Jrs < Formula
  desc "Java build system written in Rust"
  homepage "https://getjrs.dev"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/pwittchen/jrs/releases/download/v0.14.6/jrs-aarch64-apple-darwin.tar.gz"
      sha256 "6a403f9e08219fa48a11a2e5c925bf3c6d3c10cf9906dfa8d65fc6bec07abe27"
    end
    on_intel do
      url "https://github.com/pwittchen/jrs/releases/download/v0.14.6/jrs-x86_64-apple-darwin.tar.gz"
      sha256 "b08e1240e803c1a54b08512bbb44506f39ae252ad78824cb77785abf390ddd61"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/pwittchen/jrs/releases/download/v0.14.6/jrs-aarch64-unknown-linux-musl.tar.gz"
      sha256 "2f9d03237e66148959eb82a5a90580d5a91c9261cca3c2ed1baaa80125535bb7"
    end
    on_intel do
      url "https://github.com/pwittchen/jrs/releases/download/v0.14.6/jrs-x86_64-unknown-linux-musl.tar.gz"
      sha256 "81b48f8af2fd70470c0dc84b63084cd2bb346ac144f751baf41faf596033a06b"
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
