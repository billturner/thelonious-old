class Thelonious

  module Helpers

    def site_title(page_title = nil)
      page_title.nil? ? "#{BLOG_DESCRIPTION} | #{BLOG_TITLE}" : "#{page_title} | #{BLOG_TITLE}"
    end

    def permalink_url(post)
      "#{BLOG_URL}/#{post.published_at.strftime('%Y/%m')}/#{post.slug}"
    end

    def tag_url(tag)
      "#{BLOG_URL}/tag/#{Rack::Utils.escape(tag)}"
    end

    def page_url(page)
      "#{BLOG_URL}/page/#{page.slug}"
    end

    def markdown(text)
      RDiscount.new(text, :smart).to_html
    end

    def cdata(text)
      "<![CDATA[#{text}]]>"
    end

    def cdata_and_escape(text)
      "<![CDATA[#{Rack::Utils.escape_html(text)}]]>"
    end

    def authenticate!
      redirect '/login' unless logged_in?
    end

    def logged_in?
      session[:user]
    end

    def creation_form?
      ['/new_post', '/new_page'].include?(request.path_info)
    end

  end

  helpers Helpers

end
