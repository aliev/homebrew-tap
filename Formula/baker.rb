class Baker < Formula
  desc "baker: project scaffolding tool"
  homepage "https://github.com/aliev/baker"
  version "0.14.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/baker/releases/download/v0.14.1/baker-aarch64-apple-darwin.tar.xz"
      sha256 "487ab08945734da7d6f1aee1af2707be210c635a2bb0e0f9e7af32484ecf0091"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/baker/releases/download/v0.14.1/baker-x86_64-apple-darwin.tar.xz"
      sha256 "ee3dd9db2557e7716b630716e9d7c70a6dd84da76b8ab5b2cfbf011e2791be86"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/baker/releases/download/v0.14.1/baker-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b26d0cdc5128195cbbb64f7df678a82ec8198c9e45af6d414840c177aa3f932c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/baker/releases/download/v0.14.1/baker-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7935b82afe6de3884b41f62a1e30258bf45d17814f12d72d132258bf2c45a2b7"
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
