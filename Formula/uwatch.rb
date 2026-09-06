class Uwatch < Formula
  desc "Filesystem change history grouped into quiet-period batches"
  homepage "https://github.com/aliev/udiff"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/udiff/releases/download/v0.1.1/uwatch-aarch64-apple-darwin.tar.xz"
      sha256 "f52171f5550ff10677307105d47f947c10efc32276d6c84e0030e4804da4e164"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/udiff/releases/download/v0.1.1/uwatch-x86_64-apple-darwin.tar.xz"
      sha256 "e5ca73e7fb6caf9cae27d68dd31b73b75e0f0ea2f77e63dfc02d5d10ed49a9d0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/udiff/releases/download/v0.1.1/uwatch-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b9eaf8e3569730151435150dae53b755b97934512f504f39a2d99a1786f31ea7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/udiff/releases/download/v0.1.1/uwatch-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fe66395b7f40610030a19e1cc9c22e1de1de2ea5ddfa8ab0f34f6fd0bcb9e91b"
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
