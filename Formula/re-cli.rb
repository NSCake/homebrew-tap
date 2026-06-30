class ReCli < Formula
  desc "Reverse engineering CLI wrapping IDA Pro and Hopper Disassembler"
  homepage "https://github.com/NSExceptional/re-cli"
  url "https://github.com/NSExceptional/re-cli/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "bb6dce43c7d6265336e0f22f84937885a6786db36af47e756dbce704741d7c0d"
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
