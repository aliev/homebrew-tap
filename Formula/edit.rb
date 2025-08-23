class Edit < Formula
  desc "edit is a simple terminal tool that launches the appropriate editor for your terminal environment"
  homepage "https://github.com/aliev/edit"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/edit/releases/download/v0.1.0/edit-aarch64-apple-darwin.tar.xz"
      sha256 "cd5bca57e81fa11c413eaba53778d31f1140a08038dfbafdea6d81aa5845a1b5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/edit/releases/download/v0.1.0/edit-x86_64-apple-darwin.tar.xz"
      sha256 "8e16c96a960176dded5c3cdac5b3036bddba225a92836d79d16bbd48e9dad8c5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/edit/releases/download/v0.1.0/edit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "597fbfd86e3c0ad60d6774164f309428c4e509f16fbd796d26e90cfe244d3832"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/edit/releases/download/v0.1.0/edit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b4edab25a10c51b6927ab5b34500c9401b0b8c0e87adcc9911dd90ab64fc795b"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
    bin.install "edit" if OS.mac? && Hardware::CPU.arm?
    bin.install "edit" if OS.mac? && Hardware::CPU.intel?
    bin.install "edit" if OS.linux? && Hardware::CPU.arm?
    bin.install "edit" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
