def call(server, buildScriptDir, jobName, fileName ,totalInstanceToRun, profiles) {
        sh "scp ${buildScriptDir}/install/*.sh ${server}:/opt/build/"
        sh "ssh -oStrictHostKeyChecking=no ${server} '/opt/build/download.sh ${fileName}'"
        sh "ssh -oStrictHostKeyChecking=no ${server} '/opt/build/start.sh ${jobName} ${fileName} ${totalInstanceToRun} ${profiles}'"
}

