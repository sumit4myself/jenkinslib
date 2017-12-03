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
        def apacheLocation = "/opt/build/";
    
        try {

            def versionInfo
            def releaseNumber
            def distType = "jar"
            def hasDatabase = false
            def databaseName = "";
            def finalName
            def incrementalRange;

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
                hasDatabase = config.hasDatabase;
                databaseName = config.databaseName;
                if(config.workspaceDir != null){
                    workspaceDir = config.workspaceDir
                }

                if(targetEnvironment == "DEV"){
                    databaseName = "dev_"+databaseName;
                }else if(targetEnvironment == "UAT"){
                    databaseName = "uat_"+databaseName;
                }

                if (RELEASE.toBoolean()) {
                    versionInfo = getNextVersion(env.JOB_NAME, workspaceDir)
                    releaseNumber = versionInfo.version
                } else {
                    releaseNumber = "SNAPSHOT"
                }
                releaseNumber = "${releaseNumber}-${releaseBranch}"
                finalName =  "${env.JOB_NAME}-${releaseNumber}.${distType}"

                echo "***************************************************************************************************"
                echo "Build initlizing for targetEnvironment [${targetEnvironment}] and releaseBranch [${releaseBranch}] "
                echo "ModulePath [${config.modulePath}] "
                echo "Gradle ModulePath [${config.gradleModulePath}] "
                if(hasDatabase){
                    echo "Database Name [${databaseName}]"
                }
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

            stage("Execute DB Script") {
                if(hasDatabase){
                    echo "Database Name [${databaseName}]"
                } else {
                    currentBuild.result = "SUCCESS"
                }
            }        

            stage('Deploy') {
                if (HOT_DEPLOY.toBoolean()) {
                    hotDeploy("192.168.1.3",finalName);
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
           // sendEmail(subjectText, bodyText)
        }
    }
}