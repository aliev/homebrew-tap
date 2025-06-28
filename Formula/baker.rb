class Baker < Formula
  desc "baker: project scaffolding tool"
  homepage "https://github.com/aliev/baker"
  version "0.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/baker/releases/download/v0.10.0/baker-aarch64-apple-darwin.tar.xz"
      sha256 "1a265bf3a73821e8abf640b8a962aee61de9d67ceb4e7ae03930cc8b1600f550"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/baker/releases/download/v0.10.0/baker-x86_64-apple-darwin.tar.xz"
      sha256 "63a34c1de9e01bf5bea05cae9a8e390b0a7eaeb3bbbf5983a51b5dd8bba65d8d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/baker/releases/download/v0.10.0/baker-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a31453aeafc554ae7a8f3036785ba12023b07ff11128ab124e26672a0a64065b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/baker/releases/download/v0.10.0/baker-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d78d396a30b4315899d3c75aa1aaab8eb645eae6d30f6a13605e53aad3d72b04"
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
