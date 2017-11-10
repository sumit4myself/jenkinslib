def call(commonsScriptsDir, jobName, releaseNumber, pomGroupId, pomArtifactId, packageType, pomVersion) {
    def artifactFilepath = "${commonsScriptsDir}/temp/${jobName}_REL_${releaseNumber}.zip"
    echo "groupId    = ${pomGroupId}"
    echo "artifactId = ${pomArtifactId}"
    echo "version    = ${pomVersion}"
    nexusPublisher nexusInstanceId: 'avsnexus', nexusRepositoryId: 'AVS_Product_M3_Artifacts', packages: [[$class: 'MavenPackage', mavenAssetList: [[classifier: '', extension: '', filePath: artifactFilepath]], mavenCoordinate: [artifactId: pomArtifactId, groupId: pomGroupId, packaging: packageType, version: pomVersion]]]
}