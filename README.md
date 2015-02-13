Kuali Student Bundled Application
=================================

The Kuali Student as a Java project is now defunct but this Dockerfile will setup its final milestone, build 917 from October 2014.

Originally this dockerfile would work for any build tag but the online resources have started to dissappear so its now hardcoded for the final build.

The app expects an oracle database to be provisioned and setup with the same nightly build tag.

See the instructions at https://github.com/mocleiri/ks-bundled-impex on how the database
can be provisioned.

Assuming that the db has the container name of *oracle*:
```
$ docker run -d -t --link oracle:db kualistudent/bundled-app
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



