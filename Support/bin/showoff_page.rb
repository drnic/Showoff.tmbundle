require "fileutils"
require "rubygems"
require "json"

class ShowoffPage
  
  def initialize(file_path, project_path)
    @file_path, @project_path = File.expand_path(file_path), File.expand_path(project_path)
    p @file_path
    p @project_path
  end
  
  def showoff!
    project = "textmate-showoff"
    section = File.basename(File.dirname(@file_path))
    results = {}
    FileUtils.chdir("/tmp") do
      FileUtils.rm_rf(project)
      FileUtils.cp_r(@project_path, project)
      FileUtils.chdir(project) do
        FileUtils.rm_rf("static")
        json = JSON.parse(File.read("showoff.json"))
        json["sections"] = [ { "section" => section } ]
        File.open("showoff.json", "w") {|f| f << JSON.dump(json)}
        results[:output] = `showoff static`
        results[:error]  = results[:output] =~ /error/
        results[:url]    = "file://localhost#{FileUtils.pwd}/static/index.html"
      end
    end
    results
  end
end

if __FILE__ == $PROGRAM_NAME
  page = ShowoffPage.new(ENV['TM_FILEPATH'], ENV['TM_PROJECT_DIRECTORY'])
  results = page.showoff!
  url = results[:url]
  if results[:error]
    body = <<-HTML
    <h2>Errors</h2>
    <pre>
    #{results[:output]}
    </pre>
    HTML
  else
    body = <<-HTML
    <p>Redirecting to <a id="url" href="#{url}">presentation</a></p>
    <pre>
    #{results[:output]}
    </pre>
    <script>
      window.location.href = "#{url}";
    </script>
    HTML
  end
  print <<-HTML
  <html>
    <head>
      <meta http-equiv="Content-type" content="text/html; charset=utf-8">
      <title>Showoff.tmbundle</title>
    </head>
    <body>
      #{body}
    </body>
  </html>
  HTML
end
