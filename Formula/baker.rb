class Baker < Formula
  desc "baker: project scaffolding tool"
  homepage "https://github.com/aliev/baker"
  version "0.12.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/baker/releases/download/v0.12.0/baker-aarch64-apple-darwin.tar.xz"
      sha256 "b76271e0585fe67a532cb41b9c510d0245b473f359bf3288fdaa7e3de98ae521"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/baker/releases/download/v0.12.0/baker-x86_64-apple-darwin.tar.xz"
      sha256 "30ffcb2cdbbc080204f3a9661b48126c1e1123ab476b4ffce287f7fdfd8a2927"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/baker/releases/download/v0.12.0/baker-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c0c72feaee89b567ec0ae8145fe1cb16f83312b67f42dc8f9e607b1db9f601a0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/baker/releases/download/v0.12.0/baker-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "15bd40488f12dd0e06093911d12fb2babcafa0564391aca4049df6611b752963"
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
