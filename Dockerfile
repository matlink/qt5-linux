FROM ubuntu:bionic

RUN apt-get -qq update
RUN apt-get -qq install -y --no-install-recommends python \
		libx11-dev libxfixes-dev libxi-dev \
		libxcb1-dev libx11-xcb-dev libxcb-glx0-dev \
		libdbus-1-dev libxkbcommon-dev libxkbcommon-x11-dev \
		zlib1g-dev libgl1-mesa-dev libfontconfig1-dev \
		build-essential wget libssl1.0-dev > /dev/null

RUN apt-get -y clean && rm -rf /var/cache/apt/* /var/lib/apt/lists/*

ENV QT_MAJOR 5
ENV QT_MINOR 9
ENV QT_PATCH 1
ENV QT_NAME qt-everywhere-opensource-src-${QT_MAJOR}.${QT_MINOR}.${QT_PATCH}
RUN wget http://download.qt.io/official_releases/qt/${QT_MAJOR}.${QT_MINOR}/${QT_MAJOR}.${QT_MINOR}.${QT_PATCH}/single/${QT_NAME}.tar.xz

RUN tar xJf ${QT_NAME}.tar.xz
RUN rm ${QT_NAME}.tar.xz
WORKDIR ${QT_NAME}
RUN ./configure -silent -static -release -no-compile-examples -prefix /usr/local \
		-opensource -confirm-license \
		-skip qt3d \
		-skip qtactiveqt \
		-skip qtandroidextras \
		-skip qtcanvas3d \
		-skip qtconnectivity \
		-skip qtdatavis3d \
		-skip qtdoc \
		-skip qtgamepad \
		-skip qtimageformats \
		-skip qtlocation \
		-skip qtmacextras \
		-skip qtmultimedia \
		-skip qtnetworkauth \
		-skip qtpurchasing \
		-skip qtscript \
		-skip qtscxml \
		-skip qtsensors \
		-skip qtserialport \
		-skip qtspeech \
		-skip qttools \
		-skip qtvirtualkeyboard \
		-skip qtwayland \
		-skip qtwebchannel \
		-skip qtwebengine \
		-skip qtwebsockets \
		-skip qtwebview \
		-skip qtwinextras \
		-skip qtxmlpatterns \
		-c++std c++11 \
                -fontconfig \
		-no-gif -no-icu -no-glib -no-qml-debug \
		-opengl desktop -no-eglfs -no-opengles3 -no-angle -no-egl \
		-qt-xcb -qt-xkbcommon \
		-openssl-runtime -dbus-runtime \
		-qt-freetype -qt-pcre -qt-harfbuzz -qt-libpng -qt-libjpeg \
		-system-zlib -system-freetype

RUN make -s -j`nproc`
RUN make -s install
WORKDIR /
RUN rm -rf /${QT_NAME}
