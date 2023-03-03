# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
require "debug"

# define previous piazza data path
piazza_feed_file = "#{Rails.root}/data/piazza_my_feed.json"
piazza_post_file = -> id { "#{Rails.root}/data/piazza-data/#{id}.json" }

def content_to_rich_text(content)
  return "" if content.nil?

  content.gsub!(/(<md>[\s\S]+?<\/md>)/m) do |md|
    CommonMarker.render_html(
      Nokogiri::HTML.parse(
        md
          .delete_prefix("<md>")
          .delete_suffix("</md>")
          .gsub(/<br \/>/, "\n")
      ).text, :DEFAULT)
      .tap { print("m") }
  end
  content
end

def create_comment(commentable, comment_json)
  commentable.comments.create!(
    rich_content: comment_content(comment_json),
    created_at: comment_json["created"],
    updated_at: comment_json["updated"],
    raw_comment: comment_json,
    type: comment_json["type"],
    content_type: "rich_content",
  )
end

def comment_content(comment_json)
  content = ""
  if comment_json["type"] == "s_answer"
    if comment_json["history"]
      content = content_to_rich_text(comment_json["history"][0]["content"])
    end
  else
    content = content_to_rich_text(comment_json["subject"])
  end
  content
end

def parse_html_entities(content)
  Nokogiri::HTML.parse(content).text
end

def img_to_attachment(record, attr_name)
  rich_text = record.send(attr_name)
  if rich_text && rich_text.body.to_s =~ /(<img src="(\S+)?".+?>)/
    body = rich_text.body.to_html
    body.scan(/(<img src="(\S+)?".+?>)/).each do |tag, path|
      if path.start_with?("/redirect/")
        uri = path
        path = "/img/#{SecureRandom.uuid}.#{path.split('.')[-1]}"
        puts uri
        `curl -o "#{Rails.root}/data#{path}" -L "https://piazza.com#{uri}"`
      end
      if File.exist?("#{Rails.root}/data#{path}")
        filename = File.basename(path)
        blob = ActiveStorage::Blob.create_and_upload!(
          io: File.open("#{Rails.root}/data#{path}"),
          filename: filename
        )
        blob.analyze
        image_path = Rails.application.routes.url_helpers.rails_blob_path(blob, only_path: true)
        attachment = ActionText::Attachment.from_attachable(blob)

        print('i')
        body.gsub!(tag, attachment.to_html)  # .gsub(/(filename=\"#{filename}\")/, " url=\"#{image_path}\" #{$1} ")
      end
    end
    rich_text.update(body: ActionText::Content.new(body))
  end
end

# start import
if File.exist?(piazza_feed_file)
  piazza_feed = File.read(piazza_feed_file)

  print "import posts "
  JsonPath.on(piazza_feed, "$.result.feed[*]").each do |feed|
    post_id = feed["nr"]

    post_json =
      if File.exist? piazza_post_file[post_id]
        File.read(piazza_post_file[post_id])
      end || "{}"

    post = Post.create!(
      title: Nokogiri::HTML.parse(feed["subject"]).text,
      folder_list: feed["folders"].map { |it| parse_html_entities(it) },
      tag_list: feed["tags"].map { |it| parse_html_entities(it) },
      raw_feed: feed,
      raw_post: JSON.parse(post_json),
      cid: post_id,
      post_type: feed["type"],
      rich_content: content_to_rich_text(JsonPath.on(post_json, "$.result.history[0].content")[0]),
      created_at: JsonPath.on(post_json, "$.result.created")[0],
      updated_at: JsonPath.on(post_json, "$.result.change_log[-1].when")[0],
      pin: feed["tags"].include?("pin"),
      instructor_note: feed["tags"].include?("instructor-note"),
      content_type: "rich_content",
    )
    print "p"
    img_to_attachment(post, :rich_content)

    JsonPath.on(post_json, "$.result.children[*]").each do |comment_json|
      post_comment = create_comment(post, comment_json)
      img_to_attachment(post_comment, :rich_content)
      print "c"
      if comment_json["children"].any?
        comment_json["children"].each do |reply_json|
          comment = create_comment(post_comment, reply_json)
          print "d"
          img_to_attachment(comment, :rich_content)
        end
      end
    end
  end
  puts
end
