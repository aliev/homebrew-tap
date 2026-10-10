# Template for the Homebrew formula published to aliev/homebrew-tap.
#
# The Release workflow renders this file by replacing the placeholder tokens
# with the tag and the checksums of the archives it just uploaded, then commits
# the result to the tap. Edit the formula here, not in the tap: anything changed
# there is overwritten by the next release.
class Helix < Formula
  desc "Post-modern modal text editor, with this fork's persistent undo"
  homepage "https://github.com/aliev/helix"
  version "25.7.1-ali.2"
  license "MPL-2.0"

  on_macos do
    on_arm do
      url "https://github.com/aliev/helix/releases/download/25.7.1-ali.2/helix-25.7.1-ali.2-aarch64-macos.tar.xz"
      sha256 "29944f899d334f2bd012efa8224d95d32f58d71e8b790aae684d9638fe6ed4be"
    end
    on_intel do
      url "https://github.com/aliev/helix/releases/download/25.7.1-ali.2/helix-25.7.1-ali.2-x86_64-macos.tar.xz"
      sha256 "c2ec1b08c63ff39a22af210db1f4e1fee6ddc14cbb5a1549222442f89768a539"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aliev/helix/releases/download/25.7.1-ali.2/helix-25.7.1-ali.2-aarch64-linux.tar.xz"
      sha256 "d1c53e54a17916c23fc1a5928fe2f1dedb0337edabb093ebec04aa3f553da1a7"
    end
    on_intel do
      url "https://github.com/aliev/helix/releases/download/25.7.1-ali.2/helix-25.7.1-ali.2-x86_64-linux.tar.xz"
      sha256 "4f2368896c8b19b2e5685a8c696dfff0df5c23c0011d8dad5df47986d14309f0"
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
