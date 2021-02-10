# kubernetes-emergency-postfix
Emergency kubernetes deployment of postfix

This is a working deployment of postfix using sqlite as a backend to catch incoming mail, it can be deployed with regular docker, docker-compose (but you'll have to write the yml) or kubernetes.

# Instructions
* Open port 25.

In kubernetes we just add this:

        ports: 
          - name: postfix
            containerPort: 25
            hostPort: 25
            protocol: TCP

The container takes the following environment vars:
* Domain (your root domain, without mail. eg just "example.com")
* Initial User
* Initial Password

To add more users you'll need to either edit run.sh or add them using the following sqlite command on the container

    INSERT INTO mailbox ( username, password, name, maildir, domain, local_part ) VALUES ( '$NAME@$DOMAIN', '$PASS', '$NAME', '$DOMAIN/$NAME@$DOMAIN/', '$DOMAIN', '$NAME' );

Obviously remember to replace the vars...

# Reading mail

You can read mail with mutt on the command line

* Find the container (kubectl get pods)
* Go into the container (kubectl exec -it postfix-..- -- bash)
* Run mutt -f /var/spool/virtualmailboxes/example.com/bill@example.com (replace bill and example.com with your own username/domain)

# Emergency Use Only

We needed a mail server up fast to retreive incoming email and store them for when we got our actual mail server back up and running... since we only had a kubernetes box we used that and something like this would have come in extremely handy. Hopefully it helps you too
