### Installation

    host $ git clone git@github.com:agoraciudadana/agora-ciudadana-box.git
    host $ cd agora-ciudadana-box

Now you need to clone agora-ciudadana inside the cloned repo:

    host $ git clone git@github.com:agoraciudadana/agora-ciudadana.git
    host $ vagrant up

This folder (`agora-ciudadana-box`) will be mounted at `/vagrant` on the virtual machine.

Wait for the provisioning to finish, and you will have the service available at `http://localhost:8000/`

### Working

Now you can work on your `agora-ciudadana-box/agora-ciudadana` folder locally, run tests on the virtual machine,
and test the service on your navigator.

That's it !!
