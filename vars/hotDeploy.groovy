def call(server, buildScriptDir, fileName) {
        sh "scp ${buildScriptDir}/download.sh ${server}:/opt/build/"
        sh "scp ${buildScriptDir}start.sh ${server}:/opt/build/"
        sh "ssh -oStrictHostKeyChecking=no ${server} './opt/build/download.sh ${fileName}'"
        sh "ssh -oStrictHostKeyChecking=no ${server} './opt/build/start.sh ${fileName}'"
}