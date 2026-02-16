class Baker < Formula
  desc "baker: project scaffolding tool"
  homepage "https://github.com/aliev/baker"
  version "0.14.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/baker/releases/download/v0.14.4/baker-aarch64-apple-darwin.tar.xz"
      sha256 "35d74f833d29bde1162d70300bff90441d0b3460b26892dc88bd6e4c86046606"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/baker/releases/download/v0.14.4/baker-x86_64-apple-darwin.tar.xz"
      sha256 "5e4e1e474c1b1b33942adfe7603c36ad1aaafff3c6737fd2170d0e5bcb6a831e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/baker/releases/download/v0.14.4/baker-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "37f4c3b060309bac7a7db03e2f1d2b7c8d512faf42581d68ecd78c5b98520314"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/baker/releases/download/v0.14.4/baker-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f34197bffafa36dc1a7ddb4cb1be32afc7c90eb71942baccf31642f2146761a6"
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
