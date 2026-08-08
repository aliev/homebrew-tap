class Loopdiff < Formula
  desc "A fast GitHub-like terminal diff review loop for humans and AI"
  homepage "https://github.com/aliev/loopdiff"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/loopdiff/releases/download/v0.2.0/loopdiff-aarch64-apple-darwin.tar.xz"
      sha256 "128ea1e576d48f3e8f570b562f8fec44d2ab2ab3f6ea6a205e78b1e53c5113b2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/loopdiff/releases/download/v0.2.0/loopdiff-x86_64-apple-darwin.tar.xz"
      sha256 "a888d664cf4eaf9b6c2abec8ed523492746aa732df139418a4f0442e4e2d51bd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/loopdiff/releases/download/v0.2.0/loopdiff-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8b3762993449246e2f2c19f6f061bde8f954be7d4d674749b4a9f715dfb0d19f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/loopdiff/releases/download/v0.2.0/loopdiff-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fea692f79f4efaa66661161a618274bb31a3eb05eb2c7642f139e10d8fdd9b72"
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
