Kuali Student Bundled Application
=================================

Expects an oracle database to be provisioned and setup with the same nightly build tag.

See the instructions at https://github.com/mocleiri/ks-bundled-impex on how the database
can be provisioned.

Assuming that the db has the container name of *oracle*:
```
$ docker run -d -t --link oracle:db kualistudent/bundled-app:build-917
```

Following environment variables are supported:

Environment Variable | Default Value | Comment
--- | --- | ---
`ORACLE_DBA_URL` | jdbc:oracle:thin:@localhost:1521:XE | URL to Oracle Database
`ORACLE_DBA_PASSWORD` | oracle | Oracle DBA Password (Default is for wnameless)

If the docker link is created the *ORACLE_DBA_URL* is autoconfigured based on the IPAddress of the running database container.

Monitor the catalina.out file using:

```
$ docker logs -f <app container id>
```



