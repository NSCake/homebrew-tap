class Ttrff < Formula
  include Language::Python::Virtualenv

  desc "Menu-bar app that auto-attaches the ttrff cosmetic mods to Toontown Rewritten"
  homepage "https://github.com/NSExceptional/ttrff"
  head "https://github.com/NSExceptional/ttrff.git", branch: "main"

  depends_on "python@3.13"
  depends_on :macos

  def install
    # A private virtualenv with the menu-bar GUI stack. We install pinned PREBUILT WHEELS rather
    # than building from source: Pillow 12 drags in a cmake/ninja/pybind11 build chain that breaks
    # under Homebrew's shims, and even Pillow 11 requires libjpeg/zlib headers to compile -- none
    # of which we need for an in-memory icon. The wheels are self-contained (Pillow bundles its own
    # libjpeg/zlib), so nothing compiles here. HEAD-only formula; this fetches from PyPI at install.
    #   pyobjc-core + six arrive automatically as dependencies of the packages below.
    venv = virtualenv_create(libexec/"venv", "python3.13")
    system libexec/"venv"/"bin"/"python", "-m", "pip", "install",
           "pystray==0.19.4",
           "Pillow==11.3.0",
           "psutil==7.2.2",
           "pyobjc-framework-Cocoa==12.2.2",
           "pyobjc-framework-Quartz==12.2.2"

    # Ship the single-file tray module plus the runtime toolset it drives: the injector, the
    # signed frida runner, the stop/driver scripts, the RE data tables the injector loads at
    # runtime (capi-symbols*, offsets), and the default mod table. TTRFF_REPO points here.
    libexec.install "tray", "frida", "scripts", "modset.json",
                    "capi-symbols.json", "capi-symbols2.json", "offsets.json",
                    "config.json", "README.md", "STATUS.md"

    # Launcher: point the tray at the installed toolset and at a user-writable copy of the mod
    # table (the libexec one is a read-only default; the tray seeds the user copy on first run).
    (bin/"ttrff").write <<~SH
      #!/bin/bash
      export TTRFF_REPO="#{libexec}"
      export TTRMOD_MODSET="${TTRMOD_MODSET:-$HOME/Library/Application Support/ttrff/modset.json}"
      exec "#{libexec}/venv/bin/python" "#{libexec}/tray/ttrff_tray.py" "$@"
    SH
    (bin/"ttrff").chmod 0755
  end

  def caveats
    <<~EOS
      Start the menu-bar app (it lives in the menu bar, no window):
        ttrff

      Attaching to the hardened game engine needs root, so the injector is launched via
      `sudo -n` + the bundled signed runner. Passwordless sudo must be configured for it
      (the same requirement as running frida/run-injector.sh by hand).

      Your editable mod table (menu toggles edit this copy; seeded on first run):
        ~/Library/Application Support/ttrff/modset.json

      Cosmetic-only, for your own client and account. Do not distribute.
    EOS
  end

  test do
    assert_match "ttrff tray selftest", shell_output("#{bin}/ttrff --selftest")
  end
end
