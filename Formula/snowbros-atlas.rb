class SnowbrosAtlas < Formula
  desc "Deterministic engineering intelligence for JavaScript/TypeScript codebases."
  homepage "https://github.com/snowbros-labs/atlas"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/snowbros-labs/atlas/releases/download/v0.2.0/snowbros-atlas-aarch64-apple-darwin.tar.gz"
      sha256 "e1d5c42828eaa6762b001ecf711b598aa23607f99a6163fc707cb61c91305223"
    end
    if Hardware::CPU.intel?
      url "https://github.com/snowbros-labs/atlas/releases/download/v0.2.0/snowbros-atlas-x86_64-apple-darwin.tar.gz"
      sha256 "34f23912a04cafe8c8f04074343048718acd4c155094296adaa83383a17508ec"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/snowbros-labs/atlas/releases/download/v0.2.0/snowbros-atlas-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1546df2b3b572d6f9551a050fcbbb231aafa0b6d93a774420da11cd130177dfa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/snowbros-labs/atlas/releases/download/v0.2.0/snowbros-atlas-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1a95e86f4e4fad6c6be6ca2b77972ae87efa60284eed3270d9aed8110d4c270a"
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
