class Baker < Formula
  desc "baker: project scaffolding tool"
  homepage "https://github.com/aliev/baker"
  version "0.8.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/baker/releases/download/v0.8.1/baker-aarch64-apple-darwin.tar.xz"
      sha256 "22961778559f1550d22c137198999722348faf87ebcdd294b74d70133539b401"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/baker/releases/download/v0.8.1/baker-x86_64-apple-darwin.tar.xz"
      sha256 "9c33009bcfd7df57f5fb67adaed7467f94ed58f3d34d3a9a3f318a80afb3e484"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/baker/releases/download/v0.8.1/baker-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "18ebf597508fa726078f5eac6261386f4d9bc75ad04917c0492ac32789229ef6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/baker/releases/download/v0.8.1/baker-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a18f688f4c47a5284bdef1d2c6c49bc5adba8f1cf7b813e6b262443719874f46"
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
