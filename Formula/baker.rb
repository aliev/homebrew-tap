class Baker < Formula
  desc "baker: project scaffolding tool"
  homepage "https://github.com/aliev/baker"
  version "0.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/baker/releases/download/v0.8.0/baker-aarch64-apple-darwin.tar.xz"
      sha256 "e4d712b6aab2fb687a12c9d526da9033901a3951a58a88039147d621edb52c61"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/baker/releases/download/v0.8.0/baker-x86_64-apple-darwin.tar.xz"
      sha256 "82736211e057bced9589d0106c230b883fd513e46871e4d9bbe4ce84c707f580"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/baker/releases/download/v0.8.0/baker-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4b842394c547ecc4125781e214d8fbb8fc97f6d6125b67c5b794cfbcd435f165"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/baker/releases/download/v0.8.0/baker-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c75d7679d462dd9ab462cbfd92f1dc44326c55d24211235a86a99c5b41140ece"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
