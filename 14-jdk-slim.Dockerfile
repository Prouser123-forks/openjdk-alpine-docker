FROM alpine:3.12

# Set env variables for java to work properly
ENV JAVA_HOME=/opt/java/openjdk \
    PATH="/opt/java/openjdk/bin:$PATH" \
	GLIBC_VERSION="2.31-r1"

COPY slim-java-14/slim-java* /usr/local/bin/

RUN mkdir -p /lib /lib64 /usr/glibc-compat/lib/locale /usr/glibc-compat/lib64 /etc; \
	apk add --no-cache --virtual .fetch-deps curl binutils; \
		ARCH="$(apk --print-arch)"; \
		case "${ARCH}" in \
		aarch64|arm64) \
			ESUM='81ca31ad90f9bd789a2ca1753d6d83d10f4927876b4a4b9f4b1c4c8cbce85feb'; \
			BINARY_URL='https://github.com/AdoptOpenJDK/openjdk14-binaries/releases/download/jdk-14.0.1%2B7/OpenJDK14U-jdk_aarch64_linux_hotspot_14.0.1_7.tar.gz'; \
			ZLIB_URL='http://ports.ubuntu.com/ubuntu-ports/pool/main/z/zlib/zlib1g_1.2.11.dfsg-2ubuntu1_arm64.deb'; \
			GLIBC_ARCH='aarch64'; \
			glibc_setup () { \
				ln -s /usr/glibc-compat/lib/ld-linux-aarch64.so.1 /lib/ld-linux-aarch64.so.1; \
				ln -s /usr/glibc-compat/lib/ld-linux-aarch64.so.1 /lib64/ld-linux-aarch64.so.1; \
				ln -s /usr/glibc-compat/lib/ld-linux-aarch64.so.1 /usr/glibc-compat/lib64/ld-linux-aarch64.so.1; \
				ln -s /usr/glibc-compat/etc/ld.so.cache /etc/ld.so.cache; \
				# ln -sfn /lib/libc.musl-x86_64.so.1 /usr/glibc-compat/lib; \
			}; \
			;; \
			# Download glibc and link
		armhf|armv7l|armv7) \
			ESUM='458d091756500dc3013737aa182a14752b3d4ffc358d09532201874ffb8cae22'; \
			BINARY_URL='https://github.com/AdoptOpenJDK/openjdk14-binaries/releases/download/jdk-14.0.1%2B7/OpenJDK14U-jdk_arm_linux_hotspot_14.0.1_7.tar.gz'; \
			ZLIB_URL='http://ports.ubuntu.com/ubuntu-ports/pool/main/z/zlib/zlib1g_1.2.11.dfsg-2ubuntu1_armhf.deb'; \
			GLIBC_ARCH='armhf'; \
			glibc_setup () { \
				ln -s /usr/glibc-compat/lib/ld-linux-armhf.so.3 /lib/ld-linux-armhf.so.3; \
				ln -s /usr/glibc-compat/lib/ld-linux-armhf.so.3 /lib64/ld-linux-armhf.so.3; \
				ln -s /usr/glibc-compat/lib/ld-linux-armhf.so.3 /usr/glibc-compat/lib64/ld-linux-armhf.so.3; \
				ln -s /usr/glibc-compat/etc/ld.so.cache /etc/ld.so.cache; \
				# ln -sfn /lib/libc.musl-x86_64.so.1 /usr/glibc-compat/lib; \
			}; \
			;; \
		ppc64el|ppc64le) \
			ESUM='bfdd77112d81256d4e1a859a465dd4dcb670019a5d6cf8260c30e24a0e5947e4'; \
			BINARY_URL='https://github.com/AdoptOpenJDK/openjdk14-binaries/releases/download/jdk-14.0.1%2B7/OpenJDK14U-jdk_ppc64le_linux_hotspot_14.0.1_7.tar.gz'; \
			ZLIB_URL='http://ports.ubuntu.com/ubuntu-ports/pool/main/z/zlib/zlib1g_1.2.11.dfsg-2ubuntu1_ppc64el.deb'; \
			GLIBC_ARCH='ppc64le'; \
			glibc_setup () { \
				ln -s /usr/glibc-compat/lib/ld-linux-powerpc64le.so.2 /lib/ld-linux-powerpc64le.so.2; \
				ln -s /usr/glibc-compat/lib/ld-linux-powerpc64le.so.2 /lib64/ld-linux-powerpc64le.so.2; \
				ln -s /usr/glibc-compat/lib/ld-linux-powerpc64le.so.2 /usr/glibc-compat/lib64/ld-linux-powerpc64le.so.2; \
				ln -s /usr/glibc-compat/etc/ld.so.cache /etc/ld.so.cache; \
				# ln -sfn /lib/libc.musl-x86_64.so.1 /usr/glibc-compat/lib; \
				# Special case for ppc64le.
				ln -s /usr/glibc-compat/lib/ld64.so.2 /lib/ld64.so.2; \
				ln -s /usr/glibc-compat/lib/ld64.so.2 /lib64/ld64.so.2; \
			}; \
			;; \
		s390x) \
			ESUM='c13545924e92cb9d495282e95270f299a28d5466f9741c67791f131c38ebbd0c'; \
			BINARY_URL='https://github.com/AdoptOpenJDK/openjdk14-binaries/releases/download/jdk-14.0.1%2B7/OpenJDK14U-jdk_s390x_linux_hotspot_14.0.1_7.tar.gz'; \
			ZLIB_URL='http://ports.ubuntu.com/ubuntu-ports/pool/main/z/zlib/zlib1g_1.2.11.dfsg-2ubuntu1_s390x.deb'; \
			GLIBC_ARCH='s390x'; \
			glibc_setup () { \
				ln -s /usr/glibc-compat/lib/ld-linux-s390x.so.2 /lib/ld-linux-s390x.so.2; \
				ln -s /usr/glibc-compat/lib/ld-linux-s390x.so.2 /lib64/ld-linux-s390x.so.2; \
				ln -s /usr/glibc-compat/lib/ld-linux-s390x.so.2/usr/glibc-compat/lib64/ld-linux-s390x.so.2; \
				ln -s /usr/glibc-compat/etc/ld.so.cache /etc/ld.so.cache; \
				# ln -sfn /lib/libc.musl-x86_64.so.1 /usr/glibc-compat/lib; \
				# Special case for s390x.
				ln -s /usr/glibc-compat/lib/ld64.so.1 /lib/ld64.so.1; \
				ln -s /usr/glibc-compat/lib/ld64.so.1 /lib64/ld64.so.1; \
			}; \
			;; \
		amd64|x86_64) \
			ESUM='9ddf9b35996fbd784a53fff3e0d59920a7d5acf1a82d4c8d70906957ac146cd1'; \
			BINARY_URL='https://github.com/AdoptOpenJDK/openjdk14-binaries/releases/download/jdk-14.0.1%2B7/OpenJDK14U-jdk_x64_linux_hotspot_14.0.1_7.tar.gz'; \
			ZLIB_URL='http://archive.ubuntu.com/ubuntu/pool/main/z/zlib/zlib1g_1.2.11.dfsg-2ubuntu1_amd64.deb'; \
			GLIBC_ARCH='x86_64'; \
			glibc_setup () { \
				ln -s /usr/glibc-compat/lib/ld-linux-x86-64.so.2 /lib/ld-linux-x86-64.so.2; \
				ln -s /usr/glibc-compat/lib/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2; \
				ln -s /usr/glibc-compat/lib/ld-linux-x86-64.so.2 /usr/glibc-compat/lib64/ld-linux-x86-64.so.2; \
				ln -s /usr/glibc-compat/etc/ld.so.cache /etc/ld.so.cache; \
				ln -sfn /lib/libc.musl-x86_64.so.1 /usr/glibc-compat/lib; \
			}; \
			;; \
		*) \
			echo "Unsupported arch: ${ARCH}"; \
			exit 1; \
			;; \
		esac; \
		# Download glibc from repo
		wget -O- https://github.com/Prouser123/docker-glibc-multiarch-builder/releases/download/jcx-${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}-${GLIBC_ARCH}.tar.gz | tar zxvf - -C /; \
		# Link glibc
		glibc_setup; \
		
		# Download additional files
		wget https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/ld.so.conf -O /usr/glibc-compat/etc/ld.so.conf; \
	wget https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/nsswitch.conf -O /etc/nsswitch.conf; \
		
		# Download OpenJDK
		curl -LfsSo /tmp/openjdk.tar.gz ${BINARY_URL}; \
		echo "${ESUM} */tmp/openjdk.tar.gz" | sha256sum -c -; \
		mkdir -p /opt/java/openjdk; \
		cd /opt/java/openjdk; \
		tar -xf /tmp/openjdk.tar.gz --strip-components=1; \
		
		# Download zlib
		mkdir -p /tmp/zlib; \
		cd /tmp/zlib; \
		wget -O zlib.deb ${ZLIB_URL}; \
		ar vx zlib.deb; \
		tar xvf data.tar.xz; \
		mv lib/$(ls lib)/* /usr/glibc-compat/lib/; \
		
		# OpenJDK - Slim Java
		chmod +x /usr/local/bin/slim-java.sh; \
		apk add --no-cache --virtual .build-deps bash binutils; \
		/usr/local/bin/slim-java.sh /opt/java/openjdk/; \
		apk del --purge .build-deps; \
		
		# Run strip on stuff
		strip /usr/glibc-compat/sbin/**; \
		strip /usr/glibc-compat/lib64/**; \
		strip /usr/glibc-compat/lib/** || echo 'Probably done with errors'; \
		strip /usr/glibc-compat/lib/*/* || echo 'Probably done with errors'; \
		
		# Remove unused files (https://github.com/sgerrand/alpine-pkg-glibc/blob/master/APKBUILD)
		rm "$pkgdir"/usr/glibc-compat/etc/rpc; \
		rm -rf /usr/glibc-compat/bin; \
		rm -rf /usr/glibc-compat/sbin; \
		rm -rf /usr/glibc-compat/lib/gconv; \
		rm -rf /usr/glibc-compat/lib/getconf; \
		rm -rf /usr/glibc-compat/lib/audit; \
		rm -rf /usr/glibc-compat/share; \
		rm -rf /usr/glibc-compat/var; \
		
		# Remove object files and static libraries. (https://blog.gilliard.lol/2018/11/05/alpine-jdk11-images.html)
		rm -rf /usr/glibc-compat/*.o; \
		rm -rf /usr/glibc-compat/*.a; \
		rm -rf /usr/glibc-compat/*/*.o; \
		rm -rf /usr/glibc-compat/*/*.a; \
		
		# Cleaning up...
		apk del --purge .fetch-deps; \
		rm -rf /var/cache/apk/*; \
		rm -rf /tmp/openjdk.tar.gz; \
		rm -rf /tmp/zlib; \
		echo "Done!"; \
		cd /; \
		java -version;