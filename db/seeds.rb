# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
piazza_feed_file = "#{Rails.root}/data/piazza_my_feed.json"
piazza_post_file = -> id { "#{Rails.root}/data/piazza-data/#{id}.json" }

if File.exist?(piazza_feed_file)
  piazza_feed = File.read(piazza_feed_file)

  puts "add tags"
  tags = Tag.insert_all(
    JsonPath.on(piazza_feed, "$.result.tags.instructor_upd")[0].keys.map { {name: _1} }
  )
  puts "added #{tags.rows.size} tags."

  print "import posts "
  JsonPath.on(piazza_feed, "$.result.feed[*]").each do |feed|
    post_id = feed["nr"]

    post_json =
      if File.exist? piazza_post_file[post_id]
        File.read(piazza_post_file[post_id])
      end || "{}"

    content = ""
    unless post_json.blank?
      content = JsonPath.on(post_json, "$.result.history[0].content")[0]
      if content.start_with? "<md>"
        content = CommonMarker.render_html(content.delete_prefix("<md>").delete_suffix("</md>"), :DEFAULT)
        print "m"
      end
    end

    post_tags = feed["folders"].map { Tag.find_or_create_by!(name: _1) }
    pin = feed["tags"].include? "pin"
    instructor_note = feed["tags"].include? "instructor-note"

    Post.create!(
      title: Nokogiri::HTML.parse(feed["subject"]).text,
      tags: post_tags,
      raw_feed: feed,
      raw_post: JSON.parse(post_json),
      cid: post_id,
      post_type: feed["type"],
      content: content,
      created_at: JsonPath.on(post_json, "$.result.created")[0],
      updated_at: JsonPath.on(post_json, "$.result.change_log[-1].when")[0],
      pin: pin,
      instructor_note: instructor_note
    )

    print "."
  end
  puts
end
