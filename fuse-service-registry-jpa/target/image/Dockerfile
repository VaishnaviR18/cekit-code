
# This is a Dockerfile for the fuse7-tech-preview/fuse-service-registry-jpa:1.6 image.


## START target image fuse7-tech-preview/fuse-service-registry-jpa:1.6
## \
    FROM registry-proxy.engineering.redhat.com/rh-osbs/fuse7-fuse-java-openshift:1.6


    USER root

###### START image 'fuse7-tech-preview/fuse-service-registry-jpa:1.6'
###### \
        # Copy 'fuse7-tech-preview/fuse-service-registry-jpa' image general artifacts to '/deployments/' destination
        COPY \
            apicurio-registry-storage-jpa-1.1.2.fuse-760006-redhat-00001-all.tar.gz \
            /deployments/
        # Set 'fuse7-tech-preview/fuse-service-registry-jpa' image defined environment variables
        ENV \
            APICURIO_VERSION="1.1.2.fuse-760006-redhat-00001" \
            JAVA_APP_DIR="/deployments" 
        # Set 'fuse7-tech-preview/fuse-service-registry-jpa' image defined labels
        LABEL \
            com.redhat.component="fuse-service-registry-jpa-container"  \
            description="An artifact registry for Schemas and API designs."  \
            io.cekit.version="3.11.0"  \
            io.k8s.description="An artifact registry for Schemas and API designs."  \
            io.k8s.display-name="Red Hat Integration Schema/API Registry"  \
            io.openshift.tags="fuse"  \
            maintainer="Eric Wittmann <ewittman@redhat.com>"  \
            summary="An artifact registry for Schemas and API designs." 
        # Exposed ports in 'fuse7-tech-preview/fuse-service-registry-jpa' image
        EXPOSE 8080 8778 9779
###### /
###### END image 'fuse7-tech-preview/fuse-service-registry-jpa:1.6'



    # Switch to 'root' user and remove artifacts and modules
    USER root
    RUN [ ! -d /tmp/scripts ] || rm -rf /tmp/scripts
    RUN [ ! -d /tmp/artifacts ] || rm -rf /tmp/artifacts
    # Define the user
    USER 185
## /
## END target image