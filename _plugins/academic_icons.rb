module Jekyll
  class AcademicIconsTag < Liquid::Tag

    def render(context)
      if tag_contents = determine_arguments(@markup.strip)
        icon_class, icon_extra = tag_contents[0], tag_contents[1]
        icon_tag(icon_class, icon_extra)
      else
        raise ArgumentError.new <<-eos
Syntax error in tag 'icon' while parsing the following markup:
  #{@markup}
Valid syntax:
  for icons: {% icon fa-camera-retro %}
  for icons with size/spin/rotate: {% icon fa-camera-retro fa-lg %}
eos
      end
    end

    private

    def determine_arguments(input)
      matched = input.match(/\A(\S+) ?(\S+)?\Z/)
      [matched[1].to_s.strip, matched[2].to_s.strip] if matched && matched.length >= 3
    end

    def icon_tag(icon_class, icon_extra = nil)
      if icon_extra.empty?
        "<i class=\"ai #{icon_class} ai-3x\"></i>"
      else
        "<i class=\"ai #{icon_class} #{icon_extra} ai-3x\"></i>"
      end
    end
  end
end

Liquid::Template.register_tag('acad', Jekyll::AcademicIconsTag)
