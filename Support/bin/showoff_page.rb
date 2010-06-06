require "fileutils"
require "rubygems"
require "json"

class ShowoffPage
  
  def initialize(file_path, project_path, tmp_path = "/tmp")
    @file_path, @project_path = File.expand_path(file_path), File.expand_path(project_path)
    @tmp_path = tmp_path
  end
  
  def showoff!
    project = "textmate-showoff"
    section = File.basename(File.dirname(@file_path))
    results = {}
    FileUtils.chdir(@tmp_path) do
      FileUtils.rm_rf(project)
      FileUtils.cp_r(@project_path, project)
      FileUtils.chdir(project) do
        solo_page_section = "textmate-showoff"
        FileUtils.cp_r(section, solo_page_section)
        Dir[solo_page_section + "/*.md"].reject { |f| 
          File.basename(f) == File.basename(@file_path) 
        }.each { |f| FileUtils.rm_rf f }
        
        json = JSON.parse(File.read("showoff.json"))
        json["sections"] = [ { "section" => solo_page_section } ]
        File.open("showoff.json", "w") {|f| f << JSON.dump(json)}
        
        FileUtils.rm_rf("static")
        results[:output]    = `showoff static`
        results[:error]     = results[:output] =~ /error/
        results[:url]       = "file://localhost#{FileUtils.pwd}/static/index.html"
        results[:root_path] = FileUtils.pwd
        
        FileUtils.mkdir_p("static/#{solo_page_section}/images")
        Dir[solo_page_section + "/images/*"].each { |f| FileUtils.cp_r f, "static/#{solo_page_section}/images/" }
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
