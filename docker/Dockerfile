FROM debian:bookworm
RUN apt update && apt install -y dh-make devscripts
RUN echo 'export USER=$(whoami)' >> ~/.bashrc
COPY ./pki_server/pki-server-0.1 /build/pki-server-0.1
WORKDIR /build/pki-server-0.1

RUN echo "y" | USER=root dh_make --indep --createorig -y
RUN cp -f debian_instructions/* debian/
RUN debuild -us -uc
CMD ["cp", "../pki-server_0.1-1_all.deb", "/output"]
