class ReCli < Formula
  desc "Reverse engineering CLI wrapping IDA Pro and Hopper Disassembler"
  homepage "https://github.com/NSExceptional/re-cli"
  url "https://github.com/NSExceptional/re-cli/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "7fba43c73ccd4b38b561e7dc4f120abf67fb953c488b02ffa6a3943f179edb5e"
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
