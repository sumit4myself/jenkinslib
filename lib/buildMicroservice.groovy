def call(body) {
    def config = [:]
    body.resolveStrategy = Closure.DELEGATE_FIRST
    body.delegate = config
    body()

    node("master") {

        def subjectText
        def bodyText

        try {

            def versionInfo
            def gitBranchPath
            def ReleaseNumber
            def mvnHome = tool "maven333"
            def pom
            def packageType = "zip"
            def commonsScriptsDir = "commons-scripts"
            def subModuleDir = ""
            def distType = "war"
        
            stage("Checkout") {
                deleteDir()
                
                gitBranchPath = "${AVS_GIT_BRANCH}".split("/")

                echo "Checkout in progress..."
                checkout([$class: "GitSCM", branches: [[name: "${AVS_GIT_BRANCH}"]], doGenerateSubmoduleConfigurations: false, extensions: [[$class: "RelativeTargetDirectory", relativeTargetDir: config.moduleDir]], submoduleCfg: [], userRemoteConfigs: [[url: config.repositoryUrl, credentialsId:"db9a3043-47f7-4274-aa62-7c3cd3b508e8"]]])
                checkout([$class: "GitSCM", branches: [[name: "*/master"]], doGenerateSubmoduleConfigurations: false, extensions: [[$class: "RelativeTargetDirectory", relativeTargetDir: commonsScriptsDir]], submoduleCfg: [], userRemoteConfigs: [[url: "https://Jenkins@fleet.alm.accenture.com/avsbitbucket/scm/avs-m3/99-commons-scripts.git", credentialsId:"db9a3043-47f7-4274-aa62-7c3cd3b508e8"]]])
            }

            stage("Build") {
                echo "Build in progress..."
                
                if (RELEASE.toBoolean()) {
                    echo "Building a new RELEASE..."
                    versionInfo = getNextVersion(env.JOB_NAME, config.moduleDir)
                    ReleaseNumber = versionInfo.version
                } else {
                    echo "Building a new SNAPSHOT..."
                    ReleaseNumber = "SNAPSHOT"
                }
                
                def size = gitBranchPath.length
                def branch = "${gitBranchPath[size-1]}"
                ReleaseNumber = "${ReleaseNumber}-${branch}"
                currentBuild.description = "${ReleaseNumber} - ${Comment}"

                if (config.moduleDir == "livecatalogue-ms") {
                    subModuleDir = "avsbe-livecatalogue-ms/"
                    sh "${mvnHome}/bin/mvn -f ${config.moduleDir}/avsbe-livecatalogue-persistence/pom.xml -B versions:set -DgenerateBackupPoms=false -DnewVersion=${ReleaseNumber}"
                    sh "${mvnHome}/bin/mvn -f ${config.moduleDir}/avsbe-livecatalogue-persistence/pom.xml -P ${MAVEN_ADDITIONAL_PARAM} -Dmaven.test.failure.ignore clean package install"
                } else if (config.moduleDir == "pgw-ms") {
                    subModuleDir = "avsbe-pgw-ms/"
                    sh "${mvnHome}/bin/mvn -f ${config.moduleDir}/avsbe-pgw-persistence/pom.xml -B versions:set -DgenerateBackupPoms=false -DnewVersion=${ReleaseNumber}"
                    sh "${mvnHome}/bin/mvn -f ${config.moduleDir}/avsbe-pgw-persistence/pom.xml -Dmaven.test.failure.ignore clean package install"
                }
                
                sh "${mvnHome}/bin/mvn -f ${config.moduleDir}/${subModuleDir}pom.xml -B versions:set -DgenerateBackupPoms=false -DnewVersion=${ReleaseNumber}"
                if (config.moduleDir == "pinboard-ms" || config.moduleDir == "concurrentstream-ms" || config.moduleDir == "npvrbe-ms") {
                    sh "${mvnHome}/bin/mvn -f ${config.moduleDir}/${subModuleDir}pom.xml -Dmaven.test.failure.ignore clean package install"
                } else if (config.moduleDir == "pgw-ms") {
                    sh "${mvnHome}/bin/mvn -f ${config.moduleDir}/${subModuleDir}pom.xml -P ${MAVEN_ADDITIONAL_PARAM} -Dmaven.test.failure.ignore clean package install"
                } else {
                    sh "${mvnHome}/bin/mvn -f ${config.moduleDir}/${subModuleDir}pom.xml -P ${MAVEN_ADDITIONAL_PARAM} -Dmaven.test.failure.ignore -DCORE_VERSION=${CORE_VERSION} clean package install"
                }

                if (RELEASE.toBoolean()) {
                    pom = readMavenPom file: "${config.moduleDir}/${subModuleDir}pom.xml"
                }
            }

            stage("Package") {
                if (RELEASE.toBoolean()) {
                    if (config.moduleDir == "npvrbe-ms") {
                        subModuleDir = "npvrear/"
                        distType = "ear"
                    }
                    withEnv(["AVS_RELEASE_NUMBER=${ReleaseNumber}"]) {
                        echo "Packaging..."
                        sh "rm -rf ${commonsScriptsDir}/dist"
                        sh "rm -rf ${commonsScriptsDir}/conf"
                        sh "rm -rf ${commonsScriptsDir}/lib"
                        sh "mkdir -p ${commonsScriptsDir}/dist"
                        sh "mkdir -p ${commonsScriptsDir}/conf"
                        sh "mkdir -p ${commonsScriptsDir}/lib"
                        sh "cp -f ${config.moduleDir}/${subModuleDir}target/*.${distType} ${commonsScriptsDir}/dist/"
                        sh "cp -rf ${config.moduleDir}/${subModuleDir}target/conf/* ${commonsScriptsDir}/conf/"
                        sh "cp -rf ${config.moduleDir}/${subModuleDir}target/lib/* ${commonsScriptsDir}/lib/"
                        sh "chmod +x ${commonsScriptsDir}/build/build-ng.sh"
                        sh "chmod +x ${commonsScriptsDir}/scripts/build.sh"
                        sh "${commonsScriptsDir}/build/build-ng.sh"
                    }
                } else {
                    currentBuild.result = "SUCCESS"
                }
            }

            stage("Copy To Apcahe Location") {
                if (RELEASE.toBoolean()) {
                    archiveArtifacts artifacts: "${commonsScriptsDir}/temp/*.zip"
                } else {
                    currentBuild.result = "SUCCESS"
                }
            }

            stage("Execute DB Script") {
                if (RELEASE.toBoolean()) {
                    archiveArtifacts artifacts: "${commonsScriptsDir}/temp/*.zip"
                } else {
                    currentBuild.result = "SUCCESS"
                }
            }        

            stage('Deploy') {
                if (RELEASE.toBoolean() && HOT_DEPLOY.toBoolean() && TEST_SERVER != "") {
                    hotDeploy(TEST_SERVER, pom.groupId, pom.artifactId, packageType, pom.version, versionInfo.major, config.moduleDir)
                } else {
                    currentBuild.result = "SUCCESS"
                }
            }

            stage('Unit Testing') {
                if (RELEASE.toBoolean() && UNIT_TEST.toBoolean() && TEST_SERVER != "") {
                    unitTest(config.moduleDir, commonsScriptsDir, TEST_SERVER)
                } else {
                    currentBuild.result = "SUCCESS"
                }
            }

            stage("Update Project version") {
                if (RELEASE.toBoolean()) {
                    writeNewVersion(env.JOB_NAME, versionInfo)
                } else {
                    currentBuild.result = "SUCCESS"
                }
            }

            stage("Finalize") {
                if (RELEASE.toBoolean()) {
                    currentBuild.description = getBuildDescription(ReleaseNumber, Comment, pom.groupId, pom.artifactId, packageType, pom.version)
                } else {
                    currentBuild.result = "SUCCESS"
                }

                subjectText = "Build finished successfully!"
                bodyText = "Build ${env.JOB_NAME} (${env.BUILD_NUMBER}) successfull!"
            }
        
        } catch (Error) {
            currentBuild.result = "FAILURE"
            println Error
            subjectText = "Build finished unsuccessfully!"
            bodyText = "It appears that ${env.BUILD_URL} is failing, somebody should do something about that!\n Please check console log."
        } finally {
            sendEmail(subjectText, bodyText)
        }
    }
}