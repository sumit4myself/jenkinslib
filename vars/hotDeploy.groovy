def call(server, fileName) {
    sshagent(['educoresystems.in-id_rsa']) {
       

        ssh-add -L
    }
}