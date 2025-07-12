class McpMemory < Formula
  desc "MCP Memory is a lightweight Model Context Protocol (MCP) server that stores a knowledge graph on disk and provides simple text search capabilities."
  homepage "https://github.com/aliev/mcp_memory"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/mcp_memory/releases/download/v0.1.1/mcp_memory-aarch64-apple-darwin.tar.xz"
      sha256 "9aab9264169dcdab5520e7501771ab62558720fef2151dbde88de14e51e87d97"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/mcp_memory/releases/download/v0.1.1/mcp_memory-x86_64-apple-darwin.tar.xz"
      sha256 "07ff6a5bd75c60bf220a313f931e2b0246e93c80879dbc57d0b3bd5c76e58390"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aliev/mcp_memory/releases/download/v0.1.1/mcp_memory-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a16e9c27dd6f9eeb20b09358dc78dc03d4020c9e0f56120036de042cb71a9c55"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aliev/mcp_memory/releases/download/v0.1.1/mcp_memory-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a56a72ef08a9a624d451f6a918b50259980ac9917f1237174766dd97823ef1a4"
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
