class McpMemory < Formula
  desc "MCP Memory is a lightweight Model Context Protocol (MCP) server that stores a knowledge graph on disk and provides simple text search capabilities."
  homepage "https://github.com/aliev/mcp_memory"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/mcp_memory/releases/download/v0.1.0/mcp_memory-aarch64-apple-darwin.tar.xz"
      sha256 "1325953c09bcafbe9e565fff94899a26d30c47bfd26db9e5e7673660ba6c8132"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/mcp_memory/releases/download/v0.1.0/mcp_memory-x86_64-apple-darwin.tar.xz"
      sha256 "c873c9fa1306d92cf88da77b6ba186f5da906f534edc674d39062b5a5140a71f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/mcp_memory/releases/download/v0.1.0/mcp_memory-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0b130a00a33a8e5b4ba53b6aa887384eb8ec88921e84bc6f6958dffae90afdeb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/mcp_memory/releases/download/v0.1.0/mcp_memory-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e14dab0008487329d1cecebad6bb2b33e112d59e072407289890fb5d647ec524"
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
    bin.install "mcp_memory" if OS.mac? && Hardware::CPU.arm?
    bin.install "mcp_memory" if OS.mac? && Hardware::CPU.intel?
    bin.install "mcp_memory" if OS.linux? && Hardware::CPU.arm?
    bin.install "mcp_memory" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
