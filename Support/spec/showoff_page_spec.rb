require File.dirname(__FILE__) + "/spec_helper"
require "showoff_page"


describe "showoff_page" do
  describe "single slide on page" do
    before do
      @page = <<-MARKDOWN.gsub(/^      /, '')
      !SLIDE bullets
      # Header #
      
      * Bullet 1
      * Bullet 2
      MARKDOWN
      @stdin = StringIO.new(@page)
    end
    
    it "should generate static showoff presentation for just this page" do
      page = ShowoffPage.new(@stdin)
      url = page.showoff!
      url.should =~ %r{file://localhost(/private)?/tmp/textmate-showoff/static/index.html}
    end
  end
end