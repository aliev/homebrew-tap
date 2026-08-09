class Loopdiff < Formula
  desc "A fast GitHub-like terminal diff review loop for humans and AI"
  homepage "https://github.com/aliev/loopdiff"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/loopdiff/releases/download/v0.3.0/loopdiff-aarch64-apple-darwin.tar.xz"
      sha256 "a0868d56097902fa55b65afeeed420ca54f585f1043f4e100876738d1751e5c4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/loopdiff/releases/download/v0.3.0/loopdiff-x86_64-apple-darwin.tar.xz"
      sha256 "f827b139876d5a9cf2812d45e6e2d882cda1dc09319c15b6037cd14b34f331ca"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/loopdiff/releases/download/v0.3.0/loopdiff-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "02dd325db23a8f80bfd358bac20971adbfe075b31111b4c0cad9e543d4bb5ab7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/loopdiff/releases/download/v0.3.0/loopdiff-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "56921adf12913abcfa17ffec6c2f375d6d1181ff8ffe2044a843b0d2e4523314"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "loopdiff" if OS.mac? && Hardware::CPU.arm?
    bin.install "loopdiff" if OS.mac? && Hardware::CPU.intel?
    bin.install "loopdiff" if OS.linux? && Hardware::CPU.arm?
    bin.install "loopdiff" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
