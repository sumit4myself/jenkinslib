def call(server, fileName) {
    sshagent(['educoresystems.com-id_rsa']) {
        sh "ssh -o StrictHostKeyChecking=no -o PubkeyAuthentication=no -l root  ${server} ./download.sh ${fileName}"
        sh "ssh -o StrictHostKeyChecking=no -o PubkeyAuthentication=no -l root  ${server} ./start.sh ${fileName}"
    }
}