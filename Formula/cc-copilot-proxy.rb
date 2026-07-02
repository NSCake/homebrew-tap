class CcCopilotProxy < Formula
  desc "Use Claude in VS Code Copilot on your Claude Code subscription (personal proxy)"
  homepage "https://github.com/NSExceptional/cc-copilot-proxy"
  head "https://github.com/NSExceptional/cc-copilot-proxy.git", branch: "main"
  license :cannot_represent

  depends_on "node"

  def install
    libexec.install "cc-copilot-proxy.mjs"

    # Wrapper: load the Claude Code subscription OAuth token from a 0600 file
    # (unless already in the environment), then run the proxy on brew's node.
    (buildpath/"cc-copilot-proxy").write <<~SH
      #!/bin/bash
      tok_file="${CC_PROXY_TOKEN_FILE:-$HOME/.config/cc-copilot-proxy/token}"
      if [ -z "${CLAUDE_CODE_OAUTH_TOKEN:-}" ] && [ -f "$tok_file" ]; then
        CLAUDE_CODE_OAUTH_TOKEN="$(cat "$tok_file")"
        export CLAUDE_CODE_OAUTH_TOKEN
      fi
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/cc-copilot-proxy.mjs" "$@"
    SH
    bin.install "cc-copilot-proxy"
  end

  service do
    run [opt_bin/"cc-copilot-proxy"]
    keep_alive true
    environment_variables CC_PROXY_PORT: "8788"
    log_path var/"log/cc-copilot-proxy.log"
    error_log_path var/"log/cc-copilot-proxy.log"
  end

  def caveats
    <<~EOS
      One-time per machine:

        1) Save your subscription token (0600):
             claude setup-token
             mkdir -p ~/.config/cc-copilot-proxy
             printf '%s' 'PASTE_TOKEN' > ~/.config/cc-copilot-proxy/token
             chmod 600 ~/.config/cc-copilot-proxy/token

        2) Start it (also auto-starts at login):
             brew services start cc-copilot-proxy

        3) Add the Custom Endpoint model in VS Code pointing at
           http://127.0.0.1:8788/v1/messages  (see the tap README).

      Update later:  brew update && brew upgrade --fetch-HEAD cc-copilot-proxy
    EOS
  end

  test do
    assert_predicate bin/"cc-copilot-proxy", :exist?
  end
end
