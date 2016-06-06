#Demo of falco with man-in-the-middle attacks on installation scripts

For a blog post that provides the context for this demo, go [here](./XXX).

## Demo architecture

### Initial setup

Make sure no prior `botnet_client.py` processes are lying around.

### Start everything using docker-compose

From this directory, run the following:

```
$ docker-compose -f demo.yml up
```

This starts the following containers:
* apache: the legitimate web server, serving files from `.../mitm-sh-installer/web_root`, specifically the file `install-software.sh`.
* nginx: the reverse proxy, configured with the config file `.../mitm-sh-installer/nginx.conf`.
* evil_apache: the "evil" web server, serving files from `.../mitm-sh-installer/evil_web_root`, specifically the file `botnet_client.py`.
* attacker_botnet_master: constantly trying to contact the botnet_client.py process.
* falco: will detect the activities of botnet_client.py.

### Download `install-software.sh`, see botnet client running

Run the following to fetch and execute the installation script,
which also installs the botnet client:

```
$ curl http://localhost/install-software.sh | bash
```

You'll see messages about installing the software. (The script doesn't actually install anything, the messages are just for demonstration purposes).

Now look for all python processes and you'll see the botnet client running. You can also telnet to port 1234:

```
$ ps auxww  | grep python
...
root   19983  0.1  0.4  33992  8832 pts/1    S    13:34   0:00 python ./rootkit_loader.py

$ telnet localhost 1234
Trying ::1...
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
```

You'll also see messages in the docker-compose output showing that attacker_botnet_master can reach the client:

XXX/mstemm fill in.

At this point, kill the botnet_client.py process to clean things up.

### Run installation script again using `fbash`, note falco warnings.

If you run the installation script again:

```
curl http://localhost/install-software.sh | ./fbash
```

You'll see the following falco warnings:

```
XXX/mstemm update w/ latest warnings.
13:34:50.694058959: Warning unexpected listen call by a process in a fbash session (python fd=0(<f>/dev/null) backlog=5 )
13:34:50.694066098: Warning unexpected listen call by a process in a fbash session (python res=0 )
```
