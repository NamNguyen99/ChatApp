class EmojiService
  attr_reader :content

  def initialize content
    @content = content
  end

  def emojify
    content.to_str.gsub(/:([\w+-]+):/) do |match|
      if emoji = Emoji.find_by_alias(match[1..-2])
        emoji.raw
      else
        match
      end
    end if content.present?
  end 
end
