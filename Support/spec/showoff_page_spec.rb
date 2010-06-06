require File.dirname(__FILE__) + "/spec_helper"
require "showoff_page"


# TODO - clone current project + set showoff.json to a new file "textmate-showoff/01_slide.md"

describe "showoff_page" do
  describe "single slide on page" do
    it "should generate static showoff presentation for just this page" do
      page_path = File.dirname(__FILE__) + "/../fixtures/test-presentation/one/target_slide.md"
      project_path = File.dirname(__FILE__) + "/../fixtures/test-presentation"
      page = ShowoffPage.new(page_path, project_path)
      results = page.showoff!
      results[:url].should =~ %r{file://localhost(/private)?/tmp/textmate-showoff/static/index.html}
      results[:error].should be_false
      tmp_project_path = results[:root_path]
      json = JSON.parse(File.read(File.join(tmp_project_path, "showoff.json")))
      json["sections"].length.should == 1
      json["sections"].first["section"] == "textmate-showoff"
      File.should be_exist(File.join(tmp_project_path, "static", "textmate-showoff", "images", "bananajour-example.png"))
    end
  end
end