FROM java:openjdk-8u72-jdk

MAINTAINER darren@hotshots.xyz
LABEL version="1.0"
LABEL description="Ionic 2 development environment sans XCode"
LABEL github="https://github.com/Hotshotsteam/ionic2-up"

ENV LANG C.UTF-8

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -

RUN apt-get update && apt-get install -y --no-install-recommends \
      nodejs \
      unzip \
      lib32z1 \
      lib32ncurses5 \
      lib32stdc++6 \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir $HOME/install && \
    ANDROID_HOME=$HOME/android && \
    SDK='https://dl.google.com/android/repository' && \
    echo \
      http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz \
      $SDK/platform-tools_r23.1.0-linux.zip \
      $SDK/tools_r25.1.6-linux.zip \
      $SDK/build-tools_r23.0.3-linux.zip \
      | tr " " "\n" \
      | wget -q -P $HOME/install -i - && \
    tar zxvf $HOME/install/android-sdk_r24.4.1-linux.tgz -C $HOME/install && \
    mv $HOME/install/android-sdk-linux $ANDROID_HOME && \
    rm -Rf $ANDROID_HOME/tools && \
    mkdir -p $ANDROID_HOME/build-tools && \
    mkdir -p $ANDROID_HOME/platforms && \
    unzip "$HOME/install/*.zip" -d $ANDROID_HOME && \
    mv $ANDROID_HOME/android-6.0 $ANDROID_HOME/build-tools/23.0.3 && \
    wget -q $SDK/platform-23_r03.zip -P $HOME/install && \
    unzip $HOME/install/platform-23_r03.zip -d $ANDROID_HOME && \
    mv $ANDROID_HOME/android-6.0 $ANDROID_HOME/platforms/android-23 && \
    rm -Rf $HOME/install && \
    printf \
      "\nANDROID_HOME=\$HOME/android\nPATH=\$PATH:\$ANDROID_HOME/platform-tools:\$ANDROID_HOME/tools\nexport ANDROID_HOME\n" \
      >> $HOME/.bashrc

ADD ./70-android.rules /etc/udev/rules.d/70-android.rules

ENV ANDROID_HOME /root/android

ENV PATH $ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$PATH

RUN npm install -g cordova
RUN npm install -g typings
RUN npm install -g tsc
RUN npm install -g ionic@2.0.0-beta.30

WORKDIR /project

EXPOSE 8100 35792 5037
