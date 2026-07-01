class ReCli < Formula
  desc "Reverse engineering CLI wrapping IDA Pro and Hopper Disassembler"
  homepage "https://github.com/NSExceptional/re-cli"
  url "https://github.com/NSExceptional/re-cli/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "ab762c0fa701def8e4839b6d82ef74f271fa193384c4fd7f7ff00d8fddec052e"
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
