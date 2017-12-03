def call(jobName, workspaceDir) {
    def projectEnv
    def projectProperties = readProperties  file: "${workspaceDir}/gradle.properties"
    def projectVersion = "${projectProperties['version']}"

    echo "Getting next version for project [${jobName}], Version [${projectVersion}] "
    sh "touch /home/jenkins/${jobName}.json"
    sh "cat /home/jenkins/${jobName}.json > ${jobName}.json"
    try {
        projectEnv = readJSON file: "${jobName}.json"
    } catch (JSONException) {
        projectEnv = readJSON text: /{"${projectVersion}":"000"}/
    }
    if (!projectEnv[projectVersion]) {
        projectEnv[projectVersion] = "000"
    }
    incremental = projectEnv[projectVersion]
    def newIncremental = incremental as Integer
    newIncremental++
    if (newIncremental < 10) {
        incremental = "00" + newIncremental;
    } else if (newIncremental < 100) {
        incremental = "0" + newIncremental;
    } else {
        incremental = newIncremental as String;
    }
    return [version:"${projectVersion}-${incremental}", major: projectVersion, incremental: newIncremental]
}