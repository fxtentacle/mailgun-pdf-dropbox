require_relative '../config/config.rb'
require_relative "../lib/app.rb"

describe App do
  describe :extract_pdfs do
    it 'should return correct array of pdfs' do
      link1 = 'http://www.axmag.com/download/pdfurl-guide.pdf'
      link2 = 'http://hughpaxton.files.wordpress.com/2011/11/funny-things-you-didnt-know-maybe.pdf'
      message = {'stripped-text' =>  "some link hehe #{link1} #{link2}", 'subject' => "This ain't your task"}
      App.extract_pdfs(message).should == [{url: link1, subject: "This ain't your task"}, 
                                            {url: link2, subject: "This ain't your task"}]
    end

    it 'should return empty array if given non-String argument' do
      message = {'stripped-text' =>  nil, 'subject' => "This ain't your task"}
      App.extract_pdfs(message).should == []
    end
  end

  describe :download do
    it 'should download files to the right path'
    it 'should not download files which are corrupted'
  end

  describe :upload do

  end
  
end
