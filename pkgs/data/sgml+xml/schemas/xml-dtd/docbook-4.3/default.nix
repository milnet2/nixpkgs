{stdenv, fetchurl, unzip}:

assert unzip != null;

stdenv.mkDerivation {
  name = "docbook-xml-4.3";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.docbook.org/xml/4.3/docbook-xml-4.3.zip;
    md5 = "ab200202b9e136a144db1e0864c45074";
  };
  buildInputs = [unzip];
}
