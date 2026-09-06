class Udiff < Formula
  desc "A focused terminal UI for code review"
  homepage "https://github.com/aliev/udiff"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/udiff/releases/download/v0.1.2/udiff-aarch64-apple-darwin.tar.xz"
      sha256 "0c684ccfeae438f47f5552d08fdc54e0b238bf940bc8627236693177ce4fcabe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/udiff/releases/download/v0.1.2/udiff-x86_64-apple-darwin.tar.xz"
      sha256 "81229626827d9b8d0563ed273ad02cfa918446d61297052108f370318fd611c1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/udiff/releases/download/v0.1.2/udiff-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e8319fc4ca74ac1575b52741ad3f4010917b55c89fe5706d8c825cf947558c91"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/udiff/releases/download/v0.1.2/udiff-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "76ed536fe14005022f25819c8d9cb039b733cf21b47b9a97b1541c8e83abf8ea"
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
