class Uwatch < Formula
  desc "Filesystem change history grouped into quiet-period batches"
  homepage "https://github.com/aliev/udiff"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/udiff/releases/download/v0.2.0/uwatch-aarch64-apple-darwin.tar.xz"
      sha256 "77f719967a75cbb0bee7e190fa4199b4039a4ec5151cd11bc1f4d0603073db3a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/udiff/releases/download/v0.2.0/uwatch-x86_64-apple-darwin.tar.xz"
      sha256 "8226fd5edbc87c96d8f6083fda779c560b8b1ab5123807de3e8426390af6f412"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/udiff/releases/download/v0.2.0/uwatch-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8a5ade52e6b6376d2fd934a100edd6d5ba0048af2eb6608e5e64f2eb1153838e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/udiff/releases/download/v0.2.0/uwatch-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "229cad9522a4ffb837cbc4d0c6cdfee040debf7a330a69f3abe0f59d715a8b48"
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
