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
    
        def buildScriptDir = "jenkinslib/script";
        def gradleModulePath = "";
        def modulePath = "";
        def apacheLocation = "/opt/build/";
    
        try {
            def versionInfo
            def releaseNumber
            def distType = "jar" 
            def finalName
            def incrementalRange
            def profiles="cloud"
            def totalInstanceToRun=1
            def serverIp 

            stage("Checkout") {
              echo "Project Checkout in progress..."
              echo "\tRepository [ " + gitRepository + " ]"
              echo "\tBranch [ ${GIT_BRANCH} ]"
              echo "\tCredential [ " + gitCredentials + " ]"

			  checkout([$class: 'GitSCM', branches: [[name: '${GIT_BRANCH}']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: workspaceDir]], submoduleCfg: [], userRemoteConfigs: [[url: gitRepository, credentialsId: gitCredentials]]])
              echo "JenkinsLib Checkout in progress..."
			  checkout([$class: 'GitSCM', branches: [[name: 'master']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'jenkinslib']], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/sumit4myself/jenkinslib.git', credentialsId: gitCredentials]]])
            }

            stage("Init Job variables"){
                targetEnvironment = "${TARGET_ENVIRONMENT}";
                array = "${GIT_BRANCH}".split("/");
                releaseBranch = "${array[array.length-1]}";
                if(config.workspaceDir != null){
                    workspaceDir = config.workspaceDir
                }
                if (RELEASE.toBoolean()) {
                    versionInfo = getNextVersion(env.JOB_NAME, workspaceDir)
                    releaseNumber = versionInfo.version
                } else {
                    releaseNumber = "SNAPSHOT"
                }
                releaseNumber = "${releaseNumber}-${releaseBranch}"
                finalName =  "${env.JOB_NAME}-${releaseNumber}.${distType}"
                
                if(targetEnvironment == "DEV"){
                    serverIp = DEV_SERVER_IP
                }else if(targetEnvironment == "UAT"){
                    serverIp = UAT_SERVER_IP
                }else{
                    serverIp = PROD_SERVER_IP
                }

                echo "***************************************************************************************************"
                echo "Build initlizing for targetEnvironment [${targetEnvironment}] IP [${serverIp}] and releaseBranch [${releaseBranch}] "
                echo "ModulePath [${config.modulePath}] "
                echo "Gradle ModulePath [${config.gradleModulePath}] "
                echo "Release Number [${releaseNumber}] and Final Name [${finalName}]"
                currentBuild.description = "${env.JOB_NAME}-${releaseNumber}-${releaseBranch} - ${COMMENT}"
                echo "***************************************************************************************************"
            }
        
            stage("Build") {
                echo "Build in progress..."
                sh "chmod +x ${buildScriptDir}/build/build.sh"
                sh "${buildScriptDir}/build/build.sh $workspaceDir $config.gradleModulePath $releaseNumber"
            }


            stage("Upload Build") {
                sh "chmod +x ${buildScriptDir}/build/archive.sh"
                sh "${buildScriptDir}/build/archive.sh $workspaceDir $finalName $apacheLocation"
            }

            stage('Deploy') {
                if (HOT_DEPLOY.toBoolean()) {
                    hotDeploy(serverIp,buildScriptDir,env.JOB_NAME,finalName,totalInstanceToRun,profiles);
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
                    currentBuild.description = getBuildDescription(currentBuild.description,finalName)
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
           echo "***************************************************************************************************"
           echo "Sending Email"
           echo "Subject : ${subjectText}"
           echo "Maessage : ${bodyText}"
           sendEmail(subjectText, bodyText)
           echo "***************************************************************************************************"
        }
    }
}