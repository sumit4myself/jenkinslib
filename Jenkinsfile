#!/usr/bin/env groovy
import groovy.json.JsonOutput

node("master") {
    
    // =========== USER DEFINED VARS ===========
    def jenkinsUser = "Jenkins";
    def moduleDir01 = "avsbe-core"
    def moduleGitUrl01 = "https://${jenkinsUser}@fleet.alm.accenture.com/avsbitbucket/scm/avs-m3/001-core.git"
    // =========================================

    try {

        def projectVersion
        def incremental
        def projectEnv
        def gitBranchPath
        def ReleaseNumber
        def mvnHome = tool 'maven333'
        def pom
        def packageType = "jar"
		def newIncremental

        stage('Checkout') {
            deleteDir()
            
            gitBranchPath = "${AVS_GIT_BRANCH}".split('/')

            echo "Checkout in progress..."
            checkout([$class: 'GitSCM', branches: [[name: '${AVS_GIT_BRANCH}']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: moduleDir01]], submoduleCfg: [], userRemoteConfigs: [[url: moduleGitUrl01, credentialsId:'db9a3043-47f7-4274-aa62-7c3cd3b508e8']]])
            checkout([$class: 'GitSCM', branches: [[name: '${AVS_GIT_BRANCH}']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'persistence']], submoduleCfg: [], userRemoteConfigs: [[url: 'https://Jenkins@fleet.alm.accenture.com/avsbitbucket/scm/avs-m3/016-persistence.git', credentialsId:'db9a3043-47f7-4274-aa62-7c3cd3b508e8']]])
        }

        stage('Build') {
            echo "Build in progress..."

            if (RELEASE.toString().toBoolean()) {
                echo "Builnding a new RELEASE..."
                def projectJson = readJSON file: "${moduleDir01}/project.json"
                projectVersion = "${projectJson.version}"

                sh "touch /home/jenkins/${env.JOB_NAME}.json"
                sh "cat /home/jenkins/${env.JOB_NAME}.json > ${env.JOB_NAME}.json"
                
                try {
                    projectEnv = readJSON file: "${env.JOB_NAME}.json"
                } catch (JSONException) {
                    projectEnv = readJSON text: /{"${projectVersion}":"000"}/
                }

                if (!projectEnv[projectVersion]) {
                    projectEnv[projectVersion] = "000"
                }
                incremental = projectEnv[projectVersion]
                newIncremental = incremental as Integer
                newIncremental++
                if (newIncremental < 10) {
                    incremental = "00" + newIncremental;
                } else if (newIncremental < 100) {
                    incremental = "0" + newIncremental;
                } else {
                    incremental = newIncremental as String;
                }
                ReleaseNumber = "${projectVersion}-${incremental}"
            } else {
                echo "Builnding a new SNAPSHOT..."
                ReleaseNumber = "SNAPSHOT"
            }

            def size = gitBranchPath.length
            def branch = "${gitBranchPath[size-1]}"
            ReleaseNumber = "${ReleaseNumber}-${branch}"
            currentBuild.description = "${ReleaseNumber} - ${Comment}"

            sh "${mvnHome}/bin/mvn -f persistence/pom.xml -B versions:set -DgenerateBackupPoms=false -DnewVersion=${ReleaseNumber}"
            sh "${mvnHome}/bin/mvn -f persistence/pom.xml -Dmaven.test.failure.ignore clean package install"

            sh "${mvnHome}/bin/mvn -f ${moduleDir01}/pom.xml -B versions:set -DgenerateBackupPoms=false -DnewVersion=${ReleaseNumber}"
            sh "${mvnHome}/bin/mvn -f ${moduleDir01}/pom.xml -Dmaven.test.failure.ignore clean package install"

            if (RELEASE.toString().toBoolean()) {
                pom = readMavenPom file: "${moduleDir01}/pom.xml"
            }
        }

        stage('Store on Nexus') {
            if (ReleaseNumber.contains("SNAPSHOT")) {
                echo "SNAPSHOT dont upload to NEXUS"
                currentBuild.result = "SUCCESS"
            } else {
                echo "Storing on Nexus in progress..."
                sh "${mvnHome}/bin/mvn -f ${moduleDir01}/pom.xml -Dmaven.test.failure.ignore deploy"
            }
        }

        stage('Finalize') {
            if (ReleaseNumber.contains("SNAPSHOT")) {
                currentBuild.result = "SUCCESS"
            } else {
                def urlToDownload = "https://avsdeveng.accenture.com/nexus/service/local/artifact/maven/redirect?r=AVS_Product_M3_Artifacts&g=${pom.groupId}&a=${pom.artifactId}&p=${packageType}&v=${pom.version}";
                currentBuild.description = "${ReleaseNumber} - ${Comment} - <a href=\"${urlToDownload}\">[Download]</a>"
            }
        }
    
        stage('Update Project version') {
            if (ReleaseNumber.contains("SNAPSHOT")) {
                currentBuild.result = "SUCCESS"
            } else {
                echo "Raising minor revision..."
                projectEnv[projectVersion] = newIncremental
                def projectEnvSerialized = JsonOutput.toJson(projectEnv)
                sh "echo ${projectEnvSerialized} > /home/jenkins/${env.JOB_NAME}.json"
            }
        }

    } catch (Error) {
        currentBuild.result = "FAILURE"
        println Error
    }
}