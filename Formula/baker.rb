class Baker < Formula
  desc "baker: project scaffolding tool"
  homepage "https://github.com/aliev/baker"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/baker/releases/download/v0.6.0/baker-aarch64-apple-darwin.tar.xz"
      sha256 "55cbb05477336760f6e471ab5ba43bc8bed37e14678f8c87b2ba53ff5cd55448"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/baker/releases/download/v0.6.0/baker-x86_64-apple-darwin.tar.xz"
      sha256 "617c00138fddbef3e31453137b25e9e284b1ef93d59a61d478c6c75af51f320f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/baker/releases/download/v0.6.0/baker-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f413587cf6108361db1b73cfcfc1cf7e6c506835abcdd522ad3ee6f2a003ebc1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/baker/releases/download/v0.6.0/baker-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e6e201fb5a2be09d68934413a7cde94e0717c8bec4a37aec8c183f2570e2cdb2"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
