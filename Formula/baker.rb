class Baker < Formula
  desc "baker: project scaffolding tool"
  homepage "https://github.com/aliev/baker"
  version "0.13.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/baker/releases/download/v0.13.1/baker-aarch64-apple-darwin.tar.xz"
      sha256 "c17d6e8e9206a8f7ff1426da7605fa61a4da97277ad753822f2c559dce09e29b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/baker/releases/download/v0.13.1/baker-x86_64-apple-darwin.tar.xz"
      sha256 "0b0bffe462c595392bba34372001a1f863359058ec93e02cb038e2950a1a3be1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/baker/releases/download/v0.13.1/baker-aarch64-unknown-linux-musl.tar.xz"
      sha256 "9fb7d0ec569a6d553853f637f19efe6fba981d556070fcdef292383b388a4996"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/baker/releases/download/v0.13.1/baker-x86_64-unknown-linux-musl.tar.xz"
      sha256 "b468ac64ce3369021d66fcfe779577853e005a620d1f5d6b5e04bac6d789555e"
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
