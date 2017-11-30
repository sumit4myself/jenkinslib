def call(subjectText, bodyText) {
    mail subject: subjectText, body: bodyText, to: "luca.martino@accenture.com,rupam.baul@accenture.com,bhanu.reddy@accenture.com,afzal.m.beg@accenture.com,lakshmi.panchumarthi@accenture.com", from: "noreply_jenkins@avs.accenture.com"
}