class Jrs < Formula
  desc "Java build system written in Rust"
  homepage "https://getjrs.dev"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/pwittchen/jrs/releases/download/v0.14.8/jrs-aarch64-apple-darwin.tar.gz"
      sha256 "1eab5ae1bb97c505701b6c54d6bf5b284b16f7fa578afb4e1085d647630330bc"
    end
    on_intel do
      url "https://github.com/pwittchen/jrs/releases/download/v0.14.8/jrs-x86_64-apple-darwin.tar.gz"
      sha256 "a0bc1417b1ddb89144e9997e3b36f5e9dd4eb87262bcc3f22994e6fb0e60babd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/pwittchen/jrs/releases/download/v0.14.8/jrs-aarch64-unknown-linux-musl.tar.gz"
      sha256 "a6a2109f1a87bff20245abf6eed4b835124fc9312ab6a8cceb0ed829d86c4fbd"
    end
    on_intel do
      url "https://github.com/pwittchen/jrs/releases/download/v0.14.8/jrs-x86_64-unknown-linux-musl.tar.gz"
      sha256 "813cc19c8bbe3cebe38450a7171c1cd5e20f7e7bfce7cf8647dda7279307ea5d"
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
