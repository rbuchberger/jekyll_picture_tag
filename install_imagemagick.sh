# Configure and install imagemagick; detects if cached compiled version exists.

check_cached() {
  [ "$(find . -name '*.o')" ]
}

build_im() {
  git clone 'https://github.com/ImageMagick/ImageMagick' ./ \
     --branch "$imagemagick_version"

  rm -rf '.git'

  ./configure
  make
}

[ -d 'imagemagick' ] || mkdir imagemagick
cd imagemagick

check_cached || build_im

sudo make install
sudo ldconfig /usr/local/lib
