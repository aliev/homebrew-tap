class Baker < Formula
  desc "baker: project scaffolding tool"
  homepage "https://github.com/aliev/baker"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/baker/releases/download/v0.7.0/baker-aarch64-apple-darwin.tar.xz"
      sha256 "e6125fe7eef490c32904b1563e93de3262c53f4251224fac7aeed288fc0371ee"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/baker/releases/download/v0.7.0/baker-x86_64-apple-darwin.tar.xz"
      sha256 "40f88934793c62381f3272bf44e4d73aef7fa9f4d4819c2977c4f80f9b7e678d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/baker/releases/download/v0.7.0/baker-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2eea38a484ef9795c7ead111dc27cae52b03d7049d5972942721577d6ba7c859"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/baker/releases/download/v0.7.0/baker-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0cdb32208cf8f5f121adbf8205da3cb321d5fa0fac0560872391d4aa0cfbb245"
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
