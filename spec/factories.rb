Factory.define :post do |p|
  p.title 'Test Post'
  p.body  'This is some test content!'
  p.published true
  p.tags 'web, code'
end

Factory.define :page do |pg|
  pg.title  'This is a sample page'
  pg.body   'This is some page content'
end
