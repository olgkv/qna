module ApplicationHelper
  def gist_content(link)
    GistParseService.new(link).call
  end
end
