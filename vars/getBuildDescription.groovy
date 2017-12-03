def call(description,finalName) {
    def urlToDownload = "http://build.educoresystems.com/"+finalName;
    return "${description} - <a href=\"${urlToDownload}\">[Download]</a>"
}