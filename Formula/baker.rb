class Baker < Formula
  desc "baker: project scaffolding tool"
  homepage "https://github.com/aliev/baker"
  version "0.17.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/baker/releases/download/v0.17.0/baker-aarch64-apple-darwin.tar.xz"
      sha256 "b260d2de2224365a9c4b26a0edf7de9839b8a7cb05b6847f0b04056335c8fbe7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/baker/releases/download/v0.17.0/baker-x86_64-apple-darwin.tar.xz"
      sha256 "489dfc824548d233319a4a1dba23955e78995c2d3638694b9dc12593991a4b5b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/baker/releases/download/v0.17.0/baker-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "47fba82e0e47707e715171ceede5ca89c35e7642a59e6d8fe79a98d28bd4c67f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/baker/releases/download/v0.17.0/baker-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d70cc7896d2a4a5a29d9ed12cdb94e3fcc3fbb4c284e6623bccc42d6a03525c7"
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
      bin.install "baker"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "baker"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "baker"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "baker"
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
