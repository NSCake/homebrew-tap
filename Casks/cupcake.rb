cask "cupcake" do
  version "1.1"
  sha256 "6fc4651cda07d306fdd0b91c0e3a86740173ec8759bceb965ac00e10ac9e88ab"

  # Private release asset: needs HOMEBREW_GITHUB_API_TOKEN (see ~/bash/github-token.sh).
  url "https://api.github.com/repos/NSExceptional/Cupcake/releases/assets/741039252",
      header: [
        "Authorization: Bearer #{ENV.fetch("HOMEBREW_GITHUB_API_TOKEN", "")}",
        "Accept: application/octet-stream",
      ]
  name "Cupcake"
  desc "App-icon customizer, a modern IconChamp replacement"
  homepage "https://github.com/NSExceptional/Cupcake"

  depends_on macos: :sonoma

  app "Cupcake.app"

  # Ad-hoc signed, so Gatekeeper would block a quarantined copy.
  postflight_steps do
    run "/usr/bin/xattr",
        args: ["-dr", "com.apple.quarantine", "{{appdir}}/Cupcake.app"]
  end

  zap trash: [
    "~/Library/Application Support/Cupcake",
    "~/Library/Preferences/com.nsexceptional.Cupcake.plist",
  ]
end
