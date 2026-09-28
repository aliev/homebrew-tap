# Template for the Homebrew formula published to aliev/homebrew-tap.
#
# The Release workflow renders this file by replacing the placeholder tokens
# with the tag and the checksums of the archives it just uploaded, then commits
# the result to the tap. Edit the formula here, not in the tap: anything changed
# there is overwritten by the next release.
class Helix < Formula
  desc "Post-modern modal text editor, with this fork's persistent undo"
  homepage "https://github.com/aliev/helix"
  version "25.7.1-ali.1"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/aliev/helix/releases/download/25.7.1-ali.1/helix-25.7.1-ali.1-aarch64-macos.tar.xz"
      sha256 "d30ea1df9e97291469344cbf0f517fbfaccec702ffbad23039aee916940fc6e2"
    end
    on_intel do
      url "https://github.com/aliev/helix/releases/download/25.7.1-ali.1/helix-25.7.1-ali.1-x86_64-macos.tar.xz"
      sha256 "1342ba1ba4597e5b94707b943242eaa8bb9333bff83b8e9338fb57608297aa99"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aliev/helix/releases/download/25.7.1-ali.1/helix-25.7.1-ali.1-aarch64-linux.tar.xz"
      sha256 "6d269362f96726077625b79ecc4f18e1cf2db835e4e68f11591c84546b8fbba9"
    end
    on_intel do
      url "https://github.com/aliev/helix/releases/download/25.7.1-ali.1/helix-25.7.1-ali.1-x86_64-linux.tar.xz"
      sha256 "3192c3071f67dee05598e22183697f583e8dd6ade047f885057a6b001211e70c"
    end
  end

  def install
    # `hx` finds its runtime directory beside the executable, resolving the
    # symlink first (helix-loader/src/lib.rs), so keeping the two together in
    # libexec needs neither a wrapper script nor HELIX_RUNTIME.
    libexec.install "hx", "runtime"
    bin.install_symlink libexec/"hx"

    bash_completion.install "contrib/completion/hx.bash" => "hx"
    fish_completion.install "contrib/completion/hx.fish"
    zsh_completion.install "contrib/completion/hx.zsh" => "_hx"
  end

  def caveats
    <<~EOS
      This is a personal fork of helix. It installs the same `hx` binary as the
      homebrew-core `helix` formula, so only one of the two can be linked.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hx --version")
    # `hx --health` prints the runtime directories it resolved. Asserting the
    # libexec path appears there proves the symlink-canonicalizing lookup found
    # the runtime we installed, which is the one thing a wrapper script would
    # otherwise be needed for.
    assert_match (libexec/"runtime").to_s, shell_output("#{bin}/hx --health")
  end
end
