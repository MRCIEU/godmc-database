FROM openjdk:8-jre-alpine

RUN addgroup -S neo4j && adduser -S -H -h /var/lib/neo4j -G neo4j neo4j

ENV NEO4J_SHA256=af53823776645e11d04436a513368e7e417b515572d6228da6b2977c8490ffbb \
    NEO4J_TARBALL=neo4j-community-3.4.5-unix.tar.gz \
    NEO4J_EDITION=community
ARG NEO4J_URI=http://dist.neo4j.org/neo4j-community-3.4.5-unix.tar.gz

# COPY ./local-package/* /tmp/

RUN apk add --no-cache --quiet bash curl tini su-exec
RUN curl --fail --silent --show-error --location --remote-name ${NEO4J_URI}
RUN echo "${NEO4J_SHA256}  ${NEO4J_TARBALL}" | sha256sum -csw -
RUN tar --extract --file ${NEO4J_TARBALL} --directory /var/lib
RUN mv /var/lib/neo4j-* /var/lib/neo4j
RUN rm ${NEO4J_TARBALL}
RUN mv /var/lib/neo4j/data /data
RUN chown -R neo4j:neo4j /data
RUN chmod -R 777 /data
RUN chown -R neo4j:neo4j /var/lib/neo4j
RUN chmod -R 777 /var/lib/neo4j
RUN ln -s /data /var/lib/neo4j/data
RUN apk del curl


#RUN wget https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/download/3.2.3.6/apoc-3.2.3.6-all.jar
#RUN mv apoc-3.2.3.6-all.jar plugins/

ENV PATH /var/lib/neo4j/bin:$PATH

WORKDIR /var/lib/neo4j

VOLUME /data

COPY docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 7474 7473 7687

ENTRYPOINT ["/sbin/tini", "-g", "--", "/docker-entrypoint.sh"]
CMD ["neo4j"]
