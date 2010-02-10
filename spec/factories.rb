Factory.define :post do |p|
  p.title 'Test Post'
  p.body  'This is some test content!'
  p.published true
  p.tags 'web, code'
end

Factory.define :page do |pg|
  pg.title  "About"
  pg.body   "This is my about page.\n\nHere is some about content."
end
