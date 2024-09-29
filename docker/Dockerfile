FROM debian:bookworm
RUN apt update && apt install -y dh-make devscripts
RUN echo 'export USER=$(whoami)' >> ~/.bashrc
ARG FOLDER
ARG PACKAGE_NAME
COPY ./$FOLDER/$PACKAGE_NAME /build/$PACKAGE_NAME
WORKDIR /build/$PACKAGE_NAME

RUN echo "y" | USER=root dh_make --indep --createorig -y
RUN cp -f debian_instructions/* debian/
RUN debuild -us -uc
CMD ["bash", "-c", "cp ../*.deb /output"]
