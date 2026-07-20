class Sipa < Formula
  desc "Native macOS CLI for sideloading iOS apps (a Sideloadly recreation)"
  homepage "https://github.com/NSExceptional/sipa"
  license "MIT"
  head "https://github.com/NSExceptional/sipa.git", branch: "main"

  # Tagged releases (fill in once cut):
  # url "https://github.com/NSExceptional/sipa/archive/refs/tags/v0.1.0.tar.gz"
  # sha256 "..."

  depends_on xcode: ["15.0", :build]
  depends_on :macos
  depends_on "libimobiledevice"
  depends_on "ldid"

  # Optional: `zsign` is only needed to sign with a raw .p12 (no Keychain identity).
  # depends_on "zsign"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/sipa"
  end

  def caveats
    <<~EOS
      sipa shells out to `codesign`, which ships with the Command Line Tools:
        xcode-select --install

      For iOS 17+, enable Developer Mode on the device:
        Settings → Privacy & Security → Developer Mode → on (then reboot)

      To sign with a raw .p12 instead of a Keychain identity, also install zsign:
        brew install zsign
    EOS
  end

  test do
    assert_match(/\d+\.\d+\.\d+/, shell_output("#{bin}/sipa --version"))
  end
end
