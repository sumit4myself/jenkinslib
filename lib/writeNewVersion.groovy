import groovy.json.JsonOutput

def call(jobName, versionInfo) {
    def projectEnvSerialized = JsonOutput.toJson([(versionInfo.major): versionInfo.incremental])
    sh "echo ${projectEnvSerialized} > /home/jenkins/${jobName}.json"
}