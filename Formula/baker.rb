class Baker < Formula
  desc "baker: project scaffolding tool"
  homepage "https://github.com/aliev/baker"
  version "0.12.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/baker/releases/download/v0.12.1/baker-aarch64-apple-darwin.tar.xz"
      sha256 "aece37c2ac52f82de49f39ee80b1b63ae0911435be733d2d80bb7881e69d95c1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/baker/releases/download/v0.12.1/baker-x86_64-apple-darwin.tar.xz"
      sha256 "c180fe2f03189c28f83e957e99f543f820b6f95efcf6bf5645e38f001c3e3d03"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/baker/releases/download/v0.12.1/baker-aarch64-unknown-linux-musl.tar.xz"
      sha256 "f5d729dbc67f9223a3ab5b65dceba2ee95e895d6faa9fc441c9a64956f33a4e1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/baker/releases/download/v0.12.1/baker-x86_64-unknown-linux-musl.tar.xz"
      sha256 "e3ca0cf457233ad1c355a9335ec0938924376eac7b1cb1181637a61b3331a19b"
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
