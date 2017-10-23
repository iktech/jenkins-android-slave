FROM eu.gcr.io/track-my-trip-1314/jenkins-slave:latest

RUN cd /opt

RUN mkdir android-sdk-linux && cd android-sdk-linux/

RUN apt-get update -qq \
  && apt-get install -y openjdk-8-jdk \
  && apt-get install -y wget \
  && apt-get install -y expect \
  && apt-get install -y zip \
  && apt-get install -y unzip \
  && rm -rf /var/lib/apt/lists/*

RUN wget https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip

RUN unzip sdk-tools-linux-3859397.zip -d /opt/android-sdk-linux

RUN rm -rf sdk-tools-linux-3859397.zip

ENV ANDROID_HOME /opt/android-sdk-linux

ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/platform-tools/bin

RUN sdkmanager "platform-tools" | grep done

# SDKs
# Please keep these in descending order!
RUN sdkmanager "platforms;android-26" | grep done
RUN sdkmanager "platforms;android-25" | grep done
RUN sdkmanager "platforms;android-24" | grep done
RUN sdkmanager "platforms;android-23" | grep done
RUN sdkmanager "platforms;android-18" | grep done
RUN sdkmanager "platforms;android-16" | grep done
RUN sdkmanager "platforms;android-14" | grep done

# build tools
# Please keep these in descending order!
RUN sdkmanager "build-tools;26.0.2" | grep done
RUN sdkmanager "build-tools;26.0.1" | grep done
RUN sdkmanager "build-tools;26.0.0" | grep done
RUN sdkmanager "build-tools;25.0.3" | grep done
RUN sdkmanager "build-tools;25.0.2" | grep done
RUN sdkmanager "build-tools;25.0.1" | grep done
RUN sdkmanager "build-tools;25.0.0" | grep done
RUN sdkmanager "build-tools;24.0.3" | grep done
RUN sdkmanager "build-tools;24.0.2" | grep done
RUN sdkmanager "build-tools;24.0.1" | grep done
RUN sdkmanager "build-tools;24.0.0" | grep done
RUN sdkmanager "build-tools;23.0.3" | grep done
RUN sdkmanager "build-tools;23.0.2" | grep done
RUN sdkmanager "build-tools;23.0.1" | grep done

RUN sdkmanager --list

# Update SDK
# This is very important. Without this, your builds wouldn't run. Your image would aways get this error:
# You have not accepted the license agreements of the following SDK components:
# [Android SDK Build-Tools 24, Android SDK Platform 24]. Before building your project,
# you need to accept the license agreements and complete the installation of the missing
# components using the Android Studio SDK Manager. Alternatively, to learn how to transfer the license agreements
# from one workstation to another, go to http://d.android.com/r/studio-ui/export-licenses.html

#So, we need to add the licenses here while it's still valid.
# The hashes are sha1s of the licence text, which I imagine will be periodically updated, so this code will
# only work for so long.
RUN mkdir "$ANDROID_HOME/licenses" || true
RUN echo -e "8933bad161af4178b1185d1a37fbf41ea5269c55\nd56f5187479451eabf01fb78af6dfcb131a6481e" > "$ANDROID_HOME/licenses/android-sdk-license"
RUN echo -e "84831b9409646a918e30573bab4c9c91346d8abd" > "$ANDROID_HOME/licenses/android-sdk-preview-license"
RUN echo -e "d975f751698a77b662f1254ddbeed3901e976f5a" > "$ANDROID_HOME/licenses/intel-android-extra-license"

RUN apt-get clean

RUN chown -R 1000:1000 $ANDROID_HOME

RUN mkdir -p /root/.android
RUN mkdir -p /root/.gradle
COPY release.keystore /root/.android/
COPY repositories.cfg /root/.android/
COPY gradle.properties /root/.gradle/


VOLUME ["/opt/android-sdk-linux"]

