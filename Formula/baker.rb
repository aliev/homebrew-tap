class Baker < Formula
  desc "baker: project scaffolding tool"
  homepage "https://github.com/aliev/baker"
  version "0.16.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/baker/releases/download/v0.16.0/baker-aarch64-apple-darwin.tar.xz"
      sha256 "7f038902dc21a2dccee4e0f3bbeea09fa521267928544e364517b2cbef5a7476"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/baker/releases/download/v0.16.0/baker-x86_64-apple-darwin.tar.xz"
      sha256 "a9bb03cb12272e27cb47bbc142b57dea348faab076f236cd7a7b4e00ead23c7f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/baker/releases/download/v0.16.0/baker-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "46d48f742477cb32a948c30e162ce0d61505260b04440c535202a81a68db0969"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/baker/releases/download/v0.16.0/baker-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e7861e30687a2e45a6e2f1b631bc49d4a1670463d20202a00908b04d9c4f0cc0"
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
