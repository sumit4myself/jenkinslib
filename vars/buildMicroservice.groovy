def call(body) {
    def config = [:]
    body.resolveStrategy = Closure.DELEGATE_FIRST
    body.delegate = config
    body()

    node("master") {

        def subjectText
        def bodyText
        
        def jenkinsLibRepository = "https://github.com/sumit4myself/jenkinslib.git";
        def gitRepository = "https://github.com/sumit4myself/EsyCation.git";
        def gitCredentials = "git_user_sumit4myself";
        def workspaceDir = "EsyCation"
    
        def dbFullScriptDir = "jenkinslib/db";
        def buildScriptDir = "jenkinslib/script";
        def gradleModulePath = "";
        def modulePath = "";
        def apacheLocation = "/usr/local/";
    
        try {

            def versionInfo
            def releaseNumber
          
            def distType = "jar"

            stage("Init Job "){
                targetEnvironment = "${TARGET_ENVIRONMENT}";
                array = "${GIT_BRANCH}".split("/");
                releaseBranch = "${array[array.length-1]}";
                echo "Build initlizing for targetEnvironment [${targetEnvironment}] and releaseBranch [${releaseBranch}] "
                echo "ModulePath [${config.modulePath}] "
                echo "Gradle ModulePath [${config.gradleModulePath}] "
                
            }
        
            stage("Checkout") {
              echo "Project Checkout in progress..."
              echo "\tRepository [ " + gitRepository + " ]"
              echo "\tBranch [ ${GIT_BRANCH} ]"
              echo "\tCredential [ " + gitCredentials + " ]"

			  checkout([$class: 'GitSCM', branches: [[name: '${GIT_BRANCH}']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: workspaceDir]], submoduleCfg: [], userRemoteConfigs: [[url: gitRepository, credentialsId: gitCredentials]]])
              echo "JenkinsLib Checkout in progress..."
			  checkout([$class: 'GitSCM', branches: [[name: 'master']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'jenkinslib']], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/sumit4myself/jenkinslib.git', credentialsId: gitCredentials]]])
            }

            stage("Build") {
                echo "Build in progress..."
                if (targetEnvironment == "PROD") {
                    echo "Building a new RELEASE..."
                    versionInfo = getNextVersion(env.JOB_NAME, config.workspaceDir)
                    releaseNumber = versionInfo.version
                } else {
                    echo "Building a new SNAPSHOT..."
                    releaseNumber = "SNAPSHOT"
                }
                releaseNumber = "${releaseNumber}-${releaseBranch}"
                currentBuild.description = "${releaseNumber} - ${COMMENT}"
                sh "chmod +x ${buildScriptDir}/build/build.sh"
                sh "${buildScriptDir}/build/build.sh $workspaceDir $config.gradleModulePath $releaseNumber"
            }

            stage("Package") {   
                   
                echo "Packaging..."
                sh "rm -rf ${buildScriptDir}/dist"
                sh "rm -rf ${buildScriptDir}/db"
                sh "mkdir -p ${buildScriptDir}/dist"
                sh "mkdir -p ${buildScriptDir}/db"
                
                sh "cp -f ${workspaceDir}/build/*.${distType} ${buildScriptDir}/dist/"

                sh "chmod +x ${buildScriptDir}/build/zip.sh"
                sh "${buildScriptDir}/build/zip.sh $releaseNumber"
                    
            }

            stage("Copy To Apcahe Location") {
                sh "chmod +x ${buildScriptDir}/build/archive.sh"
                sh "${buildScriptDir}/build/archive.sh $releaseNumber $apacheLocation"
            }

            stage("Execute DB Script") {
                if (RELEASE.toBoolean()) {
                    archiveArtifacts artifacts: "${buildScriptDir}/temp/*.zip"
                } else {
                    currentBuild.result = "SUCCESS"
                }
            }        

            stage('Deploy') {
                if (HOT_DEPLOY.toBoolean()) {
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
           // sendEmail(subjectText, bodyText)
        }
    }
}