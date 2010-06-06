require "fileutils"

class ShowoffPage
  
  def initialize(page)
    @page = page
    @page = @page.read if @page.respond_to?(:read)
  end
  
  def showoff!
    project = "textmate-showoff"
    results = {}
    FileUtils.chdir("/tmp") do
      `showoff create #{project}` unless File.exist?(project)
      FileUtils.chdir(project) do
        if initial_page = Dir["*/*.md"].first
          File.open(initial_page, "w") do |f|
            f << @page
          end
          FileUtils.rm_rf("static")
          results[:output] = `showoff static`
          results[:error]  = results[:output] =~ /error/
          results[:url]    = "file://localhost#{FileUtils.pwd}/static/index.html"
        end
      end
    end
    results
  end
end

if __FILE__ == $PROGRAM_NAME
  page = ShowoffPage.new(STDIN.read)
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
      <title>Redirecting...</title>
    </head>
    <body>
      #{body}
    </body>
  </html>
  HTML
end
