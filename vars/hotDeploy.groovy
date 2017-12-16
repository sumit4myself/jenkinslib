def call(server, buildScriptDir, fileName) {
        sh "scp ${buildScriptDir}/install/*.sh ${server}:/opt/build/"
        sh "ssh -oStrictHostKeyChecking=no ${server} './opt/build/download.sh ${fileName}'"
        sh "ssh -oStrictHostKeyChecking=no ${server} './opt/build/start.sh ${fileName}'"
}