function tag_list(q)
{
  var all_tags = db.eval(
    function(q)
    {
      var tags = [];
      db.posts.find(q).forEach(
        function(p)
        {
          if (p.tags)
          {
            p.tags.forEach(
              function(tag)
              {
                tags.push(tag)
              }
            )
          }
        }
      )
      return tags;
    }
  )
  return all_tags;
}
