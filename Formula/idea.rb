class Idea < Formula
  desc "One-shot project scaffolder: folder, git, private repo, NSCake board, XcodeGen"
  homepage "https://github.com/NSExceptional/idea"
  head "https://github.com/NSExceptional/idea.git", branch: "main"
  license "MIT"

  depends_on "deno" => :build

  def install
    # Compile a standalone binary so `deno` isn't needed at runtime.
    system "deno", "compile", "--allow-all", "--output", "idea", "src/main.ts"
    bin.install "idea"
  end

  def caveats
    <<~EOS
      idea shells out to `gh` (authenticated, with `repo` + `project` scopes),
      and to `xcodegen` for --ios/--mac projects:

        brew install gh xcodegen
        gh auth login
    EOS
  end

  test do
    assert_match "scaffold a new code project", shell_output("#{bin}/idea --help")
  end
end
