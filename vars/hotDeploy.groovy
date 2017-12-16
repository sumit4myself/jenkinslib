def call(server, fileName) {
        sh "ssh -oStrictHostKeyChecking=no ${server} './download.sh ${fileName}'"
        sh "ssh -oStrictHostKeyChecking=no ${server} './start.sh ${fileName}'"
}