class SnowbrosAtlas < Formula
  desc "Deterministic engineering intelligence for JavaScript/TypeScript codebases."
  homepage "https://github.com/snowbros-labs/atlas"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/snowbros-labs/atlas/releases/download/v0.1.0/snowbros-atlas-aarch64-apple-darwin.tar.gz"
      sha256 "a230fee100db51dc71fb0a2622d29ab44fdb16984181426187bf254fb3d48061"
    end
    if Hardware::CPU.intel?
      url "https://github.com/snowbros-labs/atlas/releases/download/v0.1.0/snowbros-atlas-x86_64-apple-darwin.tar.gz"
      sha256 "87145411c266a37cb355aa2715c8dc35c48c60c2d5d5de0124ce80173129bab2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/snowbros-labs/atlas/releases/download/v0.1.0/snowbros-atlas-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "afa60773aa6c5d661a8ef2cbc4800460e9b1c5863413e18af76e9f85bd46b51a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/snowbros-labs/atlas/releases/download/v0.1.0/snowbros-atlas-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a97c90a74cb2a6bd4b8ee7ae79346ad80377732d47e73b8616fd92c92d26317a"
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
