class Udiff < Formula
  desc "A focused terminal UI for code review"
  homepage "https://github.com/aliev/udiff"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/udiff/releases/download/v0.1.0/udiff-aarch64-apple-darwin.tar.xz"
      sha256 "0b8956853722d75e87f586bae13fd80151efda471c0b0cd3301d4f6288d5b05f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/udiff/releases/download/v0.1.0/udiff-x86_64-apple-darwin.tar.xz"
      sha256 "ba59c897b5ccc6f9750044f32e75b5e8a94d3f9809a76f9ced975df75c18ce25"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/udiff/releases/download/v0.1.0/udiff-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d5c08dd23785f9814db0613ef37947d2566a757d7e5d0b2e33a9a1b27580a279"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/udiff/releases/download/v0.1.0/udiff-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b0349a6d63997b622342a9d924a8e04c6a1b9a823c19e863942795175d061185"
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
