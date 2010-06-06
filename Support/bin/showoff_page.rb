require "fileutils"

class ShowoffPage
  
  def initialize(page)
    @page = page
    @page = @page.read if @page.respond_to?(:read)
  end
  
  def showoff!
    project = "textmate-showoff"
    FileUtils.chdir("/tmp") do
      `showoff create #{project}` unless File.exist?(project)
      FileUtils.chdir(project) do
        if initial_page = Dir["*/*.md"].first
          File.open(initial_page, "w") do |f|
            f << @page
          end
          FileUtils.rm_rf("static")
          `showoff static`
          return "file://localhost#{FileUtils.pwd}/static/index.html"
        end
      end
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  page = ShowoffPage.new(STDIN.read)
  url = page.showoff!
  print <<-HTML
  <html>
    <head>
      <meta http-equiv="Content-type" content="text/html; charset=utf-8">
      <title>Redirecting...</title>
    </head>
    <body>
      <p>Redirecting to <a id="url" href="#{url}">presentation</a></p>
      <script>
        window.location.href = "#{url}";
      </script>
    </body>
  </html>
  HTML
end