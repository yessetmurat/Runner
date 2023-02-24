FROM gradle:7-jdk11

ARG RUNNER_VERSION
ARG RUNNER_ARCH
ARG ANDROID_SDK_VERSION=9477386
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH=${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/cmdline-tools/tools/bin:${ANDROID_SDK_ROOT}/platform-tools:${ANDROID_SDK_ROOT}/emulator
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && apt-get upgrade -y

RUN apt-get install -y --no-install-recommends \
    curl unzip git build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip jq gh && \
    rm -rf /var/lib/apt/lists/*

RUN chown -R gradle:gradle /opt

USER gradle

RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    curl -O -L https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_VERSION}_latest.zip && \
    unzip commandlinetools*linux*.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools && \
    mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/tools && \
    rm commandlinetools*linux*.zip

RUN yes | sdkmanager --licenses
    # sdkmanager "build-tools;30.0.2" "emulator"

RUN mkdir -p /home/gradle/actions-runner && \
    curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz && \
    tar -xzf actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz -C /home/gradle/actions-runner && \
    rm actions-runner*.tar.gz

USER root

RUN /home/gradle/actions-runner/bin/installdependencies.sh

USER gradle

COPY scripts/start.sh start.sh

ENTRYPOINT ["./start.sh"]
