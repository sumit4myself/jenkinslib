def call(server, fileName) {
        sh "scp download.sh ${server}:/opt/build/"
        sh "scp start.sh ${server}:/opt/build/"
        sh "ssh -oStrictHostKeyChecking=no ${server} './opt/build/download.sh ${fileName}'"
        sh "ssh -oStrictHostKeyChecking=no ${server} './opt/build/start.sh ${fileName}'"
}