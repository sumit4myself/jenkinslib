def call(server, fileName) {
    sshagent(['educoresystems.in-id_rsa']) {
        sh "ssh -o StrictHostKeyChecking=no -o PubkeyAuthentication=no -l jenkins  ${server} ./download.sh ${fileName}"
        sh "ssh -o StrictHostKeyChecking=no -o PubkeyAuthentication=no -l jenkins  ${server} ./start.sh ${fileName}"
    }
}