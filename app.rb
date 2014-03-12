require 'bundler/setup'
require 'sinatra/base'
require 'rdiscount'

class Haro < Sinatra::Base
 
  get '/*' do |path|
    @title = 'Haro ｜ 山村研究室 情報共有システム'
    @path = Pathname(PAGE_DIR + path)
    raise 'Not Found!' unless @path.exist?

    if @path.file?
      if @path.extname == '.md'
        md_file @path
      else
        @path.open.read
      end
    else
      if (@path + 'index.md').file?
        md_file (@path + 'index.md')
      else
        haml :dir
      end
    end

  end

  def md_file(path)
    @content = markdown path.open.read
    haml :file
  end

end

class Pathname
  def files
    self.children.select do |file|
      !file.basename.to_s.match(/^\./)
    end
  end

  def relative
    self.to_s.gsub(/^#{PAGE_DIR}/, '')
  end

  def to_url
    '/' + self.relative
  end
end
