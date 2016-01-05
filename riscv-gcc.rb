require "formula"

class RiscvGcc < Formula
  homepage "http://riscv.org"
  url "https://github.com/riscv/riscv-gnu-toolchain.git"

  bottle do
    root_url 'http://riscv.org.s3.amazonaws.com/bottles'
    revision 1
    sha256 "bd8a59f2e8aa0c4773867c24e9900ee10b65ed8e6b98da7d269bf644299b62e4" => :el_capitan

  option "with-multilib", "Build with multilib support"

  depends_on "gawk" => :build
  depends_on "gnu-sed" => :build
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "libmpc"

  # disable superenv's flags
  env :std

  def install
    # disable crazy flag additions
    ENV.delete 'CFLAGS'
    ENV.delete 'CXXFLAGS'
    ENV.delete 'LD'

    args = ["--prefix=#{prefix}"]
    args << "--enable-multilib" if build.with?("multilib")
    system "mkdir", "build"
    cd "build" do
      system "../configure", *args
      system "make"
    end

    if File.exist?("#{HOMEBREW_PREFIX}/share/gcc-5.3.0/")
      system "rm", "-rf", "#{prefix}/share"
    end
  end

  test do
    system "false"
  end
end
