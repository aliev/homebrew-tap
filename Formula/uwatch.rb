class Uwatch < Formula
  desc "Filesystem change history grouped into quiet-period batches"
  homepage "https://github.com/aliev/udiff"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/udiff/releases/download/v0.3.0/uwatch-aarch64-apple-darwin.tar.xz"
      sha256 "37b5d645f61a8efc946dd5ecacbb678c4c6fc238525127445ec5cb01ad5b423a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/udiff/releases/download/v0.3.0/uwatch-x86_64-apple-darwin.tar.xz"
      sha256 "e82061bfb32485b37e1a6fc4c43d9151c2da6cc3c1acf985abe9a9fb431b4a9c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/udiff/releases/download/v0.3.0/uwatch-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "605bc3a5d8c0c8e14e487c96344c18d4a68052d2ac8d64c5f70ada81adf82e56"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/udiff/releases/download/v0.3.0/uwatch-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2eaaf39cfe606142866f7478502db7dd7adda8b9e08db99ba58b7ceee2b62d29"
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
