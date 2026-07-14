class SnowbrosAtlas < Formula
  desc "Deterministic engineering intelligence for JavaScript/TypeScript codebases."
  homepage "https://github.com/snowbros-labs/atlas"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/snowbros-labs/atlas/releases/download/v0.4.0/snowbros-atlas-aarch64-apple-darwin.tar.gz"
      sha256 "a80566ddb551ad596a88c56c29448a8767082255d597995306cbba701907ea08"
    end
    if Hardware::CPU.intel?
      url "https://github.com/snowbros-labs/atlas/releases/download/v0.4.0/snowbros-atlas-x86_64-apple-darwin.tar.gz"
      sha256 "3d12e51fafa500def0556d783062a749f323b15bd1e07b3696e690d15c0a19c2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/snowbros-labs/atlas/releases/download/v0.4.0/snowbros-atlas-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b1c3b5d9f62488d555cf70f21e0a3fa30d4c09ae3ea500bd70ed271d4ce8e76f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/snowbros-labs/atlas/releases/download/v0.4.0/snowbros-atlas-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "08f66da02d60e8735a0d40c7f9b5f576db2aeccb450cebb08c31dd5e7506bce4"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "sb", "snowbros" if OS.mac? && Hardware::CPU.arm?
    bin.install "sb", "snowbros" if OS.mac? && Hardware::CPU.intel?
    bin.install "sb", "snowbros" if OS.linux? && Hardware::CPU.arm?
    bin.install "sb", "snowbros" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
