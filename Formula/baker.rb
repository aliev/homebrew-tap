class Baker < Formula
  desc "baker: project scaffolding tool"
  homepage "https://github.com/aliev/baker"
  version "0.14.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/baker/releases/download/v0.14.2/baker-aarch64-apple-darwin.tar.xz"
      sha256 "2fddece75ec7afd6e770e322dc3a065f1224a2090c26de11c72557c62b4a3133"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/baker/releases/download/v0.14.2/baker-x86_64-apple-darwin.tar.xz"
      sha256 "12588db779a21998a1352b80c3f828b7c1955ded5880120465af0a05d6b0e03a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/baker/releases/download/v0.14.2/baker-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2a2111f19342efee8e697e31ba350d255489e01ee322fd7d50b122db3c3dd46c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/baker/releases/download/v0.14.2/baker-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4556be793a78ee26fcdca1a4dcf03c9d4b2951a9e5dc64ef5f2e7811c9250fb4"
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
    bin.install "baker" if OS.mac? && Hardware::CPU.arm?
    bin.install "baker" if OS.mac? && Hardware::CPU.intel?
    bin.install "baker" if OS.linux? && Hardware::CPU.arm?
    bin.install "baker" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
