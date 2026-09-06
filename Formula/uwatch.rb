class Uwatch < Formula
  desc "Filesystem change history grouped into quiet-period batches"
  homepage "https://github.com/aliev/udiff"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/udiff/releases/download/v0.1.2/uwatch-aarch64-apple-darwin.tar.xz"
      sha256 "07a27eacff02d8721e585a174fdef09c5fb55fdfb3e9abb9af5cd9733e59328c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/udiff/releases/download/v0.1.2/uwatch-x86_64-apple-darwin.tar.xz"
      sha256 "3b1c2dfeb7fd23906c16713b69ce5e0b07681f4ee803de47f0da57c7f1067cf7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/udiff/releases/download/v0.1.2/uwatch-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4b88802b68ed2af5d9129f5d02f10a088e770b5584f5a46c25370929c1594344"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/udiff/releases/download/v0.1.2/uwatch-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "42267fe74eed7d59e551a22188a1b799514d9e323b0399082e26eebd42349203"
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
      bin.install "uwatch"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "uwatch"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "uwatch"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "uwatch"
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
