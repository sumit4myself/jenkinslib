def call(subjectText, bodyText) {
    mail subject: subjectText, body: bodyText, to: "sumit4myself@gmail.com", from: "noreply_jenkins@avs.accenture.com"
}