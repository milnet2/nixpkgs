{stdenv, fetchurl, noSysDirs}:

stdenv.mkDerivation {
  name = "binutils-2.14";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nl.net/pub/gnu/binutils/binutils-2.14.tar.bz2;
    md5 = "2da8def15d28af3ec6af0982709ae90a";
  };
  inherit noSysDirs;
}
