class Udiff < Formula
  desc "A focused terminal UI for code review"
  homepage "https://github.com/aliev/udiff"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/udiff/releases/download/v0.1.1/udiff-aarch64-apple-darwin.tar.xz"
      sha256 "471c50d9f9f592edc950394cb03d5d876578e0bb705c18769e04a2ce4d372f10"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/udiff/releases/download/v0.1.1/udiff-x86_64-apple-darwin.tar.xz"
      sha256 "91b0e25f38fcdb9afd42debd3f6f74ba0164fa5f6eea0eda60f93f9cbda22f57"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/udiff/releases/download/v0.1.1/udiff-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "191cfd6b7df06d535c03f0fa295c0146c4ce2f728dc48b11efdfdaf8919fa95c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/udiff/releases/download/v0.1.1/udiff-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "45cee435e4ce6840f538f3c71f2a8b8f2c2e424a3c2610266f562bbf2a80d4f5"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "udiff"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "udiff"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "udiff"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "udiff"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
