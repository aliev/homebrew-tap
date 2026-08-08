class Loopdiff < Formula
  desc "A fast GitHub-like terminal diff review loop for humans and AI"
  homepage "https://github.com/aliev/loopdiff"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/loopdiff/releases/download/v0.1.0/loopdiff-aarch64-apple-darwin.tar.xz"
      sha256 "8671ca50eb7603676338063552c04f948dcd576588a4f1b654697839b6608b66"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/loopdiff/releases/download/v0.1.0/loopdiff-x86_64-apple-darwin.tar.xz"
      sha256 "bc6579d9fc2d8edbbd55864a235159f1a300c557d2fdce2d773535b33510acef"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/loopdiff/releases/download/v0.1.0/loopdiff-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3ae6464cb78e62047a47c05dc4c278c2de94872e6d27e469bcb00e5e4444788f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/loopdiff/releases/download/v0.1.0/loopdiff-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8613d24a014f6a4ea811dd4de1ab7b3ff2d1008064b7ea44f69c680c04f1d7bd"
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
