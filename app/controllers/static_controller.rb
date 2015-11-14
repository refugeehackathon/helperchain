class StaticController < ApplicationController
  def index
    @helper = Helper.new
    @nocontainer = true
  end

  def faq
    @page_title=I18n.t "faq.title"
  end

  def contactimprint
    @page_title=I18n.t "nav.imprint"
  end
end
