FROM debian:stable-slim
RUN apt-get update && apt-get install -y \
	inkscape \
	openscad \
	pstoedit \
	&& rm -rf /var/lib/apt/lists/*
RUN mkdir -p /root/.local/share  # Avoids errors from boost
WORKDIR /build
