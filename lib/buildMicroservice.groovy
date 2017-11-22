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
        def gradleModulePath = ":esycation-service-discovery-server";
        def modulePath = "esycation-service-discovery-server";
    
        try {

            def versionInfo
            def ReleaseNumber
          
            def distType = "jar"

            stage("Init Job "){
                buildType = "${BUILD_TYPE}";
                if (buildType == 'DEV') {
                        gitBranch = 'develop'
                } else if (buildType == 'DEMO') {
                        gitBranch = 'demo'
                } else {
                        gitBranch = 'master'
                }
            }
        
            stage("Checkout") {
              echo "Project Checkout in progress..."
			  checkout([$class: 'GitSCM', branches: [[name: gitBranch]], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: workspaceDir]], submoduleCfg: [], userRemoteConfigs: [[url: gitRepository, credentialsId: gitCredentials]]])
              echo "JenkinsLib Checkout in progress..."
			  checkout([$class: 'GitSCM', branches: [[name: 'master']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'jenkinslib']], submoduleCfg: [], userRemoteConfigs: [[url: jenkinsLibRepository, credentialsId: gitCredentials]]])
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

                sh "${buildScriptDir}/build/build.sh $workspaceDir $gradleModulePath $versionInfo"
                
            }

            stage("Package") {   
                    withEnv(["AVS_RELEASE_NUMBER=${ReleaseNumber}"]) {
                        echo "Packaging..."
                        sh "rm -rf ${buildScriptDir}/dist"
                        sh "rm -rf ${buildScriptDir}/db"
                        sh "mkdir -p ${buildScriptDir}/dist"
                        sh "mkdir -p ${buildScriptDir}/db"
                     
                        sh "cp -f ${config.workspaceDir}/build/*.${distType} ${commonsScriptsDir}/dist/"
                        sh "cp -rf ${config.workspaceDir}/${subModuleDir}target/conf/* ${commonsScriptsDir}/conf/"
                       
                        sh "chmod +x ${buildScriptDir}/build/zip.sh"
                        sh "${buildScriptDir}/build/zip.sh"
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