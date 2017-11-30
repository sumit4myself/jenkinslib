def call(releaseNumber, comment, pomGroupId, pomArtifactId, packageType, pomVersion) {
    def urlToDownload = "https://avsdeveng.accenture.com/nexus/service/local/artifact/maven/redirect?r=AVS_Product_M3_Artifacts&g=${pomGroupId}&a=${pomArtifactId}&p=${packageType}&v=${pomVersion}";
    return "${releaseNumber} - ${comment} - <a href=\"${urlToDownload}\">[Download]</a>"
}