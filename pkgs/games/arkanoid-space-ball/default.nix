{ stdenv, fetchFromBitbucket, cmake, SDL, SDL_mixer, SDL_image, makeWrapper }:

stdenv.mkDerivation rec {
  name = "arkanoid-space-ball-${version}";
  version = "${version_major}.${version_minor}.${version_release}";
  version_major = "1";
  version_minor = "3";
  version_release = "7";

  src = fetchFromBitbucket {
    owner = "andreyu";  # Andrey Ugolnik
    repo = "arkanoid-space-ball";
    rev = "0d75695944deb883a2b1a17cca3f6af0f8b4b51c";
    sha256 = "05xmqh2rblpr921pmli4wv7y4nz33v93p3ncfff04p8kgipvnbil";
  };

  buildInputs = [ cmake SDL SDL_image SDL_mixer makeWrapper ];

  buildPhase = ''
    pwd
    
    echo "Building rescompiler..."
    pushd . 
    cd ../tools/rescompiler
    make
    popd


    echo "Compiling resources"
    pushd . 
    cd ../res
    ../tools/rescompiler/rescompiler arkanoidsb     # Generates the pak-file
    popd

    mkdir .build_release
    cd .build_release
    cmake -DCMAKE_BUILD_TYPE=Release -DAPP_VERSION_MAJOR:STRING=${version_major} -DAPP_VERSION_MINOR:STRING=${version_minor} -DAPP_VERSION_RELEASE:STRING=${version_release} -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON ..
    cd ..
    VERBOSE=1 make
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp arkanoidsb "$out/lib/arkanoidsb"

    pushd .
    mkdir -p $out/lib/res
    cd ../res
    cp *.png *.jpg *.jpeg *.wav *.ogg *.s3 *.pak *.bmp "$out/lib/res"
    popd

    makeWrapper "$out/lib/arkanoidsb" \
       "$out/bin/arkanoidsb" \
        --run "cd '$prefix/lib/res'"
  '';

  meta = {
    description = "Arkanoid: Space Ball is a Breakout-like game";
    longDescription = ''
        A 2D-game in which you destroy blocks. You are in control of a paddle and try to bounce the ball into the right direction and prevent it from going into the void behind that paddle.
        Arkanoid adds a lot of bonusses on the concept of the classic. This version is played from side-to-side. 
        '';
    homepage = http://www.ugolnik.info;
    license = stdenv.lib.licenses.unfree;
    platforms = with stdenv.lib.platforms.all;
  };    
}
