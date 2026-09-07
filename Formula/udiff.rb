class Udiff < Formula
  desc "A focused terminal UI for code review"
  homepage "https://github.com/aliev/udiff"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/udiff/releases/download/v0.2.0/udiff-aarch64-apple-darwin.tar.xz"
      sha256 "9cd068baf229c288abeed776bcaddd57d91b89c8443beb58e2cda29f97c929f1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/udiff/releases/download/v0.2.0/udiff-x86_64-apple-darwin.tar.xz"
      sha256 "d2113e258f380893a83d81d51ae978ce1a8500c2ac8abaa4e1a2ef3810119074"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/udiff/releases/download/v0.2.0/udiff-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cc4518d40d0f95a3f9d2f7bcb5b86f9e3e7fa4f28fc93840b9a51394a6c583d7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/udiff/releases/download/v0.2.0/udiff-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d87aab1c66e9dde168982c9d0f6b47bac4b547dd3395976d1240f871b2403930"
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
      bin.install "udiff"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "udiff"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "udiff"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "udiff"
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
