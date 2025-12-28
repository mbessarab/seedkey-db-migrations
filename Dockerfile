FROM liquibase/liquibase:4.27.0-alpine

COPY liquibase/ /liquibase/

WORKDIR /liquibase

ENTRYPOINT ["liquibase", "--changeLogFile=changelogs/root.changelog.xml"]
CMD ["update"]
