class Udiff < Formula
  desc "A focused terminal UI for code review"
  homepage "https://github.com/aliev/udiff"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/udiff/releases/download/v0.3.0/udiff-aarch64-apple-darwin.tar.xz"
      sha256 "b812abae3278b0ca6f78cc39265343e6f79769e6ea0a5548b875c7a23d7d90bc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/udiff/releases/download/v0.3.0/udiff-x86_64-apple-darwin.tar.xz"
      sha256 "6d2a498936f4e0478f54ab899d13960cc40312aa93b72f4efe2f3cd8d39b48fe"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/udiff/releases/download/v0.3.0/udiff-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c87d86e62bfb6afc70cdd0b7b8e5f9bbb76eb11a4df75dc61888cc166f56c9df"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/udiff/releases/download/v0.3.0/udiff-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c13f807a19197e85c466a592b920160a58e417d9db879905fa19479cf8c44cfe"
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
