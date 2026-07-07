class SnowbrosAtlas < Formula
  desc "Deterministic engineering intelligence for JavaScript/TypeScript codebases."
  homepage "https://github.com/snowbros-labs/atlas"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/snowbros-labs/atlas/releases/download/v0.2.2/snowbros-atlas-aarch64-apple-darwin.tar.gz"
      sha256 "c9c159cd7536731ca261e9879a56b6b00f115ae61c2feb59fcace3ec312b79ec"
    end
    if Hardware::CPU.intel?
      url "https://github.com/snowbros-labs/atlas/releases/download/v0.2.2/snowbros-atlas-x86_64-apple-darwin.tar.gz"
      sha256 "0c5f36d558c3010e1861f4d645e3685abbf7a9f7d2280aca78f15eef1455b7fa"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/snowbros-labs/atlas/releases/download/v0.2.2/snowbros-atlas-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "97800f3830ecf1b7596373ef10e8f1e2d3e73a6c65109ebf14747e1a80a7b92c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/snowbros-labs/atlas/releases/download/v0.2.2/snowbros-atlas-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0851dbef6d6c49b81861ed63f7a139243d76b0134263851114e0c16d5d9dc225"
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
