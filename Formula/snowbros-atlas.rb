class SnowbrosAtlas < Formula
  desc "Deterministic engineering intelligence for JavaScript/TypeScript codebases."
  homepage "https://github.com/snowbros-labs/atlas"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/snowbros-labs/atlas/releases/download/v0.3.0/snowbros-atlas-aarch64-apple-darwin.tar.gz"
      sha256 "66e21f9bb0af0ca258a028acb5557ff2170cb6c0b9d7690ff4786aec776a52b7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/snowbros-labs/atlas/releases/download/v0.3.0/snowbros-atlas-x86_64-apple-darwin.tar.gz"
      sha256 "013f0290a2c3fa2c528182ffd25c488152469076cd974baa227eddf2ae015e6b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/snowbros-labs/atlas/releases/download/v0.3.0/snowbros-atlas-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c0637887f473e23754fe67a161eaf68be74ae11305469da0d075e66928879456"
    end
    if Hardware::CPU.intel?
      url "https://github.com/snowbros-labs/atlas/releases/download/v0.3.0/snowbros-atlas-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4074b4f0775b194158a7f3e796d7a5ad196c7435f2bde9ed03307cf19dda7765"
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
