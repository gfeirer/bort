# Commonly used webrat steps
# http://github.com/brynary/webrat

Cuando /^pulso el botón "(.*)"$/ do |button|
  click_button(button)
end

Cuando /^pulso el (enlace|enlace-ajax|enlace-con-efectos) (.+)$/i do
|tipo, enlace|
 wait_for = case tipo.downcase
 when 'enlace-con-efectos' then :effects
 when 'enlace-ajax' then :ajax
 else :page
 end
 click_link(unquote(enlace), :wait => wait_for)
end

def unquote(str)
      str.gsub(/^"|"$/, '')
end

Cuando /^completo "(.*)" con "(.*)"$/ do |field, value|
  fill_in(field, :with => value) 
end

Cuando /^selecciono "(.*)" de "(.*)"$/ do |field, value|
  selects(field, :with => value) 
end

Cuando /^marco "(.*)"$/ do |field|
  checks(field) 
end

Cuando /^desmarco "(.*)"$/ do |field|
  unchecks(field) 
end

Cuando /^elijo "(.*)"$/ do |field|
  chooses(field)
end

Cuando /^adjunto el fichero "(.*)" a "(.*)" $/ do |path, field|
  attaches_file(field, path)
end

Cuando /^visito (.*)$/ do |page|
  visit case page
  when "la portada"
    "/"
  else
    page
    #raise "Can't find mapping from \"#{page}\" to a path"
  end
end

Entonces /^debería ver "(.*)"$/ do |text|
  response.should contain(text)
  #response.body.should =~ /#{text}/m
end

Entonces /^no debería ver "(.*)"$/ do |text|
  response.should_not contain(text)
  #response.body.should_not =~ /#{text}/m
end
