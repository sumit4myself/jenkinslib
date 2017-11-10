def call(testServer, pomGroupId, pomArtifactId, packageType, pomVersion, release, modulePath) {
    sshagent(['6c1d8ef5-bc09-4ee4-9362-879bf8700df7']) {
        sh "ssh -o StrictHostKeyChecking=no -l jboss  ${testServer} ./downloadArtifact.sh \"https://avsdeveng.accenture.com/nexus/service/local/artifact/maven/redirect?r=AVS_Product_M3_Artifacts\" \"${pomGroupId}\" \"${pomArtifactId}\" \"${packageType}\" \"${pomVersion}\" \"${release}\" \"${modulePath}\""
    }
}