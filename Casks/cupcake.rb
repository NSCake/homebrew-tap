cask "cupcake" do
  version "1.1"
  sha256 "a0d2cf620393cc6047bd7374bf3b853aafa76dcbb140417a9950b57cc633f972"

  # Private release asset: needs HOMEBREW_GITHUB_API_TOKEN (see ~/bash/github-token.sh).
  url "https://api.github.com/repos/NSExceptional/Cupcake/releases/assets/743403059",
      header: [
        "Authorization: Bearer #{ENV.fetch("HOMEBREW_GITHUB_API_TOKEN", "")}",
        "Accept: application/octet-stream",
      ]
  name "Cupcake"
  desc "App-icon customizer, a modern IconChamp replacement"
  homepage "https://github.com/NSExceptional/Cupcake"

  depends_on macos: :sonoma

  app "Cupcake.app"

  # Not notarized, so Gatekeeper would block a quarantined copy.
  postflight_steps do
    run "/usr/bin/xattr",
        args: ["-dr", "com.apple.quarantine", "{{appdir}}/Cupcake.app"]
  end

  zap trash: [
    "~/Library/Application Support/Cupcake",
    "~/Library/Preferences/com.nsexceptional.Cupcake.plist",
  ]
end
