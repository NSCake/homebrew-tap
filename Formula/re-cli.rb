class ReCli < Formula
  desc "Reverse engineering CLI wrapping IDA Pro and Hopper Disassembler"
  homepage "https://github.com/NSExceptional/re-cli"
  url "https://github.com/NSExceptional/re-cli/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "1359e783540023be1c48d5e61ef0be7aaf5e70d3114e4d32ecb7103f8e86f623"
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
