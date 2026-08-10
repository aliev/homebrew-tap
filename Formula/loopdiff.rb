class Loopdiff < Formula
  desc "A fast GitHub-like terminal diff review loop for humans and AI"
  homepage "https://github.com/aliev/loopdiff"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/loopdiff/releases/download/v0.4.0/loopdiff-aarch64-apple-darwin.tar.xz"
      sha256 "27ba175fe4dc30f78cb15641c31b6fb91e778e55c58251fb5e8eac7397d4d42c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/loopdiff/releases/download/v0.4.0/loopdiff-x86_64-apple-darwin.tar.xz"
      sha256 "b315a07a87f0ded68b35f0f403c3d6983799a099f9a70a48bb301f76b6f436f2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/loopdiff/releases/download/v0.4.0/loopdiff-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "501bb779376543dd5a2a85db1d7b2170b3c06d452049294928af5fb3dedfb774"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/loopdiff/releases/download/v0.4.0/loopdiff-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "caf70e886c0b3af800437ddb5ae308e948bc741d9bc4c418b5fac1116d4a616c"
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
