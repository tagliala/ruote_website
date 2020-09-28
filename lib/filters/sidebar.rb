#
# Re-opening the item class to add some methods.
#
class Nanoc::Core::CompilationItemView

  def title
    t = self[:title]
    return t.match(/^(.*) expression$/)[1] if self.path.split('/')[1] == 'exp'
    t
  end
end


class SidebarFilter < Nanoc::Filter
  identifier :sidebar

  def run (content, params)

    items = if @item.path.split('/')[1] == 'exp'

      @items.select { |i| i.path.split('/')[1] == 'exp' }

    elsif @item.path.split('/')[1] == 'part'

      @items.select { |i| i.path.split('/')[1] == 'part' }

    else

      @items.reject { |i|
        i[:title].nil? ||
        (
          [ nil ] + %w[
            css js ja images rel exp part
            lists users download source resources presentations
            documentation
          ]
        ).include?(i.path.split('/')[1])
      }
    end

    items = items.sort_by { |i| i[:side_title] || i[:title] }

    head_item = if @item.path.split('/')[1] == 'exp'
      @items.find { |i| i.path == 'expressions' }
    elsif @item.path.split('/')[1] == 'part'
      @items.find { |i| i.path == 'participants' }
    else
      nil
    end

    content.gsub(
      'SIDEBAR',
      render('sidebar', :items => items, :head_item => head_item))
  end
end

