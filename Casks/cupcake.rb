cask "cupcake" do
  version "1.2"
  sha256 "dc1cb738d8bac4a5e089865b1876943173f8c99792a2b7e40a1b87545f9414b2"

  # Private release asset: needs HOMEBREW_GITHUB_API_TOKEN (see ~/bash/github-token.sh).
  url "https://api.github.com/repos/NSExceptional/Cupcake/releases/assets/744243079",
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
