class Baker < Formula
  desc "baker: project scaffolding tool"
  homepage "https://github.com/aliev/baker"
  version "0.13.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/baker/releases/download/v0.13.0/baker-aarch64-apple-darwin.tar.xz"
      sha256 "2eccef26064befd4f59aee44f140960cfa576b6d5529162a37065a0467d2cd0c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/baker/releases/download/v0.13.0/baker-x86_64-apple-darwin.tar.xz"
      sha256 "ca0d4206913760e01f630121bfa52048d6b8c5126b28eba2372e6f2d82e02799"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/baker/releases/download/v0.13.0/baker-aarch64-unknown-linux-musl.tar.xz"
      sha256 "d335f9ca1901b8dae29c0e436b89c205cd1c90b942adc85704aad47e7b1dd1c4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/baker/releases/download/v0.13.0/baker-x86_64-unknown-linux-musl.tar.xz"
      sha256 "2313e82f97313b58ae0a9560e017ee151f410cabc325351a45f72964f7e9ab80"
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
