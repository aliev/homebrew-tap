class Uwatch < Formula
  desc "Filesystem change history grouped into quiet-period batches"
  homepage "https://github.com/aliev/udiff"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/udiff/releases/download/v0.1.0/uwatch-aarch64-apple-darwin.tar.xz"
      sha256 "3d3726893374731fb402f1c9f67a8d9ee9745b1a053dc404f936fc3d6a6242e0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/udiff/releases/download/v0.1.0/uwatch-x86_64-apple-darwin.tar.xz"
      sha256 "d0ede8b2dd87e6b56529d5a33442a42026d18db51736cb4156216444056c379a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/udiff/releases/download/v0.1.0/uwatch-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e3b6057bafa22053325a54f3ef574c8caf505d1b3519cfaa2916509a67c8bb93"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/udiff/releases/download/v0.1.0/uwatch-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "33e908eeab3b6001dbea75f3288db42d646356ede5c2258976e90987d9408698"
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
