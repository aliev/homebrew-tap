class Baker < Formula
  desc "baker: project scaffolding tool"
  homepage "https://github.com/aliev/baker"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/baker/releases/download/v0.9.0/baker-aarch64-apple-darwin.tar.xz"
      sha256 "cfc234521878f332abf64f7b62c6d1a10ba43700c220fdfed4b71193dade6716"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/baker/releases/download/v0.9.0/baker-x86_64-apple-darwin.tar.xz"
      sha256 "c38ee41fc434d333d288944a066e258c33800947d3409eaac527934ca93198c7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/baker/releases/download/v0.9.0/baker-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6200e8be83a1ea645f7930c46ec76ba412b95fc374a856126dbd0db4bcce44d8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/baker/releases/download/v0.9.0/baker-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a5424b9d6db34fffdefded47d8a747bf4b5fe8012694ea7bd0f2466bfe331900"
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
