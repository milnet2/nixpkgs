{stdenv, genericStdenv, gccWrapper}:

genericStdenv {
  name = "stdenv-native";
  preHook = ./prehook.sh;
  initialPath = "/usr/local /usr /";

  inherit stdenv;

  gcc = gccWrapper {
    name = "gcc-native";
    nativeTools = true;
    nativeGlibc = true;
    nativePrefix = "/usr";
    inherit stdenv;
  };

  shell = "/bin/sh";
}
