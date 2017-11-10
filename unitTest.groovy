def call(modulePath, commonsScriptsDir, testServer) {
    if (fileExists("${modulePath}/src/test/jmeter/jmeter.jmx")) {
        echo "Unit Testing by JMeter..."
        sh "chmod +x ${commonsScriptsDir}/jmeter/jmeter.sh"
        sh "touch jmeter.jtl"
        sh "${commonsScriptsDir}/jmeter/jmeter.sh ${modulePath}/src/test/jmeter/jmeter.jmx -Jserver_name=${testServer} -Jserver_port=8080 -Jjmeter.save.saveservice.output_format=xml;"
        performanceReport compareBuildPrevious: false, configType: 'ART', errorFailedThreshold: 20, errorUnstableResponseTimeThreshold: '', errorUnstableThreshold: 5, failBuildIfNoResultFile: false, modeOfThreshold: false, modePerformancePerTestCase: true, modeThroughput: false, nthBuildNumber: 0, parsers: [[$class: 'JMeterParser', glob: '**/*.jtl']], relativeFailedThresholdNegative: 0, relativeFailedThresholdPositive: 0, relativeUnstableThresholdNegative: 0, relativeUnstableThresholdPositive: 0
    }
}