class ReCli < Formula
  desc "Reverse engineering CLI wrapping IDA Pro and Hopper Disassembler"
  homepage "https://github.com/NSExceptional/re-cli"
  url "https://github.com/NSExceptional/re-cli/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "f48bb64ad3d94296225a0e9dfdb5793423d18c87d113527001311767e3ee2f20"
  license "MIT"
  head "https://github.com/NSExceptional/re-cli.git", branch: "main"

  depends_on "node"

  def install
    libexec.install "src", "scripts"
    bin.install_symlink libexec/"src/main.ts" => "re"
  end

  test do
    assert_match "reverse engineering CLI", shell_output("#{bin}/re --help")
  end
end
