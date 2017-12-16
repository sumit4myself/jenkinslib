def call(server, fileName) {
        sh "ssh jenkins@${server} './download.sh ${fileName}'"
        sh "ssh jenkins@${server} './start.sh ${fileName}'"
}